import 'package:flutter/material.dart';
import '../Api/api_Objectifs.dart';
import '../model/objective.dart';
import 'homePlanEntrainement.dart';

class HomeObjectifs extends StatefulWidget {
  @override
  _HomeObjectifsState createState() => _HomeObjectifsState();
}

class _HomeObjectifsState extends State<HomeObjectifs> {
  Future<List<Objective>>? _objectifsFuture;

  @override
  void initState() {
    super.initState();
    _objectifsFuture = ObjectiveApi('https://afe5-41-250-28-38.ngrok-free.app')
        .getAllObjectives();
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
                    'Objectifs',
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
          Container(
            margin: EdgeInsets.only(top: 120),
            child: FutureBuilder(
              future: _objectifsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Erreur de chargement des objectifs'));
                } else if (!snapshot.hasData ||
                    (snapshot.data as List<Objective>).isEmpty) {
                  return Center(child: Text('Aucun objectif disponible'));
                } else {
                  List<Objective> objectifs = snapshot.data as List<Objective>;
          
                  return ListView.builder(
                    itemCount: objectifs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                          color:Colors.deepOrange,
                          elevation: 3.0,
                          child: ListTile(
                            title: Text(objectifs[index].nom, style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrainingPlansScreen(
                                      objectiveId:
                                          objectifs[index].id.toString()),
                                ),
                              );
                            },
                            trailing: Icon(Icons.arrow_forward,size: 30,),
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
