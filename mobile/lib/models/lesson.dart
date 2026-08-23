import 'item.dart';

class Lesson {
  final String id;
  final String skillId;
  final List<Item> exercises;
  final int newCount;
  final int reviewCount;
  final int mistakeCount;

  Lesson({
    required this.id,
    required this.skillId,
    this.exercises = const [],
    this.newCount = 0,
    this.reviewCount = 0,
    this.mistakeCount = 0,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? '',
      skillId: json['skillId'] ?? '',
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => Item.fromJson(e))
              .toList() ??
          [],
      newCount: json['newCount'] ?? 0,
      reviewCount: json['reviewCount'] ?? 0,
      mistakeCount: json['mistakeCount'] ?? 0,
    );
  }
}
