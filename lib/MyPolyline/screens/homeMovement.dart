import 'package:flutter/material.dart';
import '../Api/api_Movements.dart';
import '../model/movement.dart';

class MovementsScreen extends StatefulWidget {
  final String exerciseId; // ID de l'exercice sélectionné

  MovementsScreen({required this.exerciseId});

  @override
  _MovementsScreenState createState() => _MovementsScreenState();
}

class _MovementsScreenState extends State<MovementsScreen> {
  Future<List<Movement>>? _movementsFuture;

  @override
  void initState() {
    super.initState();
    _movementsFuture = MovementApi('https://afe5-41-250-28-38.ngrok-free.app').getMovementsByExerciseId(widget.exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mouvements'),
      ),
      body: FutureBuilder(
        future: _movementsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des mouvements'));
          } else if (!snapshot.hasData || (snapshot.data as List<Movement>).isEmpty) {
            return Center(child: Text('Aucun mouvement disponible'));
          } else {
            List<Movement> movements = snapshot.data as List<Movement>;

            return ListView.builder(
              itemCount: movements.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(movements[index].nom),
                  // Ajoutez ici d'autres widgets pour afficher les détails du mouvement si nécessaire
                );
              },
            );
          }
        },
      ),
    );
  }
}
