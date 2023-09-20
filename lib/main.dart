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
import 'package:petbook/feature/auth/pages/login_page.dart';
import 'package:petbook/feature/home/pages/chat_home_page.dart';
import 'package:petbook/feature/home/pages/home_page.dart';
import 'package:petbook/common/routes/routes.dart';
import 'package:petbook/common/theme/dark_theme.dart';
import 'package:petbook/common/theme/light_theme.dart';
import 'package:petbook/feature/auth/controller/auth_controller.dart';
import 'package:petbook/feature/welcome/pages/welcome_page.dart';
import 'package:petbook/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatPet',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      home: ref.watch(userInfoAuthProvider).when(
        data: (user) {
          FlutterNativeSplash.remove();
          //if (user == null) return const WelcomePage();
          return const Homepage();
        },
        error: (error, trace) {
          return const Scaffold(
            body: Center(
              child: Text('Something wrong happened'),
            ),
          );
        },
        loading: () => const SizedBox(),
      ),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petbook/feature/welcome/pages/welcome_page.dart';
import 'package:petbook/firebase_options.dart';
import 'package:petbook/profile/UserProfilePage.dart';
import 'package:petbook/profile/profile.dart';
import 'NavBar/HomeNavBar.dart';
import 'auth/homepage.dart';
import 'auth/login.dart';
import 'auth/forgetPass.dart';
import 'auth/createAccount.dart';

Color CustomColor1 = Color(0xFF00a19d);
Color CustomColor2 = Color(0xFF8aabca);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(
    child:PetbookApp() ,
  ),
  );
}
/*void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
     ProviderScope(
      child: PetbookApp(),
    ),
  );
}*/

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
  void initState() {
    super.initState();
    _themeMode =
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petbook',
      themeMode: _themeMode,
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xFF90CAF9),
        hintColor: Color(0xFF00a19d),
        colorScheme: ColorScheme.light(
          primary: CustomColor1,
          secondary: Colors.white,
          background: Color(0xFFFFF9C4),
        ),
        scaffoldBackgroundColor: Color(0xFFFFF9C4),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF00a19d)),
          bodyMedium: TextStyle(color: Color(0xFFA1887F)),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF3F51B5),
        hintColor: Color(0xFF263F60),
        colorScheme: ColorScheme.light(
          primary: CustomColor2,
          secondary: Colors.black,
          background: Color(0xFF273443),
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.grey),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(setThemeMode: (ThemeMode ) {  },),
      //     HomePage(setThemeMode: _setThemeMode), // Pass _themeMode to MyLogin
      routes: {
        'homepage': (context) => HomePage(setThemeMode: _setThemeMode),
        'login': (context) =>
            MyLogin(themeMode: _themeMode), // Pass _themeMode to MyLogin
        'forgetpass': (context) => ResetPassword(themeMode: _themeMode),
        'register': (context) => createAcc(),
        'profile': (context) => UserProfilePage(),
        'home': (context) => const HomeNavigationBar(),
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
