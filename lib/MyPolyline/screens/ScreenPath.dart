import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenPath extends StatelessWidget {
  final List<Map<String, dynamic>> pathPoints;

  ScreenPath({required this.pathPoints});

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [
      Marker(
        markerId: MarkerId('start'),
        position: LatLng(pathPoints.first['lat']!, pathPoints.first['lon']!),
        infoWindow: InfoWindow(title: 'Start'),
      ),
      Marker(
        markerId: MarkerId('end'),
        position: LatLng(pathPoints.last['lat']!, pathPoints.last['lon']!),
        infoWindow: InfoWindow(title: 'End'),
      ),
    ];

// Convertissez la liste de marqueurs en un ensemble de marqueurs
    Set<Marker> markerSet = Set.from(markers);
    return Scaffold(
      
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(pathPoints.first['lat']!, pathPoints.first['lon']!),
              zoom: 15.0,
            ),
            markers: markerSet,
            polylines: {
              Polyline(
                polylineId: PolylineId('path'),
                points: pathPoints
                    .map(
                      (point) => LatLng(point['lat']!, point['lon']!),
                    )
                    .toList(),
                color: Colors.blue,
                width: 4,
              ),
            },
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
                  padding:  EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Chemin Optimal',
                    style:  TextStyle(
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
    );
  }
}
