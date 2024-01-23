import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomWindow extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String eventDebut;
  final String eventEnd;

  CustomWindow(
      {required this.imageUrl,
      required this.title,
      required this.description,
      required this.eventDebut,
      required this.eventEnd});

  @override
  Widget build(BuildContext context) {
    print("date: ${eventDebut}");

    return Container(
      height: 300,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.brown,
        border: Border.all(color: Colors.red, width: 5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 300,
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.fitWidth,
                  filterQuality: FilterQuality.high,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.blue, size: 20),
                        SizedBox(width: 5),
                        Text(
                          'De ${eventDebut} à ${eventEnd}',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      description,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
