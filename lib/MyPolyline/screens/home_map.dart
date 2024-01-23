import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_events_project/MyPolyline/screens/calendar_events.dart';
import 'package:map_events_project/MyPolyline/screens/homeObjectifs.dart';

import '../Api/api_salleSport.dart';
import '../model/salleSport.dart';
import 'DetailsSalleSport.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(33.681187189416036, -7.386349389370758);
  List<SalleDeSport> sallesDeSport = [];
  Set<Marker> markers = {};
  bool isLoading = true;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    try {
      sallesDeSport = await ApiSalleSport(
              baseUrl: 'https://afe5-41-250-28-38.ngrok-free.app')
          .getAllSallesSport();

      for (SalleDeSport salle in sallesDeSport) {
        markers.add(
          Marker(
            markerId: MarkerId(salle.nom),
            position: LatLng(salle.latitude, salle.longitude),
            infoWindow: InfoWindow(
              title: salle.nom,
              snippet: 'Cliquez pour plus de détails',
              onTap: () {
                // Gérer le clic sur la fenêtre d'information
                _onMarkerTapped(salle);
              },
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des salles de sport : $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Gérer le clic sur la fenêtre d'information
  void _onMarkerTapped(SalleDeSport salle) {
    double largeurEcran = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          width: largeurEcran,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                salle.nom,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('Type d\'activité: ${salle.typeActivite}'),
              SizedBox(height: 8.0),
              Text('Heure d\'ouverture: ${salle.heureOuverture}'),
              SizedBox(height: 8.0),
              Text('Heure de fermeture: ${salle.heureFermeture}'),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  // Naviguer vers les détails de la salle de sport
                  _navigateToDetailsScreen(salle);
                },
                child: Text('Voir les détails'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToDetailsScreen(SalleDeSport salle) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => DetailsSalleSport(salleDeSport: salle)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: markers,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              child: AppBar(
                title: const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'GeoGym',
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Material(
              shape: CircleBorder(
                  side: BorderSide(color: Colors.deepOrange, width: 2.0)),
              elevation: 5.0,
              color: Colors.blue,
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 70,
                height: 70,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => CalendarEvents()),
                    );
                  },
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.calendar_month_outlined,
                      color: Colors.white, size: 30),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Material(
              shape: CircleBorder(
                  side: BorderSide(color: Colors.white, width: 2.0)),
              elevation: 5.0,
              color: Colors.blue,
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 70,
                height: 70,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => HomeObjectifs()),
                    );
                  },
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.settings, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
