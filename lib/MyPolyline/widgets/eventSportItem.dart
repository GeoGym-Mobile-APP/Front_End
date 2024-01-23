import 'package:flutter/material.dart';
import 'package:map_events_project/MyPolyline/screens/DetailsSalleSport.dart';

import '../model/eventSport.dart';
import '../model/salleSport.dart';
import '../screens/detailsEvent.dart';

class EventItemSport extends StatelessWidget {
  final EventModel event;

  const EventItemSport({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          // Column with two Text widgets
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  event.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          // Circle IconButton on the right
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(
                  10.0), // Add padding to increase the touch area
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Ink(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: IconButton(
                  onPressed: () {
                    
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EventDetails(event: event),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.next_plan_outlined,
                    color: Colors.blue,
                    size: 40.0,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
