class Movement {
  int id;
  String nom;

  Movement({
    required this.id,
    required this.nom,
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id:json['id'],
      nom: json['nom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'nom': nom,
    };
  }
}