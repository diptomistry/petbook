import 'package:firebase_auth/firebase_auth.dart';
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
                                    backgroundColor: Colors.black54, // Customize the button color
                                    foregroundColor: Colors.white, // Customize the text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '.......... or ..........',
                            style: TextStyle(
                              fontSize: 20.0,

                            ),
                          ),
                          SizedBox(
                            height: 10,
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