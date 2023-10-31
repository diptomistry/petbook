import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petbook/NewsFeed/HomePage.dart';
import 'package:petbook/add_post/add_photo.dart';

import 'package:petbook/feature/home/pages/home_page.dart';
import 'package:petbook/feature/welcome/pages/welcome_page.dart';
import 'package:petbook/message/userlist.dart';

import '../feature/home/pages/chat_home_page.dart';
import '../health/health_tips.dart';
import '../profile1/UserProfilePage.dart';
import '../profile1/profileSearch.dart';

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
    ProfileSearchPage(),
    HealthTipsPage(),
    Homepage(),
    UserProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).hintColor,
        ),
      ),
      body: pages[nav_Index],
      bottomNavigationBar: CurvedNavigationBar(
        color: Theme.of(context).hintColor,
        backgroundColor: Colors.transparent,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.search,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.pets,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.message,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person_pin,
            size: 30,
            color: Colors.white,
          ),
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
