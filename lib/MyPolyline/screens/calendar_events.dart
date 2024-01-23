import 'package:flutter/material.dart';

import '../Api/api_eventSport.dart';
import '../model/eventSport.dart';
import '../widgets/eventSportItem.dart';

class CalendarEvents extends StatefulWidget {
  const CalendarEvents({Key? key}) : super(key: key);

  @override
  State<CalendarEvents> createState() => CalendarEventsState();
}

class CalendarEventsState extends State<CalendarEvents> {
  // Initialize selectedDayIndex with the index of the current day
  late int selectedDayIndex;

  // List of day names starting from Sunday
  final List<String> dayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  late EventApi eventApi;
  late List<EventModel> events;

  @override
  void initState() {
    super.initState();
    selectedDayIndex = DateTime.now().weekday % 7;

    eventApi = EventApi(baseUrl: 'https://afe5-41-250-28-38.ngrok-free.app');
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      List<EventModel> allEvents = await eventApi.getAllEvents();

      
      List<EventModel> selectedDayEvents = allEvents.where((event) {
        print("tests : ^$selectedDayIndex");
        return event.startDate.weekday == selectedDayIndex;
      }).toList();

      setState(() {
        // Utiliser la liste filtrée pour mettre à jour les événements
        events = selectedDayEvents;
      });

      print('Events loaded: ${allEvents.toString()}');
      print('Events filtred: $events');
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              child: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20),
                  child: Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.arrow_back_ios,
                              color: Colors.black, size: 25),
                        ),
                      ),
                    ),
                  ),
                ),
                title: const Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Text(
                    'Calendar Events',
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
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
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 50.0),
            child: Column(
              children: [
                // Horizontal scrollable list of days
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 80.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dayNames.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Set the selected day index
                            setState(() {
                              selectedDayIndex = index;
                             loadEvents();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            padding: EdgeInsets.all(30.0),
                            decoration: BoxDecoration(
                              color: selectedDayIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Center(
                              child: Text(
                                dayNames[index],
                                style: TextStyle(
                                    color: selectedDayIndex == index
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Vertical scrollable list of event items for the selected day
                Expanded(
                  child: FutureBuilder<List<EventModel>>(
                    future: eventApi.getAllEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error loading events: ${snapshot.error}');
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            children: events.map((event) {
                              return EventItemSport(
                                event: event,
                                // Ajoutez d'autres données nécessaires à votre widget personnalisé
                              );
                            }).toList(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
