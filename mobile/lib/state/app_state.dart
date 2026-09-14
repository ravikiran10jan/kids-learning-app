import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_profile.dart';
import '../models/subject.dart';
import '../models/lesson.dart';
import '../models/lesson_result.dart';
import '../models/item.dart';
import '../models/demo_data.dart';
import '../models/math_content.dart';
import '../models/english_content.dart';
import '../models/homework_content.dart';
import '../models/skill.dart';
import '../services/api_service.dart';
import '../utils/sound_util.dart';

/// Top-level sections shown as tabs on the Home screen.
/// Homework sits alongside the two curriculum subjects.
enum HomeSection { math, english, homework }

HomeSection parseHomeSection(String? s) {
  if (s == null) return HomeSection.math;
  return HomeSection.values.firstWhere(
    (e) => e.name == s,
    orElse: () => HomeSection.math,
  );
}

class AppState extends ChangeNotifier {
  final ApiService _api = ApiService();
  ChildProfile _profile = ChildProfile(id: 'default');
  HomeSection _currentSection = HomeSection.math;
  bool _loaded = false;
  Map<String, int> _skillMastery = {};
  int _currentStreak = 0;
  int _bestStreak = 0;
  int _totalLessonsCompleted = 0;
  int _lessonsThisStreak = 0;
  String? _lastPracticeDate;
  bool _streakJustIncreased = false; // flag for UI celebration

  ChildProfile get profile => _profile;
  HomeSection get currentSection => _currentSection;

  /// Curriculum subject backing the current section.
  /// Homework is English-based, so it maps to ENGLISH.
  Subject get currentSubject =>
      _currentSection == HomeSection.math ? Subject.MATH : Subject.ENGLISH;
  bool get loaded => _loaded;
  Map<String, int> get skillMastery => _skillMastery;
  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;
  int get totalLessonsCompleted => _totalLessonsCompleted;
  int get lessonsThisStreak => _lessonsThisStreak;
  bool get streakJustIncreased => _streakJustIncreased;

  Future<void> init() async {
    await _api.checkConnection();
    await _loadProfile();
    _loaded = true;
    notifyListeners();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('profile_name') ?? '';
    if (name.isNotEmpty) {
      _currentStreak = prefs.getInt('streak_current') ?? 0;
      _bestStreak = prefs.getInt('streak_best') ?? 0;
      _totalLessonsCompleted = prefs.getInt('total_lessons') ?? 0;
      _lessonsThisStreak = prefs.getInt('lessons_this_streak') ?? 0;
      _lastPracticeDate = prefs.getString('last_practice_date');

      // Check if streak is still valid (today or yesterday)
      _validateStreak();

      _profile = ChildProfile(
        id: prefs.getString('profile_id') ?? 'default',
        coins: prefs.getInt('coins') ?? 0,
        dailyLessonsCompleted: prefs.getInt('daily_lessons') ?? 0,
        skillMastery: _loadMastery(prefs),
        currentStreak: _currentStreak,
        bestStreak: _bestStreak,
        lastPracticeDate: _lastPracticeDate,
        totalLessonsCompleted: _totalLessonsCompleted,
        lessonsThisStreak: _lessonsThisStreak,
      );
      _currentSection = parseHomeSection(prefs.getString('last_section'));
      _skillMastery = Map.from(_profile.skillMastery);
    }
  }

  void _validateStreak() {
    if (_lastPracticeDate == null) return;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final yesterday = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 1)));

    if (_lastPracticeDate != today && _lastPracticeDate != yesterday) {
      // Streak broken — reset
      _currentStreak = 0;
      _lessonsThisStreak = 0;
    }

    // Reset daily lessons if it's a new day
    if (_lastPracticeDate != today) {
      _profile = ChildProfile(
        id: _profile.id,
        coins: _profile.coins,
        dailyLessonsCompleted: 0,
        skillMastery: _profile.skillMastery,
      );
    }
  }

  Map<String, int> _loadMastery(SharedPreferences prefs) {
    final keys = prefs.getKeys().where((k) => k.startsWith('mastery_'));
    final map = <String, int>{};
    for (final k in keys) {
      map[k.replaceFirst('mastery_', '')] = prefs.getInt(k) ?? 0;
    }
    return map;
  }

  Future<void> setProfileName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _profile = ChildProfile(
      id: name.toLowerCase().replaceAll(' ', '_'),
      coins: _profile.coins,
      skillMastery: _skillMastery,
      currentStreak: _currentStreak,
      bestStreak: _bestStreak,
      lastPracticeDate: _lastPracticeDate,
      totalLessonsCompleted: _totalLessonsCompleted,
      lessonsThisStreak: _lessonsThisStreak,
    );
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_id', _profile.id);
    notifyListeners();
  }

  void setSection(HomeSection section) {
    _currentSection = section;
    _saveLastSection();
    notifyListeners();
  }

  void setSubject(Subject s) {
    setSection(s == Subject.MATH ? HomeSection.math : HomeSection.english);
  }

  Future<void> _saveLastSection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_section', _currentSection.name);
  }

  /// Get all skills for current subject (original + Cambridge)
  List<Skill> get currentSkills {
    final original = allDemoSkills
        .where((s) => s.subject == currentSubject)
        .toList();

    final cambridge = currentSubject == Subject.MATH
        ? mathCambridgeSkills
        : englishCambridgeSkills;

    // Return Cambridge skills first (primary curriculum), then originals
    return [...cambridge, ...original];
  }

  List<Item> itemsForSkillId(String skillId) {
    return itemsForSkill(skillId);
  }

  int masteryForSkill(String skillId) {
    return _skillMastery[skillId] ?? 0;
  }

  bool isSkillUnlocked(Skill skill) {
    if (skill.prerequisites.isEmpty) return true;
    return skill.prerequisites.every((pId) => (_skillMastery[pId] ?? 0) >= 50);
  }

  Lesson composeDemoLesson(String skillId) {
    final items = itemsForSkill(skillId);
    items.shuffle();
    // Homework lessons include all assigned words; regular lessons cap at 7
    final isHomework = homeworkSkills.any((s) => s.id == skillId);
    final count = isHomework ? items.length : (items.length > 7 ? 7 : items.length);
    final selected = items.take(count).toList();
    return Lesson(
      id: 'lesson_${DateTime.now().millisecondsSinceEpoch}',
      skillId: skillId,
      exercises: selected,
      newCount: selected.length,
    );
  }

  Future<void> completeLesson(LessonResult result) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final wasYesterday = _lastPracticeDate ==
        DateFormat('yyyy-MM-dd')
            .format(DateTime.now().subtract(const Duration(days: 1)));

    // Update streak logic
    if (_lastPracticeDate != today) {
      // New day — check if streak continues
      if (_lastPracticeDate == null || wasYesterday) {
        _currentStreak += 1;
        _streakJustIncreased = true;

        // Play streak celebration sound
        if (_currentStreak >= 3) {
          await SoundUtil.playStreakMilestone(_currentStreak);
        }
      } else {
        // Streak broken, start new
        _currentStreak = 1;
        _lessonsThisStreak = 0;
        _streakJustIncreased = false;
      }
      _lastPracticeDate = today;
      _lessonsThisStreak = 0; // reset for new day
    }

    _lessonsThisStreak += 1;
    if (_currentStreak > _bestStreak) {
      _bestStreak = _currentStreak;
    }
    _totalLessonsCompleted += 1;

    // Update coins
    _profile.coins += result.coinsEarned;
    _profile.dailyLessonsCompleted += 1;
    _profile.currentStreak = _currentStreak;
    _profile.bestStreak = _bestStreak;
    _profile.lastPracticeDate = _lastPracticeDate;
    _profile.totalLessonsCompleted = _totalLessonsCompleted;
    _profile.lessonsThisStreak = _lessonsThisStreak;

    // Update mastery
    final accuracy = result.totalExercises > 0
        ? (result.firstTryCorrectCount / result.totalExercises * 100).round()
        : 0;
    final currentMastery = _skillMastery[result.skillId] ?? 0;
    _skillMastery[result.skillId] =
        currentMastery < accuracy ? accuracy : currentMastery;
    _profile.skillMastery = Map.from(_skillMastery);

    // Persist
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', _profile.coins);
    await prefs.setInt('daily_lessons', _profile.dailyLessonsCompleted);
    await prefs.setInt('streak_current', _currentStreak);
    await prefs.setInt('streak_best', _bestStreak);
    await prefs.setInt('total_lessons', _totalLessonsCompleted);
    await prefs.setInt('lessons_this_streak', _lessonsThisStreak);
    await prefs.setString('last_practice_date', _lastPracticeDate ?? '');
    await prefs.setInt('mastery_${result.skillId}', _skillMastery[result.skillId]!);

    // Try to submit to backend (fire-and-forget)
    _api.submitLesson(result);

    notifyListeners();
  }

  void clearStreakIncreased() {
    _streakJustIncreased = false;
    notifyListeners();
  }

  bool get hasProfile {
    return _profile.id != 'default' || _loaded;
  }
}
