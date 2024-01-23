
import 'package:flutter/material.dart';

class TarifCard extends StatelessWidget {
  final String label;
  final double value;

  TarifCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            '$value DH',
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.green
            ),
          ),
        ],
      ),
    );
  }
}
