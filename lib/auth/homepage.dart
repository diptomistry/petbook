/*
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 100,
              color: Color(0xFFFF7043),
            ),
            SizedBox(height: 20),
            Text(
              'Discover the World of Paws and Tails!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Explore a universe filled with furry, feathery, and scaly companions.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color:  Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {

                  Navigator.pushNamed(context, 'login');

              },
              style: ElevatedButton.styleFrom(
                backgroundColor:Color(0xFFFF7043),// Theme.of(context).hintColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),

                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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
*/
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Function(ThemeMode) setThemeMode;

  HomePage({required this.setThemeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 100,
              color: Theme.of(context).hintColor,
            ),
            SizedBox(height: 20),
            Text(
              'Discover the World of Paws and Tails!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Explore a universe filled with furry, feathery, and scaly companions.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).hintColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary,
                    // color:Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Added spacing

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setThemeMode(ThemeMode.light); // Set light theme
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.wb_sunny, color: Colors.black),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setThemeMode(ThemeMode.dark); // Set dark theme
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.nightlight_round, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context)
          .colorScheme
          .background, // Set background color based on the theme
    );
  }
}
