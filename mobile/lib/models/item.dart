import 'exercise_type.dart';

class ItemPrompt {
  final String text;
  final String audio;

  ItemPrompt({this.text = '', this.audio = ''});

  factory ItemPrompt.fromJson(Map<String, dynamic> json) {
    return ItemPrompt(
      text: json['text'] ?? '',
      audio: json['audio'] ?? '',
    );
  }
}

class ItemHint {
  final String audio;
  final int removeDistractors;

  ItemHint({this.audio = '', this.removeDistractors = 0});

  factory ItemHint.fromJson(Map<String, dynamic> json) {
    return ItemHint(
      audio: json['audio'] ?? '',
      removeDistractors: json['removeDistractors'] ?? 0,
    );
  }
}

class Item {
  final String id;
  final String skillId;
  final ExerciseType exerciseType;
  final ItemPrompt prompt;
  final List<String> answer;
  final List<String> distractors;
  final ItemHint? hint;
  final List<String> assets;
  final int difficulty;

  Item({
    required this.id,
    required this.skillId,
    required this.exerciseType,
    required this.prompt,
    this.answer = const [],
    this.distractors = const [],
    this.hint,
    this.assets = const [],
    this.difficulty = 1,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? '',
      skillId: json['skillId'] ?? '',
      exerciseType: parseExerciseType(json['exerciseType']),
      prompt: json['prompt'] != null
          ? ItemPrompt.fromJson(json['prompt'])
          : ItemPrompt(),
      answer: List<String>.from(json['answer'] ?? []),
      distractors: List<String>.from(json['distractors'] ?? []),
      hint: json['hint'] != null ? ItemHint.fromJson(json['hint']) : null,
      assets: List<String>.from(json['assets'] ?? []),
      difficulty: json['difficulty'] ?? 1,
    );
  }

  /// All options (answer + distractors) shuffled
  List<String> get allOptions {
    final opts = [...answer, ...distractors];
    opts.shuffle();
    return opts;
  }
}
