class ExerciseResult {
  final String itemId;
  final bool correct;
  final bool firstTry;
  final int attempts;

  ExerciseResult({
    required this.itemId,
    this.correct = false,
    this.firstTry = false,
    this.attempts = 1,
  });

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'correct': correct,
        'firstTry': firstTry,
        'attempts': attempts,
      };
}

class LessonResult {
  final String lessonId;
  final String skillId;
  final String profileId;
  final int totalExercises;
  final int firstTryCorrectCount;
  final int coinsEarned;
  final List<ExerciseResult> exerciseResults;

  LessonResult({
    required this.lessonId,
    required this.skillId,
    required this.profileId,
    this.totalExercises = 0,
    this.firstTryCorrectCount = 0,
    this.coinsEarned = 0,
    this.exerciseResults = const [],
  });

  Map<String, dynamic> toJson() => {
        'lessonId': lessonId,
        'skillId': skillId,
        'profileId': profileId,
        'totalExercises': totalExercises,
        'firstTryCorrectCount': firstTryCorrectCount,
        'coinsEarned': coinsEarned,
        'exerciseResults': exerciseResults.map((e) => e.toJson()).toList(),
      };
}
