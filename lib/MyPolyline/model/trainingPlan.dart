import 'exercice.dart';

class TrainingPlan {
  int id;
  int durre;


  TrainingPlan({
        required this.id,
    required this.durre,
  });

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(
      id:json['id'],
      durre:json['duree'],
    );
  }

}
