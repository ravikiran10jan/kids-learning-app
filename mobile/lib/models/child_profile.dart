import 'subject.dart';

class ChildProfile {
  final String id;
  int coins;
  int weeklyGoalDays;
  int weeklyDaysPracticed;
  int dailyGoalLessons;
  int dailyLessonsCompleted;
  List<String> trophyUnitIds;
  List<String> petItems;
  List<String> equippedPetItems;
  int contentVersion;
  Subject? lastSubject;
  Map<String, int> skillMastery; // skillId -> mastery percentage
  int currentStreak; // consecutive days of practice
  int bestStreak; // best streak ever achieved
  String? lastPracticeDate; // ISO date string of last practice day
  int totalLessonsCompleted; // lifetime total
  int lessonsThisStreak; // lessons done during current streak

  ChildProfile({
    required this.id,
    this.coins = 0,
    this.weeklyGoalDays = 4,
    this.weeklyDaysPracticed = 0,
    this.dailyGoalLessons = 2,
    this.dailyLessonsCompleted = 0,
    this.trophyUnitIds = const [],
    this.petItems = const [],
    this.equippedPetItems = const [],
    this.contentVersion = 1,
    this.lastSubject,
    this.skillMastery = const {},
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastPracticeDate,
    this.totalLessonsCompleted = 0,
    this.lessonsThisStreak = 0,
  });

  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      id: json['id'] ?? '',
      coins: json['coins'] ?? 0,
      weeklyGoalDays: json['weeklyGoalDays'] ?? 4,
      weeklyDaysPracticed: json['weeklyDaysPracticed'] ?? 0,
      dailyGoalLessons: json['dailyGoalLessons'] ?? 2,
      dailyLessonsCompleted: json['dailyLessonsCompleted'] ?? 0,
      trophyUnitIds: List<String>.from(json['trophyUnitIds'] ?? []),
      petItems: List<String>.from(json['petItems'] ?? []),
      equippedPetItems: List<String>.from(json['equippedPetItems'] ?? []),
      contentVersion: json['contentVersion'] ?? 1,
      lastSubject: json['lastSubject'] != null
          ? parseSubject(json['lastSubject'])
          : null,
      currentStreak: json['currentStreak'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      lastPracticeDate: json['lastPracticeDate'],
      totalLessonsCompleted: json['totalLessonsCompleted'] ?? 0,
      lessonsThisStreak: json['lessonsThisStreak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'coins': coins,
        'weeklyGoalDays': weeklyGoalDays,
        'weeklyDaysPracticed': weeklyDaysPracticed,
        'dailyGoalLessons': dailyGoalLessons,
        'dailyLessonsCompleted': dailyLessonsCompleted,
        'trophyUnitIds': trophyUnitIds,
        'petItems': petItems,
        'equippedPetItems': equippedPetItems,
        'contentVersion': contentVersion,
        'lastSubject': lastSubject?.name,
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'lastPracticeDate': lastPracticeDate,
        'totalLessonsCompleted': totalLessonsCompleted,
        'lessonsThisStreak': lessonsThisStreak,
      };
}
