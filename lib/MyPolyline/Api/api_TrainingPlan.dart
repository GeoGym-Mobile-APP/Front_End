import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/trainingPlan.dart';


class TrainingPlanApi {
  final String baseUrl;

  TrainingPlanApi(this.baseUrl);

  Future<List<TrainingPlan>> getTrainingPlansByObjectiveId(String objectiveId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/plans/by-objectif/$objectiveId'));
    print("url : $baseUrl/api/plans/by-objectif/$objectiveId");

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
       print('JSON List: $jsonList');  
      return jsonList.map((json) => TrainingPlan.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load training plans for objective $objectiveId');
    }
  }
}