import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_events_project/MyPolyline/screens/calendar_events.dart';
import 'package:map_events_project/MyPolyline/screens/home_map.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
  
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/images/homegym.png',
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.only(left: 60.0, right: 30),
              alignment: Alignment.centerRight,
              child: const Wrap(
                children: [
                  Text(
                    'Welcome to your Gym, ici c\'est votre endroit où vous allez apprendre beaucoup!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: SizedBox(
                    width: 150.0, // Set the desired width
                    height: 60.0, // Set the desired height
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => MapScreen()),
                        );
                      },
                      label:  Row(
                        children: [
                          const Text('Next',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          const SizedBox(
                              width:
                                  30.0), // Adjust the spacing between text and icon
                          Container(
                            width: 40.0,
                            height: 35.0,
                            decoration:const  BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green, // Adjust the color as needed
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 30.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
