import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:map_events_project/MyPolyline/screens/ScreenPath.dart';

import '../model/salleSport.dart';
import '../widgets/tarifCard.dart';

class DetailsSalleSport extends StatelessWidget {
  final SalleDeSport salleDeSport;

  DetailsSalleSport({required this.salleDeSport});

  @override
  Widget build(BuildContext context) {
    double largeurEcran = MediaQuery.of(context).size.width;
    void _getRoute(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,


  ) async {
    final endpoint = "https://afe5-41-250-28-38.ngrok-free.app/alternative-paths/-7.390107344006293,33.679689304958444/-7.3827094599591785,33.68313341250354";
   
    final response = await http.get(Uri.parse(endpoint));
 
    if (response.statusCode == 200) {
      // Si la requête est réussie, analysez le JSON pour obtenir les points du chemin
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> path = jsonResponse.map((point) {
        return {
          "lat": point["lat"],
          "lon": point["lon"],
        };
      }).toList();

      print(" cc $path");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenPath(pathPoints: path),
        ),
      );
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

    Future<Position> getUserLocation() async {
      await Geolocator.requestPermission()
          .then((value) {})
          .onError((error, stackTrace) => null);
      return await Geolocator.getCurrentPosition();
    }

    void _getMyLocation() async {
      Position currentPosition = await getUserLocation();
      print('My location: ${currentPosition.latitude} ${currentPosition.longitude}');

      // Coordonnées de la salle de sport
      double salleLatitude = salleDeSport.latitude;
      double salleLongitude = salleDeSport.longitude;

      // Appel à la fonction pour récupérer le chemin
      _getRoute(
        currentPosition.latitude,
        currentPosition.longitude,
        salleLatitude,
        salleLongitude,
      );
    }

    FloatingActionButton callButton = FloatingActionButton(
      onPressed: () {},
      tooltip: 'Appeler',
      backgroundColor: Colors.green,
      child: const Icon(
        Icons.call,
        color: Colors.white,
      ),
    );

    FloatingActionButton routeButton = FloatingActionButton(
  onPressed: () {
    _getMyLocation();
  },
  tooltip: 'Itinéraire',
  backgroundColor: Colors.lightBlue,
  child: Icon(Icons.directions, color: Colors.white),
);


    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: largeurEcran,
            padding: EdgeInsets.only(bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: largeurEcran * 0.88,
                      height: 150.0,
                      margin: EdgeInsets.only(
                          top: 150.0), // Ajoutez le marginTop ici

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/homegym.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: largeurEcran * 0.88,
                      margin: EdgeInsets.only(top: 20.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        salleDeSport.nom,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      width: largeurEcran * 0.88,
                      margin: EdgeInsets.only(top: 20.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          salleDeSport.typeActivite,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      width: largeurEcran * 0.88,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ExpansionTile(
                        title: const Text(
                          'Equipements',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        children: [
                          for (var equipement in salleDeSport.equipementsArray)
                            ListTile(
                              title: Text(
                                equipement,
                                style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      padding: EdgeInsets.only(right: 22, left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: largeurEcran * 0.4,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                ),
                                const Text(
                                  'Start',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${salleDeSport.heureOuverture}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: largeurEcran * 0.40,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                ),
                                const Text(
                                  'End',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${salleDeSport.heureFermeture}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    /*** */
                    SizedBox(height: 16.0),
                    Container(
                      padding: EdgeInsets.all(15),
                      width: largeurEcran * 0.88,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Tarifs',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8.0),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                TarifCard(
                                  label: 'Adhesion Mensuelle',
                                  value: salleDeSport.tarifAdhesionMensuelle,
                                ),
                                SizedBox(width: 16.0),
                                TarifCard(
                                  label: 'Adhesion Annuelle',
                                  value: salleDeSport.tarifAdhesionAnnuelle,
                                ),
                                // Ajoutez d'autres cartes tarifaires selon votre modèle
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
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
                title: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Details of ${salleDeSport.nom}',
                    style: const TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: callButton,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: routeButton,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
