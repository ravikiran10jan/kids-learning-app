import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/unit.dart';
import '../models/skill.dart';
import '../models/item.dart';
import '../models/lesson.dart';
import '../models/lesson_result.dart';
import '../models/child_profile.dart';
import '../models/subject.dart';

class ApiService {
  final String baseUrl;
  bool _useDemo = true;

  ApiService({this.baseUrl = 'http://localhost:8080'});

  Future<void> checkConnection() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/content/content-version'))
          .timeout(const Duration(seconds: 3));
      _useDemo = res.statusCode != 200;
    } catch (_) {
      _useDemo = true;
    }
  }

  bool get isUsingDemoData => _useDemo;

  Future<List<Unit>> getUnits() async {
    if (_useDemo) return [];
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/content/units'));
      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as List)
            .map((e) => Unit.fromJson(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<Skill>> getSkillsBySubject(Subject subject) async {
    if (_useDemo) return [];
    try {
      final res = await http.get(
          Uri.parse('$baseUrl/api/content/skills?subject=${subject.name}'));
      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as List)
            .map((e) => Skill.fromJson(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<Item>> getItemsBySkill(String skillId) async {
    if (_useDemo) return [];
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/content/items-by-skill/$skillId'));
      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as List)
            .map((e) => Item.fromJson(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<Lesson> composeLesson(String profileId, String skillId) async {
    if (_useDemo) {
      throw Exception('Use demo data');
    }
    try {
      final res = await http.get(Uri.parse(
          '$baseUrl/api/lessons/compose?profileId=$profileId&skillId=$skillId'));
      if (res.statusCode == 200) {
        return Lesson.fromJson(jsonDecode(res.body));
      }
    } catch (_) {}
    throw Exception('Failed to compose lesson');
  }

  Future<LessonResult> submitLesson(LessonResult result) async {
    if (_useDemo) return result;
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/lessons/submit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(result.toJson()),
      );
      if (res.statusCode == 200) {
        return LessonResult(
          lessonId: result.lessonId,
          skillId: result.skillId,
          profileId: result.profileId,
          coinsEarned: jsonDecode(res.body)['coinsEarned'] ?? result.coinsEarned,
          totalExercises: result.totalExercises,
          firstTryCorrectCount: result.firstTryCorrectCount,
          exerciseResults: result.exerciseResults,
        );
      }
    } catch (_) {}
    return result;
  }

  Future<ChildProfile?> getProfile(String profileId) async {
    if (_useDemo) return null;
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/progress/profile/$profileId'));
      if (res.statusCode == 200) {
        return ChildProfile.fromJson(jsonDecode(res.body));
      }
    } catch (_) {}
    return null;
  }
}
