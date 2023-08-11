import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/homepage.dart';
import 'auth/login.dart';
import 'auth/forgetPass.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PetbookApp());
}

class PetbookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petbook',
      theme: ThemeData(
        primaryColor: Color(0xFF90CAF9),
        hintColor: Color(0xFF808080),
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
      home: HomePage(),
      routes: {
        'homepage': (context) => HomePage(),
        'login': (context) => MyLogin(),
        'forgetpass':(context)=>ResetPassword()
      },
    );
  }
}
