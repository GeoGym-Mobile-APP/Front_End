

import '../model/salleSport.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiSalleSport {
  final String baseUrl;

  ApiSalleSport({required this.baseUrl});

  Future<List<SalleDeSport>> getAllSallesSport() async {
    final response = await http.get(Uri.parse('$baseUrl/api/salles'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      
      return jsonResponse.map((json) => SalleDeSport.fromJson(json)).toList();
    } else {
      throw Exception('Échec de la récupération des salles de sport');
    }
  }

  Future<SalleDeSport> getSalleSportById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/salles_de_sport/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return SalleDeSport.fromJson(jsonResponse);
    } else {
      throw Exception('Échec de la récupération de la salle de sport par ID');
    }
  }

  Future<void> createSalleDeSport(SalleDeSport salleDeSport) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salles_de_sport'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(salleDeSport.toJson()),
    );

    if (response.statusCode == 201) {
      print('Salle de sport créée avec succès.');
    } else {
      throw Exception('Échec de la création de la salle de sport');
    }
  }
}
