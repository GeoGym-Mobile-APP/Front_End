import 'movement.dart';

class Exercise {
  int id;
  String nom;
  String description;
  int niveauDifficulte;
  int duree;

  Exercise({
    required this.id,
    required this.nom,
    required this.description,
    required this.niveauDifficulte,
    required this.duree,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id:json['id'],
      nom: json['nom'],
      description: json['description'],
      duree: json['duree'],
      niveauDifficulte: json['niveauDifficulte']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name': nom,
    };
  }
}