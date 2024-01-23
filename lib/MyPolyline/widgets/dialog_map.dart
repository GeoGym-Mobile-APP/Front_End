import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDialog extends StatefulWidget {

  final Function(LatLng) onLocationSelected;

  MapDialog({required this.onLocationSelected});

  @override
  _MapDialogState createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  LatLng _selectedPosition = LatLng(0, 0);
  LatLng positionActuelle = LatLng(0, 0);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    packData();
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) => null);
    return await Geolocator.getCurrentPosition();
  }

  packData() {
    getUserLocation().then((value) async {
      print('my location');
      print('${value.latitude} ${value.longitude}');
      positionActuelle = LatLng(value.latitude, value.longitude);

      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 18);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      // Mettre à jour l'interface utilisateur après le délai
      setState(() {});
    });
  }


  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onMapLongPress(LatLng tappedPosition) {
  
    _markers.clear();

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(tappedPosition.toString()),
          position: tappedPosition,
          infoWindow: InfoWindow(
            title: 'Postion of the event',
          ),
        ),
      );

      // Save the selected position
      _selectedPosition = tappedPosition;
    });
  }

   void _handleOkButtonClick(BuildContext context) {
    if (_selectedPosition == LatLng(0, 0)) {
    
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      widget.onLocationSelected(_selectedPosition);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Location'),
      content: Container(
        width: double.maxFinite,
        height: 300.0,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: positionActuelle,
            zoom: 15.0,
          ),
          markers: _markers,
          onLongPress: _onMapLongPress,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _handleOkButtonClick(context);
          },
          child: _isLoading
              ? CircularProgressIndicator()
              : Text('OK'),
        ),
      ],
    );
  }
}