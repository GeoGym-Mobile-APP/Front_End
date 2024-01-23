

import '../model/movement.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class MovementApi {
  final String baseUrl;

  MovementApi(this.baseUrl);

  Future<List<Movement>> getMovementsByExerciseId(String exerciseId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/mouvements/byExercice/$exerciseId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Movement.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movements for exercise $exerciseId');
    }
  }
}