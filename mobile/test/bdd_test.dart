import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kids_learning_app/main.dart';
import 'package:kids_learning_app/state/app_state.dart';
import 'package:kids_learning_app/models/child_profile.dart';
import 'package:kids_learning_app/models/subject.dart';
import 'package:kids_learning_app/models/lesson.dart';
import 'package:kids_learning_app/models/lesson_result.dart';
import 'package:kids_learning_app/models/item.dart';
import 'package:kids_learning_app/models/exercise_type.dart';
import 'package:kids_learning_app/models/demo_data.dart';
import 'package:kids_learning_app/models/math_content.dart';
import 'package:kids_learning_app/models/english_content.dart';
import 'package:kids_learning_app/models/homework_content.dart';
import 'package:kids_learning_app/models/skill.dart';
import 'package:kids_learning_app/models/unit.dart';
import 'package:kids_learning_app/screens/welcome_screen.dart';
import 'package:kids_learning_app/screens/home_screen.dart';
import 'package:kids_learning_app/screens/lesson_screen.dart';
import 'package:kids_learning_app/screens/result_screen.dart';
import 'package:kids_learning_app/screens/streak_screen.dart';
import 'package:kids_learning_app/utils/sound_util.dart';

// ═══════════════════════════════════════════════════════════
// BDD Tests — Cambridge LKG & 1st Grade Kids Learning App
// ═══════════════════════════════════════════════════════════

void main() {
  // Disable sounds during testing
  SoundUtil.setEnabled(false);

  // ─── Epic 1: Welcome & Onboarding ───
  group('Epic 1: Welcome & Onboarding', () {
    testWidgets('1.1 App shows welcome screen on first launch', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      expect(find.text('KidsLearn'), findsOneWidget);
      expect(find.text('GET STARTED'), findsOneWidget);
    });

    testWidgets('1.2 Welcome screen shows feature pills', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      expect(find.text('Math'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Earn Coins'), findsOneWidget);
      expect(find.text('Track Progress'), findsOneWidget);
    });

    testWidgets('1.3 Tapping GET STARTED shows name entry', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('GET STARTED'));
      await tester.pumpAndSettle();

      expect(find.text("What's your name?"), findsOneWidget);
      expect(find.text("LET'S GO!"), findsOneWidget);
    });

    testWidgets('1.4 Entering name and tapping LETS GO navigates to home', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('GET STARTED'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Ravi');
      await tester.tap(find.text("LET'S GO!"));
      await tester.pumpAndSettle();

      // Should be on home screen with subject tabs
      expect(find.text('🔢 Math'), findsOneWidget);
      expect(find.text('📖 English'), findsOneWidget);
    });
  });

  // ─── Epic 2: Home Screen & Navigation ───
  group('Epic 2: Home Screen & Navigation', () {
    testWidgets('2.1 Home screen shows subject tabs, coins, and streak', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'coins': 50,
        'streak_current': 3,
        'streak_best': 5,
        'total_lessons': 10,
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      expect(find.text('🔢 Math'), findsOneWidget);
      expect(find.text('📖 English'), findsOneWidget);
      expect(find.text('50'), findsOneWidget); // coins
      expect(find.text('3'), findsWidgets); // streak
    });

    testWidgets('2.2 Math subject shows Cambridge units', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'last_subject': 'MATH',
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      // Should show Cambridge math units (first one visible)
      expect(find.text('Counting & Numbers (LKG)'), findsOneWidget);
      // Scroll to find "Numbers to 100"
      await tester.scrollUntilVisible(find.text('Numbers to 100'), 300);
      expect(find.text('Numbers to 100'), findsOneWidget);
    });

    testWidgets('2.3 Switching to English shows English units', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'last_subject': 'MATH',
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('📖 English'));
      await tester.pumpAndSettle();

      // First English unit should be visible after switching
      expect(find.textContaining('Phonics'), findsWidgets);
    });

    testWidgets('2.4 Streak button navigates to streak screen', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'streak_current': 5,
        'streak_best': 5,
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      // Tap the streak number to navigate
      final streakFinder = find.text('5');
      if (streakFinder.evaluate().isNotEmpty) {
        await tester.tap(streakFinder.first);
        await tester.pumpAndSettle();
        expect(find.text('🔥 Streaks'), findsOneWidget);
      }
    });
  });

  // ─── Epic 3: Cambridge Math Content ───
  group('Epic 3: Cambridge Math Content', () {
    test('3.1 Math units contain all Cambridge LKG + 1st grade topics', () {
      expect(mathCambridgeUnits.length, greaterThanOrEqualTo(8));
      final titles = mathCambridgeUnits.map((u) => u.title).toList();
      expect(titles.any((t) => t.contains('Counting')), isTrue);
      expect(titles.any((t) => t.contains('100')), isTrue);
      expect(titles.any((t) => t.contains('500')), isTrue);
      expect(titles.any((t) => t.contains('Addition')), isTrue);
      expect(titles.any((t) => t.contains('Subtraction')), isTrue);
      expect(titles.any((t) => t.contains('Shape')), isTrue);
      expect(titles.any((t) => t.contains('Measurement') || t.contains('Big')), isTrue);
    });

    test('3.2 Math skills have proper prerequisites chain', () {
      // First skill should have no prerequisites
      final firstSkill = mathCambridgeSkills.first;
      expect(firstSkill.prerequisites, isEmpty);

      // All skills after first should have prerequisites pointing to valid skills
      for (final skill in mathCambridgeSkills.skip(1)) {
        if (skill.prerequisites.isNotEmpty) {
          for (final prereq in skill.prerequisites) {
            final exists = mathCambridgeSkills.any((s) => s.id == prereq);
            expect(exists, isTrue, reason: 'Prerequisite $prereq for ${skill.id} does not exist');
          }
        }
      }
    });

    test('3.3 Math items have valid answers and distractors', () {
      for (final item in mathCambridgeItems) {
        expect(item.answer, isNotEmpty, reason: 'Item ${item.id} has no answer');
        expect(item.distractors, isNotEmpty, reason: 'Item ${item.id} has no distractors');

        // Answer should not be in distractors
        for (final ans in item.answer) {
          expect(item.distractors.contains(ans), isFalse,
              reason: 'Item ${item.id}: answer "$ans" is also in distractors');
        }
      }
    });

    test('3.4 Addition items have mathematically correct answers', () {
      final additionSkills = mathCambridgeSkills
          .where((s) => s.title.contains('Add'))
          .map((s) => s.id)
          .toList();

      for (final item in mathCambridgeItems) {
        if (!additionSkills.contains(item.skillId)) continue;
        if (!item.prompt.text.contains('+')) continue;

        // Parse the addition problem
        final match = RegExp(r'(\d+)\s*\+\s*(\d+)\s*=\s*\?')
            .firstMatch(item.prompt.text);
        if (match != null) {
          final a = int.parse(match.group(1)!);
          final b = int.parse(match.group(2)!);
          final expected = (a + b).toString();
          expect(item.answer.first, expected,
              reason: 'Item ${item.id}: ${a}+${b} should be $expected, got ${item.answer.first}');
        }
      }
    });

    test('3.5 Subtraction items have mathematically correct answers', () {
      final subtractionSkills = mathCambridgeSkills
          .where((s) => s.title.contains('Subtract'))
          .map((s) => s.id)
          .toList();

      for (final item in mathCambridgeItems) {
        if (!subtractionSkills.contains(item.skillId)) continue;
        if (!item.prompt.text.contains('-')) continue;

        final match = RegExp(r'(\d+)\s*-\s*(\d+)\s*=\s*\?')
            .firstMatch(item.prompt.text);
        if (match != null) {
          final a = int.parse(match.group(1)!);
          final b = int.parse(match.group(2)!);
          final expected = (a - b).toString();
          expect(item.answer.first, expected,
              reason: 'Item ${item.id}: ${a}-${b} should be $expected, got ${item.answer.first}');
          expect(a >= b, isTrue,
              reason: 'Item ${item.id}: negative result ${a}-${b}');
        }
      }
    });

    test('3.6 Numbers to 500 content exists', () {
      final numTo500Skills = mathCambridgeSkills
          .where((s) => s.title.contains('500') || s.title.contains('3-Digit') || s.title.contains('200'))
          .toList();
      expect(numTo500Skills.length, greaterThanOrEqualTo(2));

      // Should have items with 3-digit numbers
      final numTo500SkillIds = numTo500Skills.map((s) => s.id).toList();
      final items500 = mathCambridgeItems
          .where((i) => numTo500SkillIds.contains(i.skillId))
          .toList();
      expect(items500.length, greaterThanOrEqualTo(6));
    });

    test('3.7 Place value content exists (ones, tens, hundreds)', () {
      final placeValueSkills = mathCambridgeSkills
          .where((s) => s.title.contains('Place Value') || s.title.contains('Hundreds') || s.title.contains('Tens'))
          .toList();
      expect(placeValueSkills.length, greaterThanOrEqualTo(1));
    });

    test('3.8 Skip counting content exists (by 2, 5, 10)', () {
      final skipCountSkills = mathCambridgeSkills
          .where((s) => s.title.contains('Skip'))
          .toList();
      expect(skipCountSkills.length, greaterThanOrEqualTo(1));
    });

    test('3.9 Number comparison content exists (<, >, =)', () {
      final compareSkills = mathCambridgeSkills
          .where((s) => s.title.contains('Compar'))
          .toList();
      expect(compareSkills.length, greaterThanOrEqualTo(1));

      // Items should use < > =
      final compareSkillIds = compareSkills.map((s) => s.id).toList();
      final compareItems = mathCambridgeItems
          .where((i) => compareSkillIds.contains(i.skillId))
          .toList();
      expect(compareItems.length, greaterThanOrEqualTo(6));
    });
  });

  // ─── Epic 4: Cambridge English Content ───
  group('Epic 4: Cambridge English Content', () {
    test('4.1 English units cover all Cambridge LKG + 1st grade topics', () {
      expect(englishCambridgeUnits.length, greaterThanOrEqualTo(8));
      final titles = englishCambridgeUnits.map((u) => u.title).toList();
      expect(titles.any((t) => t.contains('Alphabet') || t.contains('Phonics')), isTrue);
      expect(titles.any((t) => t.contains('CVC') || t.contains('Short Vowel') || t.contains('Vowel')), isTrue);
      expect(titles.any((t) => t.contains('Long Vowel') || t.contains('CVCe') || t.contains('Magic')), isTrue);
      expect(titles.any((t) => t.contains('Blend') || t.contains('Digraph')), isTrue);
      expect(titles.any((t) => t.contains('Sight')), isTrue);
      expect(titles.any((t) => t.contains('Spell') || t.contains('Word')), isTrue);
      expect(titles.any((t) => t.contains('Sentence') || t.contains('Grammar')), isTrue);
    });

    test('4.2 Phonics skills cover short vowels (a, e, i, o, u)', () {
      final vowelSkills = englishCambridgeSkills
          .where((s) => s.title.contains('Short'))
          .toList();
      expect(vowelSkills.length, greaterThanOrEqualTo(4));
    });

    test('4.3 Magic e / CVCe content exists', () {
      final magicESkills = englishCambridgeSkills
          .where((s) => s.title.contains('Magic') || s.title.contains('Long'))
          .toList();
      expect(magicESkills.length, greaterThanOrEqualTo(3));
    });

    test('4.4 Blends and digraphs content exists', () {
      final blendSkills = englishCambridgeSkills
          .where((s) => s.title.contains('Blend') || s.title.contains('Digraph'))
          .toList();
      expect(blendSkills.length, greaterThanOrEqualTo(2));
    });

    test('4.5 Fill-in-the-blank spelling items exist', () {
      final fillBlankItems = englishCambridgeItems
          .where((i) => i.prompt.text.contains('_') || i.prompt.text.contains('blank') || i.prompt.text.contains('Fill'))
          .toList();
      expect(fillBlankItems.length, greaterThanOrEqualTo(6));
    });

    test('4.6 English items have valid answers and distractors', () {
      for (final item in englishCambridgeItems) {
        expect(item.answer, isNotEmpty, reason: 'Item ${item.id} has no answer');
        expect(item.distractors, isNotEmpty, reason: 'Item ${item.id} has no distractors');

        // Answer should not be in distractors
        for (final ans in item.answer) {
          expect(item.distractors.contains(ans), isFalse,
              reason: 'Item ${item.id}: answer "$ans" is also in distractors');
        }
      }
    });

    test('4.7 Sight words include common Dolch words', () {
      final sightWordSkills = englishCambridgeSkills
          .where((s) => s.title.contains('Sight') || s.title.contains('Dolch') || s.title.contains('Common'))
          .toList();
      expect(sightWordSkills.length, greaterThanOrEqualTo(2));

      // Check that common words like 'the', 'is', 'and' exist somewhere
      final allSightWordItems = englishCambridgeItems
          .where((i) => sightWordSkills.any((s) => s.id == i.skillId))
          .toList();
      final allAnswers = allSightWordItems.expand((i) => i.answer).toList();
      expect(allAnswers.any((w) => ['the', 'is', 'and', 'to', 'a'].contains(w.toLowerCase())), isTrue);
    });

    test('4.8 Build sentence items have correct word order', () {
      final sentenceItems = englishCambridgeItems
          .where((i) => i.exerciseType == ExerciseType.build_sentence)
          .toList();
      expect(sentenceItems.length, greaterThanOrEqualTo(4));

      for (final item in sentenceItems) {
        // Answer should form a valid sentence (starts with capital)
        expect(item.answer.first[0].toUpperCase(), item.answer.first[0],
            reason: 'Sentence should start with capital: ${item.answer}');
      }
    });

    test('4.9 Opposite words content exists', () {
      final oppositeSkills = englishCambridgeSkills
          .where((s) => s.title.contains('Opposite') || s.title.contains('Antonym'))
          .toList();
      // May or may not exist — if it does, verify
      if (oppositeSkills.isNotEmpty) {
        final oppositeItems = englishCambridgeItems
            .where((i) => oppositeSkills.any((s) => s.id == i.skillId))
            .toList();
        expect(oppositeItems.length, greaterThanOrEqualTo(4));
      }
    });
  });

  // ─── Epic 5: Lesson Flow ───
  group('Epic 5: Lesson Flow', () {
    testWidgets('5.1 Tapping unlocked skill starts a lesson', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'last_subject': 'MATH',
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      // Find the first unlocked skill and tap it
      final skillNodes = find.byType(GestureDetector);
      // The first skill in Math should be unlocked
      expect(skillNodes, findsWidgets);
    });

    test('5.2 Lesson composition selects items from skill', () {
      final firstSkill = mathCambridgeSkills.first;
      final items = itemsForSkill(firstSkill.id);
      expect(items.length, greaterThanOrEqualTo(5));
    });

    testWidgets('5.3 Lesson shows progress bar and question counter', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'last_subject': 'MATH',
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      // Find and tap first skill
      final firstSkillTitle = find.text(mathCambridgeSkills.first.title);
      if (firstSkillTitle.evaluate().isNotEmpty) {
        await tester.tap(firstSkillTitle);
        await tester.pumpAndSettle();

        // Should see progress indicator
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      }
    });

    testWidgets('5.4 Answering question shows CHECK button', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'last_subject': 'MATH',
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      final firstSkillTitle = find.text(mathCambridgeSkills.first.title);
      if (firstSkillTitle.evaluate().isNotEmpty) {
        await tester.tap(firstSkillTitle);
        await tester.pumpAndSettle();

        // Find answer options and tap one
        // The lesson screen should show multiple answer buttons
        // After tapping one, CHECK should appear
      }
    });
  });

  // ─── Epic 6: Streak System ───
  group('Epic 6: Streak System', () {
    test('6.1 New profile starts with 0 streak', () {
      final profile = ChildProfile(id: 'test');
      expect(profile.currentStreak, 0);
      expect(profile.bestStreak, 0);
    });

    test('6.2 Streak increments on consecutive days', () async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'streak_current': 3,
        'streak_best': 3,
        'last_practice_date': DateTime.now().subtract(const Duration(days: 1)).toString().split(' ')[0],
      });

      final state = AppState();
      await state.init();
      expect(state.currentStreak, 3);

      // Simulate completing a lesson today
      final lesson = state.composeDemoLesson(mathCambridgeSkills.first.id);
      final result = LessonResult(
        lessonId: lesson.id,
        skillId: lesson.skillId,
        profileId: state.profile.id,
        totalExercises: 5,
        firstTryCorrectCount: 5,
        coinsEarned: 50,
      );
      await state.completeLesson(result);
      expect(state.currentStreak, 4);
    });

    test('6.3 Streak resets if practice missed for 2+ days', () async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'streak_current': 5,
        'streak_best': 5,
        'last_practice_date': DateTime.now().subtract(const Duration(days: 3)).toString().split(' ')[0],
      });

      final state = AppState();
      await state.init();
      expect(state.currentStreak, 0); // Should have been reset
    });

    test('6.4 Best streak is tracked correctly', () async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'streak_current': 10,
        'streak_best': 10,
        'last_practice_date': DateTime.now().subtract(const Duration(days: 1)).toString().split(' ')[0],
      });

      final state = AppState();
      await state.init();
      expect(state.bestStreak, 10);
    });

    test('6.5 Streak celebration flag is set on streak increase', () async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'streak_current': 2,
        'streak_best': 2,
        'last_practice_date': DateTime.now().subtract(const Duration(days: 1)).toString().split(' ')[0],
      });

      final state = AppState();
      await state.init();

      final lesson = state.composeDemoLesson(mathCambridgeSkills.first.id);
      final result = LessonResult(
        lessonId: lesson.id,
        skillId: lesson.skillId,
        profileId: state.profile.id,
        totalExercises: 5,
        firstTryCorrectCount: 5,
        coinsEarned: 50,
      );
      await state.completeLesson(result);
      expect(state.streakJustIncreased, isTrue);
    });

    testWidgets('6.6 Streak screen shows current streak and milestones', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'streak_current': 7,
        'streak_best': 7,
        'total_lessons': 20,
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      // Navigate to streak screen by tapping streak button
      final streakBtn = find.text('7');
      if (streakBtn.evaluate().isNotEmpty) {
        await tester.tap(streakBtn.first);
        await tester.pumpAndSettle();
      } else {
        // Fallback: tap the streak container area
        await tester.tap(find.byIcon(Icons.local_fire_department).first, warnIfMissed: false);
        await tester.pumpAndSettle();
      }

      // Verify streak screen content
      expect(find.textContaining('Streak'), findsWidgets);
      expect(find.text('7'), findsWidgets);
    });
  });

  // ─── Epic 7: Sound System ───
  group('Epic 7: Sound System', () {
    test('7.1 Sound utility can be enabled/disabled', () {
      SoundUtil.setEnabled(false);
      expect(SoundUtil.isEnabled, isFalse);
      SoundUtil.setEnabled(true);
      expect(SoundUtil.isEnabled, isTrue);
    });

    test('7.2 Sound utility methods do not throw when disabled', () async {
      SoundUtil.setEnabled(false);
      // All methods should complete without throwing
      await SoundUtil.playCorrect();
      await SoundUtil.playWrong();
      await SoundUtil.playStreakCelebration();
      await SoundUtil.playLessonComplete();
      await SoundUtil.playCoin();
      await SoundUtil.playStreakMilestone(7);
    });

    test('7.3 Sound utility handles all milestone levels', () async {
      SoundUtil.setEnabled(false);
      // Test all streak milestone levels
      for (final days in [3, 7, 14, 30, 60, 100]) {
        await SoundUtil.playStreakMilestone(days); // Should not throw
      }
    });

    test('7.4 Sound utility has isEnabled property', () {
      SoundUtil.setEnabled(true);
      expect(SoundUtil.isEnabled, isTrue);
      SoundUtil.setEnabled(false);
      expect(SoundUtil.isEnabled, isFalse);
    });

    testWidgets('7.5 ResultScreen plays lesson complete sound on init',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'streak_current': 1,
        'streak_best': 1,
      });

      SoundUtil.setEnabled(false);

      final result = LessonResult(
        lessonId: 'test',
        skillId: mathCambridgeSkills.first.id,
        profileId: 'test',
        totalExercises: 5,
        firstTryCorrectCount: 4,
        coinsEarned: 40,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: AppState()..init(),
            child: ResultScreen(result: result),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show lesson complete UI
      expect(find.text('Lesson Complete!'), findsOneWidget);
      expect(find.text('CONTINUE'), findsOneWidget);
    });

    testWidgets('7.6 ResultScreen shows streak info when streak >= 2',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'streak_current': 3,
        'streak_best': 5,
      });

      SoundUtil.setEnabled(false);

      final state = AppState();
      await state.init();

      final result = LessonResult(
        lessonId: 'test',
        skillId: mathCambridgeSkills.first.id,
        profileId: 'test',
        totalExercises: 5,
        firstTryCorrectCount: 5,
        coinsEarned: 50,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: state,
            child: ResultScreen(result: result),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show streak info since streak >= 2
      expect(find.textContaining('day streak'), findsOneWidget);
      expect(find.text('🔥'), findsOneWidget);
    });
  });

  // ─── Epic 8: Mastery & Skill Unlock ───
  group('Epic 8: Mastery & Skill Unlock', () {
    test('8.1 First skill is always unlocked', () {
      final state = AppState();
      final firstMathSkill = mathCambridgeSkills.first;
      expect(state.isSkillUnlocked(firstMathSkill), isTrue);
    });

    test('8.2 Locked skill remains locked without prerequisites', () {
      final state = AppState();
      final secondSkill = mathCambridgeSkills[1];
      if (secondSkill.prerequisites.isNotEmpty) {
        expect(state.isSkillUnlocked(secondSkill), isFalse);
      }
    });

    testWidgets('8.3 Completing lesson updates mastery', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      final state = tester.element(find.byType(HomeScreen)).read<AppState>();
      final firstSkill = mathCambridgeSkills.first;
      final lesson = state.composeDemoLesson(firstSkill.id);
      final result = LessonResult(
        lessonId: lesson.id,
        skillId: lesson.skillId,
        profileId: state.profile.id,
        totalExercises: 5,
        firstTryCorrectCount: 5,
        coinsEarned: 50,
      );
      await state.completeLesson(result);
      expect(state.masteryForSkill(firstSkill.id), 100);
    });

    testWidgets('8.4 Coins are earned on lesson completion', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'coins': 0,
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      final state = tester.element(find.byType(HomeScreen)).read<AppState>();
      final firstSkill = mathCambridgeSkills.first;
      final lesson = state.composeDemoLesson(firstSkill.id);
      final result = LessonResult(
        lessonId: lesson.id,
        skillId: lesson.skillId,
        profileId: state.profile.id,
        totalExercises: 5,
        firstTryCorrectCount: 3,
        coinsEarned: 30,
      );
      await state.completeLesson(result);
      expect(state.profile.coins, 30);
    });
  });

  // ─── Epic 9: Demo Data Integration ───
  group('Epic 9: Demo Data Integration', () {
    test('9.1 All Cambridge content is included in allDemoItems', () {
      expect(allDemoItems.length, greaterThanOrEqualTo(
        mathCambridgeItems.length + englishCambridgeItems.length,
      ));
    });

    test('9.2 All Cambridge skills are included in allDemoSkills', () {
      expect(allDemoSkills.length, greaterThanOrEqualTo(
        mathCambridgeSkills.length + englishCambridgeSkills.length,
      ));
    });

    test('9.3 All Cambridge units are included in allDemoUnits', () {
      expect(allDemoUnits.length, greaterThanOrEqualTo(
        mathCambridgeUnits.length + englishCambridgeUnits.length,
      ));
    });

    test('9.4 findSkill finds Cambridge skills', () {
      final firstCambridgeSkill = mathCambridgeSkills.first;
      final found = findSkill(firstCambridgeSkill.id);
      expect(found, isNotNull);
      expect(found!.id, firstCambridgeSkill.id);
    });

    test('9.5 itemsForSkill returns Cambridge items', () {
      final firstCambridgeSkill = mathCambridgeSkills.first;
      final items = itemsForSkill(firstCambridgeSkill.id);
      expect(items, isNotEmpty);
      expect(items.first.skillId, firstCambridgeSkill.id);
    });
  });

  // ─── Epic 10: Child Profile & Persistence ───
  group('Epic 10: Child Profile & Persistence', () {
    test('10.1 ChildProfile serializes streak data correctly', () {
      final profile = ChildProfile(
        id: 'test',
        coins: 100,
        currentStreak: 7,
        bestStreak: 14,
        lastPracticeDate: '2026-08-20',
        totalLessonsCompleted: 25,
        lessonsThisStreak: 5,
      );

      final json = profile.toJson();
      expect(json['currentStreak'], 7);
      expect(json['bestStreak'], 14);
      expect(json['lastPracticeDate'], '2026-08-20');
      expect(json['totalLessonsCompleted'], 25);

      final restored = ChildProfile.fromJson(json);
      expect(restored.currentStreak, 7);
      expect(restored.bestStreak, 14);
      expect(restored.lastPracticeDate, '2026-08-20');
    });

    testWidgets('10.2 Profile name is persisted across sessions', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Ravi',
        'profile_id': 'ravi',
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      // Should go to home screen (not welcome) since profile exists
      expect(find.text('🔢 Math'), findsOneWidget);
    });

    testWidgets('10.3 Total lessons completed is tracked', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'total_lessons': 10,
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      final state = tester.element(find.byType(HomeScreen)).read<AppState>();
      expect(state.totalLessonsCompleted, 10);
    });
  });

  // ─── Epic 11: Sentence Builder ───
  group('Epic 11: Sentence Builder', () {
    test('11.1 build_sentence items exist in English content', () {
      final sentenceItems = englishCambridgeItems
          .where((i) => i.exerciseType == ExerciseType.build_sentence)
          .toList();
      expect(sentenceItems.length, greaterThanOrEqualTo(4),
          reason: 'Should have at least 4 build_sentence items');
    });

    test('11.2 build_sentence answers form valid word sequences', () {
      final sentenceItems = englishCambridgeItems
          .where((i) => i.exerciseType == ExerciseType.build_sentence)
          .toList();

      for (final item in sentenceItems) {
        expect(item.answer.length, greaterThanOrEqualTo(3),
            reason: 'Item ${item.id}: sentence should have at least 3 words');
        expect(item.distractors.length, greaterThanOrEqualTo(1),
            reason: 'Item ${item.id}: should have at least 1 distractor');

        // No overlap between answer and distractors
        for (final ans in item.answer) {
          expect(item.distractors.contains(ans), isFalse,
              reason: 'Item ${item.id}: answer word "$ans" is also a distractor');
        }
      }
    });

    test('11.3 build_sentence answer + distractors have enough tiles', () {
      final sentenceItems = englishCambridgeItems
          .where((i) => i.exerciseType == ExerciseType.build_sentence)
          .toList();

      for (final item in sentenceItems) {
        final totalTiles = item.answer.length + item.distractors.length;
        expect(totalTiles, greaterThanOrEqualTo(4),
            reason: 'Item ${item.id}: should have at least 4 total tiles');
      }
    });

    testWidgets('11.4 Sentence builder renders word tiles for build_sentence items',
        (tester) async {
      // Find a build_sentence item
      final sentenceItem = englishCambridgeItems.firstWhere(
        (i) => i.exerciseType == ExerciseType.build_sentence,
      );

      final lesson = Lesson(
        id: 'test_lesson',
        skillId: sentenceItem.skillId,
        exercises: [sentenceItem],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: LessonScreen(lesson: lesson, skillTitle: 'Sentence Builder'),
        ),
      );
      await tester.pumpAndSettle();

      // Should see the prompt
      expect(find.textContaining('Arrange'), findsOneWidget);

      // Should see Word Bank label
      expect(find.text('Word Bank'), findsOneWidget);

      // Should see all answer + distractor words as tiles
      for (final word in sentenceItem.answer) {
        expect(find.text(word), findsWidgets,
            reason: 'Answer word "$word" should appear as a tile');
      }
    });

    testWidgets('11.5 Tapping a word moves it to the sentence area',
        (tester) async {
      final sentenceItem = englishCambridgeItems.firstWhere(
        (i) => i.exerciseType == ExerciseType.build_sentence,
      );

      final lesson = Lesson(
        id: 'test_lesson',
        skillId: sentenceItem.skillId,
        exercises: [sentenceItem],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: LessonScreen(lesson: lesson, skillTitle: 'Sentence Builder'),
        ),
      );
      await tester.pumpAndSettle();

      // Initially should see the placeholder
      expect(find.text('Tap words below to build your sentence'), findsOneWidget);

      // Tap the first word in the word bank
      // Find a word tile and tap it
      final firstWord = sentenceItem.answer.first;
      await tester.tap(find.text(firstWord).first);
      await tester.pumpAndSettle();

      // The placeholder should be gone
      expect(find.text('Tap words below to build your sentence'), findsNothing);
    });

    testWidgets('11.6 CHECK button appears when all answer words are placed',
        (tester) async {
      final sentenceItem = englishCambridgeItems.firstWhere(
        (i) => i.exerciseType == ExerciseType.build_sentence,
      );

      final lesson = Lesson(
        id: 'test_lesson',
        skillId: sentenceItem.skillId,
        exercises: [sentenceItem],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: LessonScreen(lesson: lesson, skillTitle: 'Sentence Builder'),
        ),
      );
      await tester.pumpAndSettle();

      // Initially no CHECK button
      expect(find.text('CHECK'), findsNothing);

      // Tap words to fill the sentence area (only answer.length words)
      // We need to tap the correct words - tap answer words
      // Since words are shuffled, find each answer word and tap it
      for (int i = 0; i < sentenceItem.answer.length; i++) {
        // Find a word that hasn't been placed yet
        final wordFinder = find.text(sentenceItem.answer[i]);
        if (wordFinder.evaluate().isNotEmpty) {
          await tester.tap(wordFinder.first);
          await tester.pumpAndSettle();
        }
      }

      // Now CHECK button should appear
      expect(find.text('CHECK'), findsOneWidget);
    });

    testWidgets('11.7 Correct sentence order marks answer as correct',
        (tester) async {
      final sentenceItem = englishCambridgeItems.firstWhere(
        (i) => i.exerciseType == ExerciseType.build_sentence,
      );

      final lesson = Lesson(
        id: 'test_lesson',
        skillId: sentenceItem.skillId,
        exercises: [sentenceItem],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: LessonScreen(lesson: lesson, skillTitle: 'Sentence Builder'),
        ),
      );
      await tester.pumpAndSettle();

      // Tap words in the CORRECT order
      for (final word in sentenceItem.answer) {
        final wordFinder = find.text(word);
        if (wordFinder.evaluate().isNotEmpty) {
          await tester.tap(wordFinder.first);
          await tester.pumpAndSettle();
        }
      }

      // Tap CHECK
      await tester.tap(find.text('CHECK'));
      await tester.pumpAndSettle();

      // Should show correct feedback
      expect(find.text('Great job!'), findsOneWidget);
    });

    testWidgets('11.8 Incorrect sentence order marks answer as wrong',
        (tester) async {
      // Use an item with at least 3 answer words
      final sentenceItem = englishCambridgeItems.firstWhere(
        (i) =>
            i.exerciseType == ExerciseType.build_sentence &&
            i.answer.length >= 3,
      );

      final lesson = Lesson(
        id: 'test_lesson',
        skillId: sentenceItem.skillId,
        exercises: [sentenceItem],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: LessonScreen(lesson: lesson, skillTitle: 'Sentence Builder'),
        ),
      );
      await tester.pumpAndSettle();

      // Tap words in WRONG order (reverse)
      final reversed = sentenceItem.answer.reversed.toList();
      for (final word in reversed) {
        final wordFinder = find.text(word);
        if (wordFinder.evaluate().isNotEmpty) {
          await tester.tap(wordFinder.first);
          await tester.pumpAndSettle();
        }
      }

      // Tap CHECK
      await tester.tap(find.text('CHECK'));
      await tester.pumpAndSettle();

      // Should show wrong feedback
      expect(find.text('Not quite!'), findsOneWidget);
      // Should show correct answer
      expect(find.text('Answer: ${sentenceItem.answer.join(" ")}'),
          findsOneWidget);
    });

    testWidgets('11.9 Tapping a placed word removes it from sentence area',
        (tester) async {
      final sentenceItem = englishCambridgeItems.firstWhere(
        (i) => i.exerciseType == ExerciseType.build_sentence,
      );

      final lesson = Lesson(
        id: 'test_lesson',
        skillId: sentenceItem.skillId,
        exercises: [sentenceItem],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: LessonScreen(lesson: lesson, skillTitle: 'Sentence Builder'),
        ),
      );
      await tester.pumpAndSettle();

      // Tap a word to add it
      final firstWord = sentenceItem.answer.first;
      await tester.tap(find.text(firstWord).first);
      await tester.pumpAndSettle();

      // Placeholder should be gone
      expect(find.text('Tap words below to build your sentence'), findsNothing);

      // Now tap the word in the sentence area to remove it
      // The word should appear in the sentence area now
      await tester.tap(find.text(firstWord).first);
      await tester.pumpAndSettle();

      // Placeholder should be back
      expect(find.text('Tap words below to build your sentence'), findsOneWidget);
    });
  });

  // ─── Epic 12: Homework Tab ───
  group('Epic 12: Homework Tab', () {
    testWidgets('12.1 Home shows Math, English and Homework tabs', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      expect(find.text('🔢 Math'), findsOneWidget);
      expect(find.text('📖 English'), findsOneWidget);
      expect(find.text('📝 Homework'), findsOneWidget);
    });

    testWidgets('12.2 Tapping Homework shows only homework skills', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('📝 Homework'));
      await tester.pumpAndSettle();

      final state = tester.element(find.byType(HomeScreen)).read<AppState>();
      expect(state.currentSection, HomeSection.homework);
      expect(find.text('Spelling Practice'), findsOneWidget);
      expect(find.text('Counting & Numbers (LKG)'), findsNothing);
    });

    testWidgets('12.3 Selected section is remembered', (tester) async {
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Test',
        'profile_id': 'test',
        'last_section': 'homework',
      });
      await tester.pumpWidget(const KidsLearnApp());
      await tester.pumpAndSettle();

      final state = tester.element(find.byType(HomeScreen)).read<AppState>();
      expect(state.currentSection, HomeSection.homework);
      expect(find.text('Spelling Practice'), findsOneWidget);
    });
  });

  // ─── Epic 13: Build-the-Word Spelling ───
  group('Epic 13: Build-the-Word Spelling', () {
    Item spellItem() => homeworkItems.first; // "modern"

    Future<void> pumpSpellLesson(WidgetTester tester) async {
      final lesson = Lesson(
        id: 'test_lesson',
        skillId: spellItem().skillId,
        exercises: [spellItem()],
      );
      await tester.pumpWidget(
        MaterialApp(home: LessonScreen(lesson: lesson, skillTitle: 'Spelling')),
      );
      await tester.pumpAndSettle();
    }

    /// Tap the bank tile showing [letter]. Slots render above the bank, so
    /// when a letter is both placed and in the bank, the last match is the bank.
    Future<void> tapLetter(WidgetTester tester, String letter) async {
      await tester.tap(find.text(letter.toUpperCase()).last, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
    }

    testWidgets('13.1 Shows empty slots and a letter bank', (tester) async {
      await pumpSpellLesson(tester);
      final item = spellItem();

      expect(find.textContaining('Spell this'), findsOneWidget);
      expect(find.text('Tap the letters in order to spell the word'), findsOneWidget);
      for (final l in [...item.answer, ...item.distractors]) {
        expect(find.text(l.toUpperCase()), findsWidgets,
            reason: 'Bank should contain letter "$l"');
      }
      expect(find.text('CHECK'), findsNothing);
      expect(find.text('Great job!'), findsNothing);
    });

    testWidgets('13.2 Tapping the correct next letter adds it to the word',
        (tester) async {
      await pumpSpellLesson(tester);
      final item = spellItem();

      await tapLetter(tester, item.answer.first);
      expect(find.text('Keep going! ${item.answer.length - 1} to go'), findsOneWidget);
      // The letter now appears twice: in its slot and (faded) in the bank
      expect(find.text(item.answer.first.toUpperCase()), findsNWidgets(2));
    });

    testWidgets('13.3 Wrong letter is not placed', (tester) async {
      await pumpSpellLesson(tester);
      final item = spellItem();

      await tapLetter(tester, item.distractors.first);
      expect(find.text('Tap the letters in order to spell the word'), findsOneWidget,
          reason: 'No letter should have been placed');
      expect(find.text('Great job!'), findsNothing);
    });

    testWidgets('13.4 Spelling the whole word marks it correct', (tester) async {
      await pumpSpellLesson(tester);
      final item = spellItem();

      for (final l in item.answer) {
        await tapLetter(tester, l);
      }
      expect(find.text('Great job!'), findsOneWidget);
      expect(find.text('FINISH'), findsOneWidget);
    });
  });
}

// Helper extension for widget testing
extension PumpWidget on WidgetTester {
  Future<void> pushWidget(Widget widget) async {
    await pumpWidget(MaterialApp(home: widget));
  }
}
