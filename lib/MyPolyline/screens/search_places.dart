import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(Prediction) onPlaceSelected;

  SearchTextField({
    required this.controller,
    required this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      googleAPIKey: "AIzaSyAhcJr7vuC1Fo00wZTMH0XNi1RzHUMsht4",
      inputDecoration: const InputDecoration(
        hintText: "Search your location",
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      debounceTime: 400,
      countries: ["ma"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        print("Latitude: ${prediction.lat}, Longitude: ${prediction.lng}");
        onPlaceSelected(prediction);
      },
      itemClick: (Prediction prediction) {
        controller.text = prediction.description ?? "";
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: prediction.description?.length ?? 0),
        );
        if (prediction.lat != null) {
          print("hello hello : ${prediction.lat}");
          onPlaceSelected(prediction);
        } else {
          print("hello hello : Latitude is null");
        }
      },
      seperatedBuilder: Divider(),
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 7),
              Expanded(child: Text("${prediction.description ?? ""}"))
            ],
          ),
        );
      },
      isCrossBtnShown: true,
    );
  }
}
