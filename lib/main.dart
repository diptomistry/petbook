/*
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/homepage.dart';
import 'auth/login.dart';
import 'auth/forgetPass.dart';
import 'auth/createAccount.dart';

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
        hintColor: Color(0xFFA1887F),
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
        'forgetpass':(context)=>ResetPassword(),
        'register':(context)=>createAcc()
      },
    );
  }
}

 */


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/homepage.dart';
import 'auth/login.dart';
import 'auth/forgetPass.dart';
import 'auth/createAccount.dart';

Color CustomColor1 = Color(0xFFFF7043);
Color CustomColor2 = Color(0xFFFEDCBA);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PetbookApp());
}

class PetbookApp extends StatefulWidget {
  @override
  _PetbookAppState createState() => _PetbookAppState();
}

class _PetbookAppState extends State<PetbookApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petbook',
      themeMode: _themeMode,
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xFF90CAF9),
        hintColor: Color(0xFFA1887F),
        colorScheme: ColorScheme.light(
          primary: CustomColor1,
          secondary: Colors.white,

          background: Color(0xFFFFF9C4),
        ),
        scaffoldBackgroundColor: Color(0xFFFFF9C4),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF333333)),
          bodyMedium: TextStyle(color: Color(0xFFA1887F)),
        ),

      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF3F51B5),
        hintColor: Color(0xFF473C38),
        colorScheme: ColorScheme.light(
          primary: CustomColor2,
          secondary:Colors.black ,
          background: Color(0xFF212121),
        ),
        scaffoldBackgroundColor: Color(0xFFFFF9C4),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.grey),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(setThemeMode: _setThemeMode),// Pass _themeMode to MyLogin
      routes: {
        'homepage': (context) => HomePage(setThemeMode: _setThemeMode),
        'login': (context) => MyLogin(themeMode: _themeMode), // Pass _themeMode to MyLogin
        'forgetpass': (context) => ResetPassword(),
        'register':(context)=>createAcc()
      },
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: child,
        );
      },
    );
  }
}





