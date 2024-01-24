import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:map_events_project/MyPolyline/screens/ScreenPath.dart';
import '../model/eventSport.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;


class EventDetails extends StatefulWidget {
  final EventModel event;

  const EventDetails({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String _getFormattedDayName(DateTime date) {
    List<String> dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    int dayIndex = date.weekday;

    String dayName = dayNames[dayIndex - 1];

    return dayName;
  }

  @override
  Widget build(BuildContext context) {
    double largeurEcran = MediaQuery.of(context).size.width;
    void _getRoute(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,


  ) async {
    final endpoint = "https://e4d9-105-159-141-163.ngrok-free.app/alternative-paths/-7.390107344006293,33.679689304958444/-7.3827094599591785,33.68313341250354";
   
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
      double EventLatitude = widget.event.lapt;
      double EventLongitude = widget.event.longt;

      // Appel à la fonction pour récupérer le chemin
      _getRoute(
        currentPosition.latitude,
        currentPosition.longitude,
        EventLatitude,
        EventLongitude,
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            padding: EdgeInsets.only(bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image de l'événement
                    Container(
                      width: largeurEcran * 0.88,
                      height: 150.0,
                      margin: EdgeInsets.only(top: 150.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage("assets/images/sevent.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.black, // Couleur de fond du conteneur
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              widget.event.startDate.day.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            _getFormattedDayName(widget.event.startDate),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Titre de l'événement dans un container avec background black
                    Container(
                      width: largeurEcran * 0.88,
                      margin: EdgeInsets.only(top: 20.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        widget.event.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),

                    // Description de l'événement dans un ExpandTile, lui-même dans un container
                    Container(
                      width: largeurEcran * 0.88,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              widget.event.description,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),

                    // Horaires de l'événement dans un container avec icône de timing
                    Container(
                      padding: EdgeInsets.only(right: 10, left: 10),
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
                                  '${widget.event.startTime}',
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
                                  '${widget.event.endTime}',
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
                    SizedBox(height: 20.0),
                    Container(
                      width: largeurEcran * 0.88,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors
                            .black, // Couleur pour les frais d'inscription
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(
                            'Frais d\'inscription',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            ' 20 DH',
                            style:  TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                title: const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Details events',
                    style: TextStyle(
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _getMyLocation();
        },
        backgroundColor: Colors.white,
        icon: const Icon(
          Icons.directions,
          color: Colors.green,
          size: 30,
        ),
        label: const Text(
          "Itinéraire",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
