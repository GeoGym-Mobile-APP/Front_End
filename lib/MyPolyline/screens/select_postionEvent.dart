import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_events_project/MyPolyline/widgets/custom_appBar.dart';

class MapSelectionPage extends StatefulWidget {
  @override
  _MapSelectionPageState createState() => _MapSelectionPageState();
}

class _MapSelectionPageState extends State<MapSelectionPage> {
  late GoogleMapController _controller;
  LatLng? selectedPosition;

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) => null);
    return await Geolocator.getCurrentPosition();
  }

  void _getMyLocation() {
    getUserLocation().then((value) async {
      print('My location: ${value.latitude} ${value.longitude}');

      setState(() {
        // Mettre à jour selectedPosition avec la position actuelle
        selectedPosition = LatLng(value.latitude, value.longitude);
      });

      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 18,
      );
      _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Select position of the event"),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        onTap: (LatLng position) {
          setState(() {
            selectedPosition = position;
          });
        },
        markers: Set<Marker>.of(
          selectedPosition != null
              ? [
                  Marker(
                    markerId: MarkerId(selectedPosition.toString()),
                    position: selectedPosition!,
                    infoWindow: InfoWindow(
                      title: 'My location',
                    ),
                  ),
                ]
              : [],
        ),
        initialCameraPosition: CameraPosition(
          target: LatLng(33.56680573565653, -7.586878750841545),
          zoom: 12.0,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _getMyLocation(); // Appeler la fonction pour obtenir la position actuelle
            },
            tooltip: 'Get My Location',
            child: Icon(Icons.location_on),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context, selectedPosition);
            },
            tooltip: 'Save',
            child: Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
