import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/collectible.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'shop_screen.dart';

/// "My Stuff" — the child's buddy, their stats and everything they have
/// collected so far. Empty slots stay visible so the collection always looks
/// like something worth finishing.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final owned = state.ownedCollectibles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stuff'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Toy Shop',
            icon: const Text('🛍️', style: TextStyle(fontSize: 24)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ShopScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _buildBuddyCard(context, state),
            const SizedBox(height: 20),
            _buildStatsRow(state),
            const SizedBox(height: 24),
            _buildCollectionHeader(owned.length),
            const SizedBox(height: 12),
            _buildCollectionGrid(context, state),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShopScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldCoin,
                foregroundColor: AppColors.textPrimary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                '🛍️  GO TO THE TOY SHOP',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuddyCard(BuildContext context, AppState state) {
    final buddy = state.buddy;
    final color = buddy?.rarity.color ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                buddy?.emoji ?? '🥚',
                style: const TextStyle(fontSize: 70),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            buddy?.name ?? 'No buddy yet',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            buddy != null
                ? 'Your buddy — tap any toy below to swap'
                : 'Earn coins and buy your first buddy in the shop!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AppState state) {
    return Row(
      children: [
        _statCard('🪙', '${state.profile.coins}', 'coins', AppColors.goldCoin),
        const SizedBox(width: 10),
        _statCard('🔥', '${state.currentStreak}', 'day streak',
            AppColors.streakOrange),
        const SizedBox(width: 10),
        _statCard('📚', '${state.totalLessonsCompleted}', 'lessons',
            AppColors.secondary),
      ],
    );
  }

  Widget _statCard(String emoji, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.35), width: 1.5),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionHeader(int owned) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'My Collection',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          '$owned of ${shopCatalogue.length}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionGrid(BuildContext context, AppState state) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        for (final item in shopCatalogue)
          _collectionSlot(context, state, item),
      ],
    );
  }

  Widget _collectionSlot(
      BuildContext context, AppState state, Collectible item) {
    final owned = state.owns(item.id);
    final isBuddy = state.buddyId == item.id;

    return GestureDetector(
      onTap: owned
          ? () => state.setBuddy(item.id)
          : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShopScreen()),
              ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: owned ? item.rarity.color.withOpacity(0.10) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isBuddy
                ? item.rarity.color
                : owned
                    ? item.rarity.color.withOpacity(0.4)
                    : Colors.grey.shade300,
            width: isBuddy ? 3 : 1.5,
          ),
        ),
        child: Center(
          child: owned
              ? Text(item.emoji, style: const TextStyle(fontSize: 32))
              : Icon(Icons.lock_outline,
                  size: 22, color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
