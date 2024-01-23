import 'package:flutter/material.dart';
import '../Api/api_Exercice.dart';
import '../model/exercice.dart';
import 'homeMovement.dart';

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
    _exercisesFuture = ExerciseApi('https://afe5-41-250-28-38.ngrok-free.app').getExercisesByPlanId(widget.trainingPlanId);
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
                backgroundColor: Colors
                    .black, 
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
          FutureBuilder(
            future: _exercisesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur de chargement des exercices'));
              } else if (!snapshot.hasData || (snapshot.data as List<Exercise>).isEmpty) {
                return Center(child: Text('Aucun exercice disponible'));
              } else {
                List<Exercise> exercises = snapshot.data as List<Exercise>;

                return ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(exercises[index].nom),
                      onTap: () {
                        // Naviguer vers l'écran de détails de l'exercice en passant l'exercice sélectionné
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovementsScreen(exerciseId: exercises[index].id.toString()),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
