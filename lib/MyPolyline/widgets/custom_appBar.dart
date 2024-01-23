import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        color: Colors.greenAccent, // Customize the background color
      ),
      child: AppBar(
        title: Text(title),
        centerTitle: true,
        elevation: 0.0, // Remove the shadow under the AppBar
        backgroundColor: Colors.transparent, // Make the AppBar background transparent
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
