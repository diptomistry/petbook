import 'package:flutter/material.dart';
import 'auth/homepage.dart';

void main() {
  runApp(PetbookApp());
}

class PetbookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petbook',
      theme: ThemeData(
        primaryColor: Color(0xFF90CAF9),
        hintColor: Color(0xFFFF7043),
        colorScheme: ColorScheme.light(
          background: Color(0xFFFFF9C4),
        ),
        scaffoldBackgroundColor: Color(0xFFFFF9C4),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF333333)),
          bodyMedium: TextStyle(color: Color(0xFFA1887F)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomePage(),
        // Add more routes here
      },
    );
  }
}
