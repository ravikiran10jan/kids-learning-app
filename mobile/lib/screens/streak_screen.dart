import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 28),
                  ),
                  const Text(
                    '🔥 Streaks',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Current Streak - Hero Card
                    _buildStreakHero(context, state),
                    const SizedBox(height: 24),

                    // Streak Stats
                    _buildStatsRow(state),
                    const SizedBox(height: 24),

                    // Streak Calendar (last 7 days)
                    _buildWeekCalendar(context, state),
                    const SizedBox(height: 24),

                    // Streak Milestones
                    _buildMilestones(state),
                    const SizedBox(height: 24),

                    // Tips
                    _buildTipsCard(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakHero(BuildContext context, AppState state) {
    final streak = state.currentStreak;
    final isHot = streak >= 7;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isHot
              ? [const Color(0xFFFF6B35), const Color(0xFFFF2E63)]
              : streak >= 3
                  ? [AppColors.streakOrange, const Color(0xFFFFCC02)]
                  : [Colors.grey.shade400, Colors.grey.shade300],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isHot ? const Color(0xFFFF6B35) : Colors.grey)
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Fire emoji
          Text(
            isHot ? '🔥🔥🔥' : streak >= 3 ? '🔥' : '💪',
            style: const TextStyle(fontSize: 56),
          ),
          const SizedBox(height: 12),
          Text(
            '$streak',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1,
            ),
          ),
          Text(
            streak == 0
                ? 'Start your streak today!'
                : streak == 1
                    ? 'day streak'
                    : 'day streak!',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          if (streak >= 3) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                streak >= 30
                    ? '🏆 Legendary Streak!'
                    : streak >= 14
                        ? '⭐ Amazing Streak!'
                        : streak >= 7
                            ? '🔥 Hot Streak!'
                            : '💪 Keep Going!',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsRow(AppState state) {
    return Row(
      children: [
        _statCard(
          '🏆',
          'Best Streak',
          '${state.bestStreak} days',
          const Color(0xFFFFC800),
        ),
        const SizedBox(width: 12),
        _statCard(
          '📚',
          'Total Lessons',
          '${state.totalLessonsCompleted}',
          AppColors.secondary,
        ),
        const SizedBox(width: 12),
        _statCard(
          '📖',
          'Today',
          '${state.lessonsThisStreak} lessons',
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _statCard(String emoji, String label, String value, Color accentColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentColor.withOpacity(0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekCalendar(BuildContext context, AppState state) {
    final today = DateTime.now();
    final streak = state.currentStreak;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final date = today.subtract(Duration(days: 6 - index));
              final dayName = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][date.weekday - 1];
              final isToday = index == 6;
              // Days practiced: streak covers the last N days
              final daysAgo = 6 - index;
              final wasPracticed = daysAgo < streak;

              return Column(
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isToday
                          ? AppColors.streakOrange
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: wasPracticed
                          ? AppColors.streakOrange
                          : isToday
                              ? AppColors.streakOrange.withOpacity(0.15)
                              : Colors.grey.shade100,
                      shape: BoxShape.circle,
                      border: isToday
                          ? Border.all(color: AppColors.streakOrange, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: wasPracticed
                          ? const Text('🔥', style: TextStyle(fontSize: 18))
                          : isToday
                              ? const Text('📚',
                                  style: TextStyle(fontSize: 16))
                              : Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestones(AppState state) {
    final streak = state.currentStreak;
    final best = state.bestStreak;

    final milestones = [
      _Milestone(days: 3, icon: '🌟', title: 'Getting Started', achieved: best >= 3),
      _Milestone(days: 7, icon: '🔥', title: 'Week Warrior', achieved: best >= 7),
      _Milestone(days: 14, icon: '⭐', title: 'Two Week Champion', achieved: best >= 14),
      _Milestone(days: 30, icon: '🏆', title: 'Monthly Master', achieved: best >= 30),
      _Milestone(days: 60, icon: '💎', title: 'Diamond Streak', achieved: best >= 60),
      _Milestone(days: 100, icon: '👑', title: 'Century Club', achieved: best >= 100),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Streak Milestones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...milestones.map((m) {
            final progress = streak >= m.days ? 1.0 : streak / m.days;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: m.achieved
                          ? AppColors.goldCoin.withOpacity(0.15)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        m.achieved ? m.icon : '🔒',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: m.achieved
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(
                              m.achieved
                                  ? AppColors.goldCoin
                                  : AppColors.streakOrange,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${streak >= m.days ? m.days : streak}/${m.days}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: m.achieved
                          ? AppColors.goldCoin
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('💡', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text(
                'Streak Tips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _tipItem('Practice a little every day to keep your streak alive!'),
          _tipItem('Even 1 lesson counts — consistency matters more than quantity'),
          _tipItem('🔥 7-day streaks unlock special celebrations!'),
          _tipItem('Missing a day resets your streak — don\'t break the chain!'),
        ],
      ),
    );
  }

  Widget _tipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•', style: TextStyle(fontSize: 16, color: AppColors.primary)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Milestone {
  final int days;
  final String icon;
  final String title;
  final bool achieved;

  _Milestone({
    required this.days,
    required this.icon,
    required this.title,
    required this.achieved,
  });
}
