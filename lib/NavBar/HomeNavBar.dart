import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petbook/NewsFeed/HomePage.dart';
import 'package:petbook/add_post/add_photo.dart';
import 'package:petbook/apiCatsFact/cats_fact_api.dart';
import 'package:petbook/feature/auth/pages/login_page.dart';
import 'package:petbook/feature/contact/pages/contact_page.dart';
import 'package:petbook/feature/home/pages/home_page.dart';
import 'package:petbook/feature/welcome/pages/welcome_page.dart';
import 'package:petbook/message/userlist.dart';
import 'package:petbook/profile/profile_screen.dart';

import '../feature/home/pages/chat_home_page.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({super.key, required this.nav_Index});
  final int nav_Index;

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  int nav_Index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      nav_Index = widget.nav_Index;
    });
  }

  var pages = [
    HomePage(),
    HomePage(),
    CatsFact(),
    UserList(
      tips: "2",
    ),
    ProfileScreen()
  ];
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
