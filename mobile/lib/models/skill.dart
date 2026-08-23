import 'subject.dart';

class Skill {
  final String id;
  final Subject subject;
  final String unitCode;
  final String title;
  final String icon;
  final List<String> prerequisites;
  final List<String> itemIds;

  Skill({
    required this.id,
    required this.subject,
    required this.unitCode,
    required this.title,
    this.icon = '',
    this.prerequisites = const [],
    this.itemIds = const [],
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? '',
      subject: parseSubject(json['subject']),
      unitCode: json['unitCode'] ?? '',
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      itemIds: List<String>.from(json['itemIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject.name,
        'unitCode': unitCode,
        'title': title,
        'icon': icon,
        'prerequisites': prerequisites,
        'itemIds': itemIds,
      };
}
