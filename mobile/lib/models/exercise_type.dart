enum ExerciseType {
  pick_image,
  pick_text,
  pick_number,
  spell_tiles,
  build_sentence,
  match_pairs,
  count_tap,
  number_line,
  sort_bins,
  true_false,
  listen_and_answer,
}

ExerciseType parseExerciseType(String? s) {
  if (s == null) return ExerciseType.pick_text;
  return ExerciseType.values.firstWhere(
    (e) => e.name == s,
    orElse: () => ExerciseType.pick_text,
  );
}
