import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// How special a collectible is. Rarity drives its price, its card colour and
/// the size of the celebration when a child unlocks it.
enum Rarity { common, rare, epic, legendary }

extension RarityInfo on Rarity {
  String get label => switch (this) {
        Rarity.common => 'Common',
        Rarity.rare => 'Rare',
        Rarity.epic => 'Epic',
        Rarity.legendary => 'Legendary',
      };

  Color get color => switch (this) {
        Rarity.common => AppColors.secondary,
        Rarity.rare => AppColors.primary,
        Rarity.epic => AppColors.purple,
        Rarity.legendary => AppColors.goldCoin,
      };
}

/// A toy, character or pet a child can buy with the coins they earn.
class Collectible {
  final String id;
  final String name;
  final String emoji;
  final String category;
  final Rarity rarity;
  final int price;

  const Collectible({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.rarity,
    required this.price,
  });
}

/// The shop catalogue, cheapest first within each category.
/// Prices are tuned to lesson rewards: a 10-word lesson answered perfectly
/// pays 100 coins, so a Common is roughly one good lesson and a Legendary is
/// a goal worth practising towards for a week.
const List<Collectible> shopCatalogue = [
  // ── Toys ──
  Collectible(id: 'toy_ball', name: 'Bouncy Ball', emoji: '🏀', category: 'Toys', rarity: Rarity.common, price: 50),
  Collectible(id: 'toy_kite', name: 'Sky Kite', emoji: '🪁', category: 'Toys', rarity: Rarity.common, price: 60),
  Collectible(id: 'toy_teddy', name: 'Teddy Bear', emoji: '🧸', category: 'Toys', rarity: Rarity.rare, price: 150),
  Collectible(id: 'toy_train', name: 'Steam Train', emoji: '🚂', category: 'Toys', rarity: Rarity.rare, price: 180),
  Collectible(id: 'toy_robot', name: 'Robo Pal', emoji: '🤖', category: 'Toys', rarity: Rarity.epic, price: 320),
  Collectible(id: 'toy_castle', name: 'Fairy Castle', emoji: '🏰', category: 'Toys', rarity: Rarity.legendary, price: 600),

  // ── Characters ──
  Collectible(id: 'char_clown', name: 'Giggle Clown', emoji: '🤡', category: 'Characters', rarity: Rarity.common, price: 60),
  Collectible(id: 'char_ninja', name: 'Sneaky Ninja', emoji: '🥷', category: 'Characters', rarity: Rarity.rare, price: 160),
  Collectible(id: 'char_pirate', name: 'Captain Cove', emoji: '🏴‍☠️', category: 'Characters', rarity: Rarity.rare, price: 200),
  Collectible(id: 'char_wizard', name: 'Word Wizard', emoji: '🧙', category: 'Characters', rarity: Rarity.epic, price: 350),
  Collectible(id: 'char_hero', name: 'Super Speller', emoji: '🦸', category: 'Characters', rarity: Rarity.epic, price: 400),
  Collectible(id: 'char_dragon', name: 'Ember Dragon', emoji: '🐉', category: 'Characters', rarity: Rarity.legendary, price: 750),

  // ── Pets ──
  Collectible(id: 'pet_chick', name: 'Little Chick', emoji: '🐥', category: 'Pets', rarity: Rarity.common, price: 50),
  Collectible(id: 'pet_puppy', name: 'Puppy', emoji: '🐶', category: 'Pets', rarity: Rarity.common, price: 70),
  Collectible(id: 'pet_kitten', name: 'Kitten', emoji: '🐱', category: 'Pets', rarity: Rarity.rare, price: 150),
  Collectible(id: 'pet_panda', name: 'Baby Panda', emoji: '🐼', category: 'Pets', rarity: Rarity.rare, price: 220),
  Collectible(id: 'pet_owl', name: 'Wise Owl', emoji: '🦉', category: 'Pets', rarity: Rarity.epic, price: 330),
  Collectible(id: 'pet_unicorn', name: 'Unicorn', emoji: '🦄', category: 'Pets', rarity: Rarity.legendary, price: 700),

  // ── Space ──
  Collectible(id: 'spc_star', name: 'Shiny Star', emoji: '⭐', category: 'Space', rarity: Rarity.common, price: 40),
  Collectible(id: 'spc_moon', name: 'Crescent Moon', emoji: '🌙', category: 'Space', rarity: Rarity.common, price: 70),
  Collectible(id: 'spc_rocket', name: 'Rocket Ship', emoji: '🚀', category: 'Space', rarity: Rarity.rare, price: 190),
  Collectible(id: 'spc_ufo', name: 'Flying Saucer', emoji: '🛸', category: 'Space', rarity: Rarity.epic, price: 360),
  Collectible(id: 'spc_planet', name: 'Ringed Planet', emoji: '🪐', category: 'Space', rarity: Rarity.epic, price: 420),
  Collectible(id: 'spc_galaxy', name: 'Whole Galaxy', emoji: '🌌', category: 'Space', rarity: Rarity.legendary, price: 900),
];

/// Catalogue categories in display order.
List<String> get shopCategories {
  final seen = <String>[];
  for (final c in shopCatalogue) {
    if (!seen.contains(c.category)) seen.add(c.category);
  }
  return seen;
}

Collectible? findCollectible(String id) {
  for (final c in shopCatalogue) {
    if (c.id == id) return c;
  }
  return null;
}
