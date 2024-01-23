import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/eventSport.dart';

class EventApi {
  final String baseUrl;

  EventApi({required this.baseUrl});

  Future<List<EventModel>> getAllEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/api/events'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((event) => EventModel.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}
