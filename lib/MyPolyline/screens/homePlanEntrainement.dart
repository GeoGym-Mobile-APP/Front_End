import 'package:flutter/material.dart';
import '../Api/api_TrainingPlan.dart';
import '../model/trainingPlan.dart';
import 'homeExercices.dart';

class TrainingPlansScreen extends StatefulWidget {
  final String objectiveId; // ID de l'objectif sélectionné

  TrainingPlansScreen({required this.objectiveId});

  @override
  _TrainingPlansScreenState createState() => _TrainingPlansScreenState();
}

class _TrainingPlansScreenState extends State<TrainingPlansScreen> {
  Future<List<TrainingPlan>>? _trainingPlansFuture;

  @override
  void initState() {
    super.initState();
    _trainingPlansFuture =
        TrainingPlanApi('https://e4d9-105-159-141-163.ngrok-free.app')
            .getTrainingPlansByObjectiveId(widget.objectiveId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              child: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.black, size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
                title: const Padding(
                  padding:  EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Plan Entrainement',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.black,
                elevation:
                    0, // Supprimez l'ombre de la AppBar si vous le souhaitez
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 120),
            child: FutureBuilder(
              future: _trainingPlansFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                          'Erreur de chargement des plans d\'entraînement'));
                } else if (!snapshot.hasData ||
                    (snapshot.data as List<TrainingPlan>).isEmpty) {
                  return const Center(
                      child: Text('Aucun plan d\'entraînement disponible'));
                } else {
                  List<TrainingPlan> trainingPlans =
                      snapshot.data as List<TrainingPlan>;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: trainingPlans.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Card(
                          color: Colors.blueAccent,
                          elevation: 3.0,
                          child: ListTile(
                            title: Center(
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue, // Couleur du cercle
                                ),
                                padding: EdgeInsets.all(30.0),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                        trainingPlans[index].durre.toString(),
                                        style: TextStyle(color: Colors.white,fontSize: 22),
                                      ),
                                      SizedBox(
                                          width:
                                              8.0), // Espacement entre le texte et le cercle
                                      Text('mn',style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold) ,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              // Naviguer vers l'écran de détails du plan d'entraînement en passant le plan sélectionné
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExercisesScreen(
                                      trainingPlanId:
                                          trainingPlans[index].id.toString()),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
