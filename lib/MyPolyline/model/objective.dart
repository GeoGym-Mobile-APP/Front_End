import 'dart:convert';

import 'trainingPlan.dart';

class Objective {
  int id;
  String nom;


  Objective({
        required this.id,
    required this.nom,
  });

  factory Objective.fromJson(Map<String, dynamic> json) {
    return Objective(
      id:json['id'],
      nom: json['nom'],
    );
  }

}