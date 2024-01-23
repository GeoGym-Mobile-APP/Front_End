// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:custom_info_window/custom_info_window.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'providers/path_data_provider.dart';

// import 'widgets/custom_window.dart';

// class MyPolyline extends StatefulWidget {
//   @override
//   State<MyPolyline> createState() => _MyPolylineState();
// }

// class _MyPolylineState extends State<MyPolyline> {
//   final Completer<GoogleMapController> _controller = Completer();
//   final CustomInfoWindowController _customWindow = CustomInfoWindowController();

//   static const CameraPosition _initialPosition =
//       CameraPosition(target: sourceLoc, zoom: 15);

//   static const LatLng sourceLoc = LatLng(33.5411488, -7.5794811);
//   static const LatLng destinationLoc = LatLng(33.5170524, -7.6319347);
//   LatLng? startPoint;
//   LatLng? endPoint;

//   final Set<Marker> myMarkers = {};
//   final Set<Polyline> myPolylines = {};

//   List<LatLng> path = [];

//   List<LatLng> myPoints = const [
//     sourceLoc,
//     LatLng(33.59723669114657, -7.51447048130744),
//     LatLng(33.59937500128048, -7.510567201323392),
//     LatLng(33.60131685117195, -7.507213857184443),
//     destinationLoc,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     //packDataMarkers();

//     for (int i = 0; i < myPoints.length; i++) {
//       myMarkers.add(Marker(
//           markerId: MarkerId(i.toString()),
//           position: myPoints[i],
//           // infoWindow:
//           //     InfoWindow(title: 'Advantures places', snippet: '10 out 10'),
//           //icon: BitmapDescriptor.defaultMarker
//           onTap: () {
//             _customWindow.addInfoWindow!(
//                 CustomWindow(
//                   imageUrl:
//                       'https://static.wixstatic.com/media/6945e3_779e60459cba4568ab889ead8daf4ebd~mv2.jpg',
//                   title: 'Accident cars',
//                   description: 'Description hereeee.............',
//                   eventDate:
//                       DateTime.now(), // Replace with the actual event date
//                 ),
//                 myPoints[i]);
//           }));

//       setState(() {});
//       myPolylines.add(
//         Polyline(
//             polylineId: PolylineId('first'),
//             points: myPoints,
//             color: Colors.purple,
//             width: 6),
//       );
//     }
//   }

//   Future<Uint8List> getImageFromMarker(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetHeight: width);
//     ui.FrameInfo frameInfo = await codec.getNextFrame();
//     return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   packDataMarkers() async {
//     final Uint8List iconMarker =
//         await getImageFromMarker('assets/images/car.png', 90);
//     myMarkers.add(Marker(
//         markerId: MarkerId('carMarker'),
//         position: sourceLoc,
//         icon: BitmapDescriptor.fromBytes(iconMarker),
//         infoWindow: const InfoWindow(title: 'carMaker')));
//     setState(() {});
//   }

//   Future<Position> getUserLocation() async {
//     await Geolocator.requestPermission()
//         .then((value) {})
//         .onError((error, stackTrace) => null);
//     return await Geolocator.getCurrentPosition();
//   }

//   packData() {
//     getUserLocation().then((value) async {
//       print('my location');
//       print('${value.latitude} ${value.longitude}');

//       myMarkers.add(
//         Marker(
//             markerId: const MarkerId('currentLocation'),
//             position: LatLng(value.latitude, value.longitude),
//             infoWindow: const InfoWindow(
//               title: 'My location',
//             )),
//       );

//       CameraPosition cameraPosition = CameraPosition(
//           target: LatLng(value.latitude, value.longitude), zoom: 18);
//       final GoogleMapController controller = await _controller.future;
//       controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//       setState(() {});
//     });
//   }

//   void addMarker(LatLng position, String markerId) {
//     myMarkers.add(
//       Marker(
//         markerId: MarkerId(markerId),
//         position: position,
//         infoWindow: InfoWindow(title: markerId),
//         icon: BitmapDescriptor.defaultMarker,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           SafeArea(
//             child: GoogleMap(
//               initialCameraPosition: _initialPosition,
//               markers: myMarkers,
//               polylines: myPolylines,
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//                 _customWindow.googleMapController = controller;
//               },
//               onTap: (position) {
//                 _customWindow.hideInfoWindow!();
//               },
//               onLongPress: (LatLng p) {
//                 setState(() {
//                   setState(() {
//                     if (startPoint == null) {
//                       startPoint = p;
//                       addMarker(startPoint!, 'Point de départ');
//                     } else if (endPoint == null) {
//                       endPoint = p;
//                       addMarker(endPoint!, 'Point d\'arrivée');
//                     } else {
//                       startPoint = p;
//                       endPoint = null;
//                       myMarkers.clear();
//                       addMarker(startPoint!, 'Point de départ');
//                     }
//                   });
//                 });
//               },
//               onCameraMove: (position) {
//                 _customWindow.onCameraMove!();
//               },
//             ),
//           ),
//           CustomInfoWindow(
//             controller: _customWindow,
//             height: 200,
//             width: 250,
//             offset: 20,
//           ),
//         ],
//       ),
//       floatingActionButton: Align(
//         alignment: Alignment.bottomCenter,
//         child: FloatingActionButton(
//           onPressed: () async {
//             PathProvider pathProvider =
//                 Provider.of<PathProvider>(context, listen: false);
//             await pathProvider.getPath(
//                 '33.5411488', '-7.5794811', '33.5170524', '-7.6319347');

//             // Mettre à jour la liste des points de la polyline avec le nouveau chemin
//             // setState(() {
//             //   myPolylines.clear();
//             //   myPolylines.add(
//             //     Polyline(
//             //       polylineId: PolylineId('path'),
//             //       points: pathProvider.path,
//             //       color: Colors.purple,
//             //       width: 6,
//             //     ),
//             //   );
//             // });
//           },
//           child: Icon(Icons.radio_button_off),
//           mini: false,
//         ),
//       ),
//     );
//   }
// }
