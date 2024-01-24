class Movement {
  int id;
  String nom;
  String image;

  Movement({
    required this.id,
    required this.nom,
    required this.image,
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id:json['id'],
      nom: json['nom'],
      image:json['image']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'nom': nom,
      'image':image
    };
  }
}