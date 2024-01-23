import '../model/exercice.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciseApi {
  final String baseUrl;

  ExerciseApi(this.baseUrl);

  Future<List<Exercise>> getExercisesByPlanId(String planId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/exercices/by-plan/$planId'));
    print("url : $baseUrl/api/exercices/by-plan/$planId");

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
       print('JSON List: $jsonList');  
      return jsonList.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercises for training plan $planId');
    }
  }
}