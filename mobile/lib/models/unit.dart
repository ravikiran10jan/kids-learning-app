import 'subject.dart';

class Unit {
  final String id;
  final Subject subject;
  final String code;
  final String title;
  final List<String> skillIds;

  Unit({
    required this.id,
    required this.subject,
    required this.code,
    required this.title,
    this.skillIds = const [],
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] ?? '',
      subject: parseSubject(json['subject']),
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      skillIds: List<String>.from(json['skillIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject.name,
        'code': code,
        'title': title,
        'skillIds': skillIds,
      };
}
