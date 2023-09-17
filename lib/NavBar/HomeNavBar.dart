import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petbook/NewsFeed/HomePage.dart';
import 'package:petbook/add_post/add_photo.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({super.key});

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  int nav_Index = 0;
  var pages = [HomePage(), HomePage(), HomePage(), HomePage(), HomePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[nav_Index],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.orangeAccent,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.pets, size: 30),
          Icon(Icons.message, size: 30),
          Icon(Icons.person_pin, size: 30),
        ],
        onTap: (index) {
          setState(() {
            nav_Index = index;
            print(index);
          });
          //Handle button tap
        },
        height: 50,
      ),
    );
  }
}
