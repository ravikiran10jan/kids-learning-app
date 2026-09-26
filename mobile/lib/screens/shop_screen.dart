import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/collectible.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// The Toy Shop — spend earned coins on toys, characters, pets and space
/// treasures. Items the child cannot afford yet stay visible (greyed out with
/// the coins still needed) so there is always something to practise towards.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final goal = state.nextGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toy Shop'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildWallet(state, goal),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  for (final category in shopCategories) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 12),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.78,
                      children: [
                        for (final item in shopCatalogue
                            .where((c) => c.category == category))
                          _ShopTile(item: item),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWallet(AppState state, Collectible? goal) {
    final owned = state.ownedCollectibles.length;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.goldCoin, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldCoin.withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('🪙', style: TextStyle(fontSize: 34)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.profile.coins}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    const Text(
                      'coins to spend',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$owned / ${shopCatalogue.length}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const Text(
                    'collected',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (goal != null && state.profile.coins < goal.price) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: state.profile.coins / goal.price,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation(AppColors.goldCoin),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${goal.price - state.profile.coins} more coins for ${goal.emoji} ${goal.name}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ShopTile extends StatelessWidget {
  final Collectible item;

  const _ShopTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final owned = state.owns(item.id);
    final affordable = state.canAfford(item);

    return GestureDetector(
      onTap: owned
          ? () => _showOwnedSheet(context, state)
          : affordable
              ? () => _showBuySheet(context, state)
              : () => _showSaveUpSheet(context, state),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: owned ? item.rarity.color.withOpacity(0.10) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: owned ? item.rarity.color : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: owned || affordable ? 1 : 0.35,
              child: Text(item.emoji, style: const TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 6),
            Text(
              item.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: owned || affordable
                    ? AppColors.textPrimary
                    : AppColors.lockedIcon,
              ),
            ),
            const SizedBox(height: 6),
            if (owned)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 15, color: item.rarity.color),
                  const SizedBox(width: 4),
                  Text(
                    'Mine',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: item.rarity.color,
                    ),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 3),
                  Text(
                    '${item.price}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: affordable
                          ? AppColors.textPrimary
                          : AppColors.lockedIcon,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ─── Sheets ───

  void _showBuySheet(BuildContext context, AppState state) {
    _sheet(
      context,
      title: 'Buy ${item.name}?',
      body: 'This costs ${item.price} coins.\n'
          'You will have ${state.profile.coins - item.price} coins left.',
      primaryLabel: 'BUY IT',
      primaryColor: AppColors.primary,
      onPrimary: () async {
        Navigator.pop(context);
        final bought = await state.buyCollectible(item);
        if (bought && context.mounted) _showUnlockedDialog(context);
      },
      secondaryLabel: 'Not yet',
    );
  }

  void _showSaveUpSheet(BuildContext context, AppState state) {
    final short = item.price - state.profile.coins;
    _sheet(
      context,
      title: 'Keep practising!',
      body: '${item.name} costs ${item.price} coins.\n'
          'Earn $short more and it is yours.',
      primaryLabel: 'LET\'S PRACTISE',
      primaryColor: AppColors.secondary,
      onPrimary: () => Navigator.pop(context),
    );
  }

  void _showOwnedSheet(BuildContext context, AppState state) {
    final isBuddy = state.buddyId == item.id;
    _sheet(
      context,
      title: item.name,
      body: isBuddy
          ? '${item.name} is already your buddy!'
          : 'Make ${item.name} your buddy so it shows on your profile.',
      primaryLabel: isBuddy ? 'NICE' : 'MAKE IT MY BUDDY',
      primaryColor: item.rarity.color,
      onPrimary: () {
        if (!isBuddy) state.setBuddy(item.id);
        Navigator.pop(context);
      },
    );
  }

  void _showUnlockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.3, end: 1),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutBack,
                builder: (_, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: item.rarity.color.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(item.emoji,
                        style: const TextStyle(fontSize: 64)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${item.name} is yours!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: item.rarity.color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.rarity.label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: item.rarity.color,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'AWESOME',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sheet(
    BuildContext context, {
    required String title,
    required String body,
    required String primaryLabel,
    required Color primaryColor,
    required VoidCallback onPrimary,
    String? secondaryLabel,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 22),
            Text(item.emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: onPrimary,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                primaryLabel,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (secondaryLabel != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  secondaryLabel,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
