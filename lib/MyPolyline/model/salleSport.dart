
class SalleDeSport {
  int id;
  String nom;
  String numeroTelephone;
  List<String> equipementsArray;
  String heureOuverture;
  String heureFermeture;
  String typeActivite;
  double tarifAdhesionMensuelle;
  double tarifAdhesionAnnuelle;
  double latitude;
  double longitude;

  SalleDeSport({
    required this.id,
    required this.nom,
    required this.numeroTelephone,
    required this.equipementsArray,
    required this.heureOuverture,
    required this.heureFermeture,
    required this.typeActivite,
    required this.tarifAdhesionMensuelle,
    required this.tarifAdhesionAnnuelle,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
  return {
    'id':id,
    'nom': nom,
    'numeroTelephone': numeroTelephone,
    'equipementsArray': equipementsArray,
    'heureOuverture': heureOuverture,
    'heureFermeture': heureFermeture,
    'typeActivite': typeActivite,
    'tarifAdhesionMensuelle': tarifAdhesionMensuelle,
    'tarifAdhesionAnnuelle': tarifAdhesionAnnuelle,
    'latitude': latitude,
    'longitude': longitude,
  };
}
factory SalleDeSport.fromJson(Map<String, dynamic> json) {
  return SalleDeSport(
    id:json['id'] as int,
    nom: json['nom'],
    numeroTelephone: json['numeroTelephone'],
    equipementsArray: List<String>.from(json['equipementsArray']),
    heureOuverture: json['heureOuverture'],
    heureFermeture: json['heureFermeture'],
    typeActivite: json['typeActivite'],
    tarifAdhesionMensuelle: json['tarifAdhesionMensuelle'],
    tarifAdhesionAnnuelle: json['tarifAdhesionAnnuelle'],
    latitude: json['latitude'],
    longitude: json['longitude'],
  );
}


}
