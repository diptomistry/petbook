/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/svg.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController _emailController = TextEditingController();
  bool _rememberPassword = false;
  bool _passwordVisible = false;
  var email, password;
  String errorMessage = '';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  login() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        Navigator.pushNamed(context, 'welcome');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Invalid email or password';
      });
      print('Login failed: $e');
    }
  }
  Future<void> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

        final User? user = userCredential.user;

        if (user != null) {
          Navigator.pushNamed(context, 'welcome');
        }
      }
    } catch (e) {
      print('Google Sign-In failed: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(//to set bg image
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/loginBg.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(//to have body
        backgroundColor: Colors.transparent,//otherwise bg will be white by default
        body: Stack(//Stack and Column are both widget classes that provide different ways to arrange and layout child widgets.
          children: [
            //Container(),//we wanna set text but it will be in the top by default,so we
            //need padding ,so we need container to have the feature

            SingleChildScrollView(//when typing,there is a chance that textfield get behind the keyboard ,so we need
              //to scroll up the text field according to need
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4),
                //MediaQuery.of(context).size.height:users phn screen size
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),

                              ),
                              prefixIcon: Icon(Icons.email),
                            ),
                            onChanged: (value){
                              email=value;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(),
                            obscureText: !_passwordVisible,//pass will not show while typing
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Password",

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                              ),
                            ),
                            onChanged: (value){
                              password=value;
                            },
                          ),
                          SizedBox(height: 8),
                          Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 20),

                          Row(
                            children: [
                              Checkbox(
                                value: _rememberPassword,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberPassword = value!;
                                  });
                                },
                              ),
                              Text('Remember Password'),
                              Expanded(
                                //The Expanded widget ensures that any remaining available space in the row is allocated to the Row widget that contains the "Forgot Password" text.
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //The Spacer widget is inserted before the "Forgot Password" text
                                    Spacer(),//to push it to the right side of the row
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, 'forgetpass');
                                      },
                                      child: Text(
                                        'Forgot Password',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 14.0), // Adjust the padding value as needed
                                child: Text(
                                  'Do not have an account?',
                                ),
                              ),
                              Expanded(
                                //The Expanded widget ensures that any remaining available space in the row is allocated to the Row widget that contains the "Forgot Password" text.
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //The Spacer widget is inserted before the "Forgot Password" text
                                    Spacer(),//to push it to the right side of the row
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, 'register');
                                      },
                                      child: Text(
                                        'Create Account',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(//button in the whole row
                                child: ElevatedButton(
                                  onPressed:login,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:Color(0xFFFF7043), // Customize the button color
                                    foregroundColor: Colors.white, // Customize the text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.black, width: 0.3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/or.png', // Path to the asset
                                width: 150, // Adjust the width as needed
                                height: 50, // Adjust the height as needed
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: googleSignIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.black, width: 1.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/google_logo.svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Sign-in with Google',
                                          style: TextStyle(fontSize: 16, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )



                        ],
                      ),
                    )
                  ],
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyLogin extends StatefulWidget {
  final ThemeMode themeMode; // Pass themeMode to MyLogin

  MyLogin({Key? key, required this.themeMode}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController _emailController = TextEditingController();
  bool _rememberPassword = false;
  bool _passwordVisible = false;
  var email, password;
  String errorMessage = '';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  login() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        Navigator.pushNamed(context, 'welcome');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Invalid email or password';
      });
      print('Login failed: $e');
    }
  }

  Future<void> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        final User? user = userCredential.user;

        if (user != null) {
          Navigator.pushNamed(context, 'welcome');
        }
      }
    } catch (e) {
      print('Google Sign-In failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            widget.themeMode == ThemeMode.dark
                ? 'assets/loginBg_dark.png' // Dark theme background image
                : 'assets/loginBg.png', // Light theme background image
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.58,
                ),
                //MediaQuery.of(context).size.height:users phn screen size
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          Container(
                            width: 300,
                            height: 45,
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),

                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.blueGrey), // Use a fallback color if bodyLargeColor is null
                                ),

                                prefixIcon: Icon(Icons.email, color: Theme.of(context).hintColor),
                              ),
                              onChanged: (value) {
                                email = value;
                              },
                            ),
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width:300,
                            height:45,
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              obscureText: !_passwordVisible,
                              //pass will not show while typing
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(Icons.lock, color: Theme.of(context).hintColor),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.blueGrey), // Use a fallback color if bodyLargeColor is null
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                      color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                password = value;
                              },
                            ),
                          ),
                          //SizedBox(height: 3),
                          Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                          //SizedBox(height: 10),
                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _rememberPassword,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberPassword = value!;
                                    });
                                  },
                                  activeColor: Theme.of(context).hintColor,
                                  checkColor: Colors.white,
                                ),
                                Text('Remember Password'),
                                Expanded(
                                  //The Expanded widget ensures that any remaining available space in the row is allocated to the Row widget that contains the "Forgot Password" text.
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      //The Spacer widget is inserted before the "Forgot Password" text
                                      Spacer(),
                                      //to push it to the right side of the row
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, 'forgetpass');
                                        },
                                        child: Text(
                                          'Forgot Password',
                                          style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            fontSize: 12,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 300,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  //button in the whole row
                                  child: ElevatedButton(
                                    onPressed: login,
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Theme.of(context).hintColor,
                                      // Customize the button color
                                     // foregroundColor: Colors.red,
                                      // Customize the text color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color: Colors.blueGrey, width: 0.6),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/or.png', // Path to the asset
                                width: 150, // Adjust the width as needed
                                height: 30, // Adjust the height as needed
                              ),
                            ],
                          ),
                          Container(
                            width: 300,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: googleSignIn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color: Colors.blueGrey, width: 0.6),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/google_logo.svg',
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          const Text(
                                            'Sign-in with Google',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 14.0),
                                // Adjust the padding value as needed
                                child: Text(
                                  'Do not have an account?',
                                ),
                              ),
                              Expanded(
                                //The Expanded widget ensures that any remaining available space in the row is allocated to the Row widget that contains the "Forgot Password" text.
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //The Spacer widget is inserted before the "Forgot Password" text
                                    Spacer(),
                                    //to push it to the right side of the row
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, 'register');
                                      },
                                      child: Text(
                                        'Create Account',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 13,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
