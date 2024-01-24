import 'package:flutter/material.dart';

class EventModel {
  final int id;
  final String title;
  final String description;
  final String imagePath;
  final DateTime startDate;
  final String startTime;
  final String endTime;
  final double longt;
  final double lapt;

  // Extracting the day from the startDate
  final String day;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.startDate,
    required this.startTime,
    required this.endTime,
    required this.longt,
    required this.lapt,

  }) : day = _getFormattedDay(startDate);

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as int ,
      title: json['title'],
      description: json['description'],
      imagePath: json['imagePath'],
      startDate: DateTime.parse(json['startDate']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      longt: json['longt'] as double,
      lapt: json['lapt'] as double,
    );
  }
  @override
String toString() {
  return 'EventModel{id: $id, title: $title, description: $description, day : ${startDate.weekday}}';
}


  // Function to get the formatted day
  static String _getFormattedDay(DateTime date) {
    // You can customize the format based on your preference
    return "${date.day}-${date.month}-${date.year}";
  }
}
