// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:ui';

// import 'package:custom_info_window/custom_info_window.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import 'package:map_events_project/MyPolyline/model/point.dart';
// import 'package:map_events_project/MyPolyline/screens/search_places.dart';
// import 'package:map_events_project/MyPolyline/widgets/custom_appBar.dart';
// import 'package:provider/provider.dart';

// import '../model/pathData.dart';
// import '../providers/path_data_provider.dart';

// import '../widgets/custom_window.dart';


// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late StreamSubscription<Position> _locationSubscription;
//   static const double _followZoom = 18.0;
//   final Completer<GoogleMapController> _controllerC = Completer();
//   late PathProvider pathProvider;

//   late GoogleMapController _controller;
//   final CustomInfoWindowController _customWindow = CustomInfoWindowController();

//   bool getPathEnabled = false;
//   LatLng? startPoint;
//   LatLng? selectedPoint;
//   LatLng? endPoint;
//   static CameraPosition _initialPosition = CameraPosition(
//       target: LatLng(33.68267889318906, -7.383542731404305), zoom: 15);

//   Set<Polyline> polylines = {};
//   Set<Marker> markers = {};
//   bool isStartPointSpecified = false;

//   //*************************** pour le filtrage ******************* */
//   List<Event> filteredEvents1 = [];
//   List<Event> filteredEvents2 = [];
//   List<String> eventTypes = [
//     'All',
//     'sportifs',
//     'accident',
//     'professionnels',
//     'sociaux'
//   ];
//   String selectedEventType = 'All';
//   //*************************** pour le filtrage ******************* */
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     pathProvider = Provider.of<PathProvider>(context, listen: false);

//     return Scaffold(
//       appBar: CustomAppBar(title: "Map Screen"),
//       body: Stack(
//         children: [
//           SafeArea(
//             child: GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 _controllerC.complete(controller);
//                 _controller = controller;
//                 _customWindow.googleMapController = controller;
//               },
//               polylines: polylines,
//               markers: markers,
//               onTap: (LatLng position) {
//                 _customWindow.hideInfoWindow!();
//               },
//               onLongPress: (position) {
//                 _handleMapTap(position);
//               },
//               onCameraMove: (position) {
//                 _customWindow.onCameraMove!();
//               },
//               initialCameraPosition: _initialPosition,
//             ),
//           ),
//           isLoading
//               ? BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                   child: Container(color: Colors.black.withOpacity(0.2)),
//                 )
//               : Container(),
//           CustomInfoWindow(
//             controller: _customWindow,
//             height: 200,
//             width: 250,
//             offset: 20,
//           ),
//           Visibility(
//             visible: getPathEnabled && pathProvider.paths.isNotEmpty,
//             child: Positioned(
//               top: 30.0,
//               right: 30.0,
//               child: Container(
//                 padding: EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(8.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.orange.withOpacity(0.5),
//                       spreadRadius: 1,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: selectedEventType,
//                     items: eventTypes.map((String type) {
//                       return DropdownMenuItem<String>(
//                         value: type,
//                         child: Container(
//                           margin: EdgeInsets.all(5),
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.green.withOpacity(0.5),
//                             borderRadius: BorderRadius.circular(8.0),
//                             border: Border.all(color: Colors.white),
//                           ),
//                           child: Center(
//                             child: Text(type),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedEventType = newValue!;

//                         _updateFilteredEvents(selectedEventType);

//                         _updatePathAndMarkers();
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 16.0,
//             left: 16.0,
//             child: FloatingActionButton(
//               onPressed: (endPoint == null && isStartPointSpecified)
//                   ? _showSearchDialog
//                   : null,
//               tooltip: 'Search',
//               child: Icon(Icons.search),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: () {
//               _getMyLocation();
//             },
//             tooltip: 'My Location',
//             child: Icon(Icons.location_on),
//           ),
//           SizedBox(height: 16.0),
//           FloatingActionButton(
//             onPressed: () async {
//               // Handle Get Path
//               if (getPathEnabled) {
//                 setState(() {
//                   isLoading = true;
//                 });
//                 print(
//                     "from hello : ${startPoint!.longitude.toString()},${startPoint!.latitude.toString()}/${endPoint!.longitude.toString()},${endPoint!.latitude.toString()}");
//                 await pathProvider.getPath(
//                     startPoint!.latitude.toString(),
//                     startPoint!.longitude.toString(),
//                     endPoint!.latitude.toString(),
//                     endPoint!.longitude.toString());
//                 setState(() {
//                   isLoading = false;
//                 });

//                 if (pathProvider.paths[0].path.isEmpty ||
//                     pathProvider.paths[1].path.isEmpty) {
//                   _showSnackbar('There is no path between these points.');
//                 } else {
//                   _buildPolylines(
//                       convertPointsToLatLng(pathProvider.paths[0].path),
//                       convertPointsToLatLng(pathProvider.paths[1].path),
//                       pathProvider.paths[0].evenement,
//                       pathProvider.paths[1].evenement);
//                 }
//               } else {
//                 _showSnackbar('Please select start and end points.');
//               }
//             },
//             tooltip: 'Get Path',
//             backgroundColor: getPathEnabled ? Colors.blue : Colors.grey,
//             child: isLoading
//                 ? const CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   )
//                 : Icon(Icons.directions),
//           ),
//           SizedBox(height: 16.0),
//           FloatingActionButton(
//             onPressed: () {
            
//             },
//             tooltip: 'Add Event',
//             child: Icon(Icons.add),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSearchDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         TextEditingController searchController = TextEditingController();

//         return AlertDialog(
//           title: Text('Specify Destination'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SearchTextField(
//                 controller: searchController,
//                 onPlaceSelected: (Prediction prediction) {
//                   print("ok ok ${prediction.lat} ... ");
//                   // Mettez à jour uniquement le point d'arrivée
//                   setState(() {
//                     selectedPoint = LatLng(
//                       double.parse(prediction.lat!),
//                       double.parse(prediction.lng!),
//                     );
//                     _handleMapTap(selectedPoint!);
//                   });
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Validate'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _buildPolylines(List<LatLng> path1, List<LatLng> path2,
//       List<Event> events1, List<Event> events2) {
//     if (startPoint != null && endPoint != null) {
//       List<LatLng> orderedPath1 = [startPoint!, ...path1, endPoint!];
//       List<LatLng> orderedPath2 = [startPoint!, ...path2, endPoint!];

//       // Créer deux ensembles de polylines
//       Set<Polyline> polylines1 = {
//         Polyline(
//           polylineId: PolylineId('path1'),
//           color: Colors.blue,
//           width: 5,
//           points: orderedPath1,
//         ),
//       };

//       Set<Polyline> polylines2 = {
//         Polyline(
//           polylineId: PolylineId('path2'),
//           color: Colors.pink,
//           width: 5,
//           points: orderedPath2,
//         ),
//       };
//       polylines = {...polylines1, ...polylines2};
//       setState(() {});
//     } else {
//       Set<Polyline> polylines1 = {
//         Polyline(
//           polylineId: PolylineId('path1'),
//           color: Colors.blue,
//           width: 5,
//           points: path1,
//         ),
//       };

//       Set<Polyline> polylines2 = {
//         Polyline(
//           polylineId: PolylineId('path2'),
//           color: Colors.pink,
//           width: 5,
//           points: path2,
//         ),
//       };
//       polylines = {...polylines1, ...polylines2};
//       setState(() {});
//     }

//     _addMarkersWithInfoWindows(events1, 'path1');
//     _addMarkersWithInfoWindows(events2, 'path2');
//   }

//   String convertDateString(String dateString) {
//     DateTime dateTime = DateTime.parse(dateString);

//     int year = dateTime.year;
//     int month = dateTime.month;
//     int day = dateTime.day;
//     return '$day/$month/$year';
//   }

//   void _addMarkersWithInfoWindows(List<Event> events, String polylineId) {
//     Color markerColor = Colors.blue;

//     if (polylineId == 'path2') {
//       markerColor = Colors.pink;
//     }

//     _addStartAndEndMarkers();

//     for (int i = 0; i < events.length; i++) {
//       String eventType = events[i].type;
//       String image = _getImageUrlForEventType(eventType);

//       Marker marker = Marker(
//         markerId: MarkerId('$polylineId-event$i'),
//         position: LatLng(double.parse(events[i].latitude),
//             double.parse(events[i].longitude)),
//         onTap: () {
//           // Check if _customWindow.addInfoWindow is not null before calling the method
//           if (_customWindow.addInfoWindow != null) {
//             _customWindow.addInfoWindow!(
//               CustomWindow(
//                 imageUrl: image,
//                 title: events[i].type.toUpperCase(),
//                 description: events[i].designation,
//                 eventDebut: convertDateString(events[i].debutDate),
//                 eventEnd: convertDateString(events[i].endDate),
//               ),
//               LatLng(double.parse(events[i].latitude),
//                   double.parse(events[i].longitude)),
//             );
//           } else {
//             print("Problem Custom window");
//           }
//         },
//         icon: BitmapDescriptor.defaultMarkerWithHue(_getColorHue(markerColor)),
//       );
//       markers.add(marker);
//     }
//   }

//   String _getImageUrlForEventType(String eventType) {
//     switch (eventType) {
//       case 'sportifs':
//         return 'https://www.ipsos.com/sites/default/files/inline-images/evenements_sportifs_et_societe.jpg';
//       case 'éducatifs':
//         return 'https://industries.ma/wp-content/uploads/2021/05/HP-696x450.jpg';
//       case 'sociaux':
//         return 'https://www.captio.fr/hs-fs/hubfs/blog-files/FR/Evenements%20d%E2%80%99entreprise.jpg?width=724&height=483&name=Evenements%20d%E2%80%99entreprise.jpg';
//       case 'professionnels':
//         return 'https://betobe.fr/wp-content/uploads/2019/01/professionnel-organiser-evenement-1024x640.jpg';
//       case 'accident':
//         return 'https://static.wixstatic.com/media/6945e3_779e60459cba4568ab889ead8daf4ebd~mv2.jpg';
//       default:
//         return 'https://www.dynamique-mag.com/wp-content/uploads/94d8155cb7f2702d2b914dbfb56699d5-780x405.jpg';
//     }
//   }

//   double _getColorHue(Color color) {
//     double hue = BitmapDescriptor.hueBlue;
//     if (color == Colors.pink) {
//       hue = BitmapDescriptor.hueRose;
//     }
//     return hue;
//   }

//   List<LatLng> convertPointsToLatLng(List<Point> points) {
//     return points.map((point) {
//       return LatLng(
//         double.parse(point.latitude),
//         double.parse(point.longitude),
//       );
//     }).toList();
//   }

//   void _handleMapTap(LatLng position) {

//     // Toggle between start and end points
//     if (startPoint == null) {
//       setState(() {
//         startPoint = position;
//         isStartPointSpecified = true;
//       });
//     } else if (endPoint == null) {
//       setState(() {
//         endPoint = position;
//         polylines.clear();
//         markers.clear();
//         // Both start and end points are specified, disable further selection
//         getPathEnabled = false;
//         isStartPointSpecified = false;

//       });
//     } else {
//       // Reset points if both start and end are selected
//       setState(() {
//         startPoint = position;
//         endPoint = null;
//         // Enable further selection
//         getPathEnabled = true;
//         isStartPointSpecified = true;
//         polylines.clear();
//         markers.clear();
//       });
//     }
//     _addMarkersWithInfoWindows([], 'path1');

   
//     setState(() {});
//     _updateGetPathButtonState();
//   }

//   void _getMyLocation() {
//     getUserLocation().then((value) async {
//       print('My location: ${value.latitude} ${value.longitude}');

//       // Set the current location as the starting point
//       startPoint = LatLng(value.latitude, value.longitude);
//       endPoint = null;
//       isStartPointSpecified=true;

//       CameraPosition cameraPosition = CameraPosition(
//         target: LatLng(value.latitude, value.longitude),
//         zoom: 10,
//       );
//       _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

//       _addMarkersWithInfoWindows(
//           [], 'path1'); // Vous devez fournir une liste d'événements ici

//       // Update the map markers
//       setState(() {});
//       // Enable further selection and update Get Path button state
//       getPathEnabled = true;
//       _updateGetPathButtonState();
  
//     });
//   }

//   Future<Position> getUserLocation() async {
//     await Geolocator.requestPermission()
//         .then((value) {})
//         .onError((error, stackTrace) => null);
//     return await Geolocator.getCurrentPosition();
//   }

//   void _updateGetPathButtonState() {
//     setState(() {
//       getPathEnabled = startPoint != null && endPoint != null;
//     });
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.red,
//         content: Text(message),
//       ),
//     );
//   }

//   void _updateFilteredEvents(String eventType) {
//     // Filtrer les événements en fonction du type sélectionné
//     filteredEvents1 = _filterEvents(pathProvider.paths[0].evenement, eventType);
//     filteredEvents2 = _filterEvents(pathProvider.paths[1].evenement, eventType);
//     print(
//         "this is for path 1 ${filteredEvents1.toList().toString()} with lenght : ${filteredEvents1.length}");
//     print(
//         "this is for path 2 ${filteredEvents2.toList().toString()} with lenght : ${filteredEvents2.length}");
//   }

//   List<Event> _filterEvents(List<Event> events, String eventType) {
//     // Filtrer les événements en fonction du type sélectionné
//     if (eventType == 'All') {
//       return events; // Retourner tous les événements si "All" est sélectionné
//     } else {
//       // Afficher le type de chaque événement
//       events.forEach((event) {
//         print(event.type);
//       });

//       // Filtrer et retourner les événements du type spécifié
//       return events.where((event) => event.type == eventType).toList();
//     }
//   }

//   void _updatePathAndMarkers() {
//     // Vérifiez si les points de départ et d'arrivée sont définis
//     if (startPoint != null && endPoint != null) {
//       // Effacez les polylignes et les marqueurs existants
//       polylines.clear();
//       markers.clear();

//       // Ajoutez les points de départ et d'arrivée
//       _addStartAndEndMarkers();

//       // Ajoutez les nouveaux marqueurs basés sur les événements filtrés
//       _addMarkersWithInfoWindows(filteredEvents1, 'path1');
//       _addMarkersWithInfoWindows(filteredEvents2, 'path2');

//       // Mettez à jour les polylignes avec les nouveaux marqueurs
//       _buildPolylines(
//         convertPointsToLatLng(pathProvider.paths[0].path),
//         convertPointsToLatLng(pathProvider.paths[1].path),
//         filteredEvents1,
//         filteredEvents2,
//       );
//     }
//   }

//   Future<void> _addStartAndEndMarkers() async {
//     double height = 120;
//     double width = 120;
//     // Ajoutez les marqueurs des points de départ et d'arrivée
//     if (startPoint != null) {
//       ui.Image startImage =
//           await getImageFromAsset('assets/images/start.png', width, height);
//       final BitmapDescriptor startIcon =
//           BitmapDescriptor.fromBytes(await getBytesFromImage(startImage));

//       markers.add(
//         Marker(
//           markerId: MarkerId('startPoint'),
//           position: startPoint!,
//           infoWindow: const InfoWindow(title: "Point Depart"),
//           icon: startIcon,
//         ),
//       );
//     }

//     if (endPoint != null) {
//       ui.Image endImage =
//           await getImageFromAsset('assets/images/arrive.png', 180, 180);
//       final BitmapDescriptor endIcon =
//           BitmapDescriptor.fromBytes(await getBytesFromImage(endImage));

//       markers.add(
//         Marker(
//           markerId: MarkerId('endPoint'),
//           position: endPoint!,
//           infoWindow: const InfoWindow(title: "Point D arrivee"),
//           icon: endIcon,
//         ),
//       );
//     }

//     setState(() {}); // Force la mise à jour de l'interface graphique
//   }

//   Future<ui.Image> getImageFromAsset(
//       String path, double width, double height) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(
//         Uint8List.sublistView(data.buffer.asUint8List()));
//     ui.FrameInfo fi = await codec.getNextFrame();

//     // Créer une image redimensionnée avec la largeur et la hauteur spécifiées
//     return await fi.image
//         .toByteData(format: ui.ImageByteFormat.png)
//         .then((ByteData? byteData) {
//       final buffer = byteData!.buffer.asUint8List();
//       return ui
//           .instantiateImageCodec(Uint8List.fromList(buffer),
//               targetWidth: width.toInt(), targetHeight: height.toInt())
//           .then((ui.Codec codec) {
//         return codec.getNextFrame().then((ui.FrameInfo info) {
//           return info.image;
//         });
//       });
//     });
//   }

//   Future<Uint8List> getBytesFromImage(ui.Image image) async {
//     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     return byteData!.buffer.asUint8List();
//   }
// }
