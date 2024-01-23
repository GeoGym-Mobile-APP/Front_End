import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/objective.dart';

class ObjectiveApi {
  final String baseUrl;

  ObjectiveApi(this.baseUrl);

  Future<List<Objective>> getAllObjectives() async {
    final response = await http.get(Uri.parse('$baseUrl/api/objectifs'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
       print('JSON List: $jsonList');  
      return jsonList.map((json) => Objective.fromJson(json)).toList();
    } else {
      print("ohh its error");
      throw Exception('Failed to load objectives');
    }
  }
}