enum Subject { ENGLISH, MATH }

Subject parseSubject(String? s) {
  if (s == null) return Subject.ENGLISH;
  return Subject.values.firstWhere(
    (e) => e.name.toUpperCase() == s.toUpperCase(),
    orElse: () => Subject.ENGLISH,
  );
}
