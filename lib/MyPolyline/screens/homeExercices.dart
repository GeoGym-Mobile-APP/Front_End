import 'package:flutter/material.dart';
import '../Api/api_Exercice.dart';
import '../model/exercice.dart';
import '../Api/api_Movements.dart';
import '../model/movement.dart';

class ExercisesScreen extends StatefulWidget {
  final String trainingPlanId; // ID du plan d'entraînement sélectionné

  ExercisesScreen({required this.trainingPlanId});

  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  Future<List<Exercise>>? _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = ExerciseApi('https://afe5-41-250-28-38.ngrok-free.app')
        .getExercisesByPlanId(widget.trainingPlanId);
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Colors.black, size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Exercices',
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
                shape: RoundedRectangleBorder(
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
              future: _exercisesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Erreur de chargement des exercices'));
                } else if (!snapshot.hasData ||
                    (snapshot.data as List<Exercise>).isEmpty) {
                  return Center(child: Text('Aucun exercice disponible'));
                } else {
                  List<Exercise> exercises = snapshot.data as List<Exercise>;

                  return ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                          color: Colors.black,
                          child: ExpansionTile(
                            title: Text(
                              exercises[index].nom,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            children: [
                              FutureBuilder(
                                future: MovementApi(
                                        'https://afe5-41-250-28-38.ngrok-free.app')
                                    .getMovementsByExerciseId(
                                        exercises[index].id.toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                        child: Text(
                                            'Erreur de chargement des mouvements'));
                                  } else if (!snapshot.hasData ||
                                      (snapshot.data as List<Movement>)
                                          .isEmpty) {
                                    return const Center(
                                        child:
                                            Text('Aucun mouvement disponible'));
                                  } else {
                                    List<Movement> movements =
                                        snapshot.data as List<Movement>;

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: movements.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: GestureDetector(
                                            onTap: () {
                                              // Afficher un dialogue ou naviguer vers une nouvelle page avec plus de détails sur le mouvement
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Colors.black,
                                                    title: Text(
                                                      movements[index].nom,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25),
                                                    ),
                                                    content: Image.network(
                                                      'URL_de_votre_image',
                                                      width: 200,
                                                      height: 200,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Fermer',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Card(
                                              color: Colors.orange,
                                              elevation:
                                                  5, // Ajustez cette valeur selon vos préférences
                                              margin: EdgeInsets.all(
                                                  10), // Ajoutez un padding autour du Card
                                              child: ListTile(
                                                title: Text(
                                                  movements[index].nom,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                trailing: Icon(
                                                  Icons.arrow_forward,
                                                  size: 25,
                                                ), // Ajoutez l'icône ou le widget souhaité ici
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
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
