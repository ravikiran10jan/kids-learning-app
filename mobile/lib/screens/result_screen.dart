import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson_result.dart';
import '../theme/app_theme.dart';
import '../state/app_state.dart';
import '../utils/sound_util.dart';
import 'streak_screen.dart';
import 'shop_screen.dart';

class ResultScreen extends StatefulWidget {
  final LessonResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _soundsPlayed = false;

  @override
  void initState() {
    super.initState();
    _playCelebrationSounds();
  }

  void _playCelebrationSounds() {
    if (_soundsPlayed) return;
    _soundsPlayed = true;

    // Use post-frame callback to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AppState>();

      // Play lesson complete sound
      SoundUtil.playLessonComplete();

      // Play streak celebration if streak just increased
      if (state.streakJustIncreased) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (state.currentStreak >= 3) {
            SoundUtil.playStreakCelebration();
          }
          if (state.currentStreak >= 3) {
            SoundUtil.playStreakMilestone(state.currentStreak);
          }
          state.clearStreakIncreased();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final accuracy = result.totalExercises > 0
        ? (result.firstTryCorrectCount / result.totalExercises * 100).round()
        : 0;
    final stars = accuracy >= 90 ? 3 : accuracy >= 60 ? 2 : accuracy > 0 ? 1 : 0;

    return Scaffold(
      body: SafeArea(
        // Scrollable so the extra shop goal never overflows on short screens
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Celebration
              const Text('🎉', style: TextStyle(fontSize: 72)),
              const SizedBox(height: 16),
              Text(
                'Lesson Complete!',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      i < stars ? Icons.star : Icons.star_border,
                      size: 48,
                      color: i < stars ? AppColors.goldCoin : Colors.grey.shade300,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Stats cards
              Row(
                children: [
                  _statCard('🎯', 'Accuracy', '$accuracy%'),
                  const SizedBox(width: 12),
                  _statCard('🪙', 'Coins', '+${result.coinsEarned}'),
                  const SizedBox(width: 12),
                  _statCard('✅', 'Correct',
                      '${result.firstTryCorrectCount}/${result.totalExercises}'),
                ],
              ),

              const SizedBox(height: 20),
              // Shop goal — turns coins into something to aim for
              _buildShopGoal(context),

              const Spacer(),

              // Continue button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CONTINUE'),
              ),

              // Streak info (if streak >= 2)
              if (context.watch<AppState>().currentStreak >= 2) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StreakScreen()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.streakOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(
                          '${context.watch<AppState>().currentStreak} day streak! View details',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.streakOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Nudge towards the next unlockable toy so coins feel like progress.
  Widget _buildShopGoal(BuildContext context) {
    final state = context.watch<AppState>();
    final goal = state.nextGoal;
    if (goal == null) return const SizedBox.shrink();

    final affordable = state.profile.coins >= goal.price;
    final short = goal.price - state.profile.coins;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ShopScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: affordable
              ? AppColors.primary.withOpacity(0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: affordable ? AppColors.primary : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(goal.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                affordable
                    ? 'You can buy ${goal.name} now!'
                    : '$short more coins for ${goal.name}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: affordable
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right,
                size: 20,
                color: affordable
                    ? AppColors.primary
                    : AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String emoji, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
