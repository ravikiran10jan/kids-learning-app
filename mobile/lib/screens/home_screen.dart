import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/skill.dart';
import '../models/subject.dart';
import '../models/demo_data.dart';
import '../models/math_content.dart';
import '../models/english_content.dart';
import '../theme/app_theme.dart';
import 'lesson_screen.dart';
import 'streak_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final units = state.currentSubject == Subject.MATH
        ? [...mathCambridgeUnits, ...demoMathUnits]
        : [...englishCambridgeUnits, ...demoEnglishUnits];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, state),
            _buildSubjectTabs(context, state),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                children: [
                  for (final unit in units) ...[
                    _buildUnitHeader(unit.title),
                    ...unit.skillIds.map((sid) {
                      final skill = findSkill(sid);
                      if (skill == null) return const SizedBox.shrink();
                      return _buildSkillNode(context, state, skill);
                    }),
                    const SizedBox(height: 24),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          // Streak Button
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StreakScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: state.currentStreak >= 3
                    ? AppColors.streakOrange.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: state.currentStreak >= 3
                    ? Border.all(color: AppColors.streakOrange.withOpacity(0.3), width: 1.5)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.currentStreak >= 3 ? '🔥' : '📅',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${state.currentStreak}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: state.currentStreak >= 3
                          ? AppColors.streakOrange
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Coins
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🪙', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(
                  '${state.profile.coins}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Lessons today
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('📚', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(
                  '${state.profile.dailyLessonsCompleted} today',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectTabs(BuildContext context, AppState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
      child: Row(
        children: [
          _subjectChip(
            context,
            label: '🔢 Math',
            isActive: state.currentSubject == Subject.MATH,
            activeColor: AppColors.mathGradient1,
            onTap: () => state.setSubject(Subject.MATH),
          ),
          const SizedBox(width: 12),
          _subjectChip(
            context,
            label: '📖 English',
            isActive: state.currentSubject == Subject.ENGLISH,
            activeColor: AppColors.englishGradient1,
            onTap: () => state.setSubject(Subject.ENGLISH),
          ),
        ],
      ),
    );
  }

  Widget _subjectChip(BuildContext context,
      {required String label,
      required bool isActive,
      required Color activeColor,
      required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? activeColor : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSkillNode(BuildContext context, AppState state, Skill skill) {
    final mastery = state.masteryForSkill(skill.id);
    final unlocked = state.isSkillUnlocked(skill);
    final isComplete = mastery >= 80;

    Color nodeColor;
    if (!unlocked) {
      nodeColor = AppColors.lockedGrey;
    } else if (isComplete) {
      nodeColor = AppColors.goldCoin;
    } else if (mastery > 0) {
      nodeColor = state.currentSubject == Subject.MATH
          ? AppColors.mathGradient1
          : AppColors.englishGradient1;
    } else {
      nodeColor = AppColors.primary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: GestureDetector(
          onTap: unlocked
              ? () => _startLesson(context, state, skill)
              : () => _showLockedDialog(context),
          child: Column(
            children: [
              // Node circle
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: nodeColor,
                  shape: BoxShape.circle,
                  boxShadow: unlocked
                      ? [
                          BoxShadow(
                            color: nodeColor.withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: !unlocked
                      ? const Icon(Icons.lock_outline,
                          color: AppColors.lockedIcon, size: 28)
                      : isComplete
                          ? const Icon(Icons.star,
                              color: Colors.white, size: 32)
                          : Text(
                              skill.icon,
                              style: const TextStyle(fontSize: 28),
                            ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                skill.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: unlocked
                      ? AppColors.textPrimary
                      : AppColors.lockedIcon,
                ),
                textAlign: TextAlign.center,
              ),
              if (unlocked && mastery > 0) ...[
                const SizedBox(height: 4),
                SizedBox(
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: mastery / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(nodeColor),
                      minHeight: 6,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _startLesson(BuildContext context, AppState state, Skill skill) {
    final lesson = state.composeDemoLesson(skill.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonScreen(lesson: lesson, skillTitle: skill.title),
      ),
    );
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🔒 Locked'),
        content: const Text(
            'Complete the previous skills to unlock this one!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
