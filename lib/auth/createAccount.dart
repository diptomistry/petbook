import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petbook/NavBar/HomeNavBar.dart';

class createAcc extends StatefulWidget {
  @override
  _createAccState createState() => _createAccState();
}

class _createAccState extends State<createAcc> {

  String verificationCode = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _petNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _petGenderController = TextEditingController();
  TextEditingController _ownersFbController = TextEditingController();
  TextEditingController _petAgeController = TextEditingController();
  TextEditingController _petWeightController = TextEditingController();
  TextEditingController _ownerNameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _speciesController=TextEditingController();

  @override
  void dispose() {
    _petNameController.dispose();
    _emailController.dispose();
    _petGenderController.dispose();
    _ownersFbController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _petAgeController.dispose();
    _petWeightController.dispose();
    _ownerNameController.dispose();
    _speciesController.dispose();
    super.dispose();
  }

  var email, password;
  late bool registrationFailed;
  Timer? timer;
  bool isEmailverified=false;

  // Function to store user data in Firestore

  @override
  void initState(){
    super.initState();


    User? user = FirebaseAuth.instance.currentUser;


    if (user == null)
      isEmailverified=false;
    else
      isEmailverified=FirebaseAuth.instance.currentUser!.emailVerified;
    print(isEmailverified);

    if (user != null) {
      // There is a signed-in user
      print('User ID: ${user.uid}');
      print('User Email: ${user.email}');
      // You can access other user properties using 'user'
    } else {
      // No user is signed in
      print('No user is signed in.');
    }
    if(!isEmailverified) {
      timer = Timer.periodic(
        Duration(seconds: 3),
            (_) => checkEmail() ,
      );
    }


  }
  Future checkEmail() async {

    //timer?.cancel();
    print(3);

    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailverified=FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailverified) {
      print("lsdjfl");
      timer?.cancel();
      storeNow();


      //storeNow();


      //Navigator.pushNamed(context, 'profile');
    }

  }
  Future<void> storeNow() async {
    print("hello: $isEmailverified");

    final user = FirebaseAuth.instance.currentUser;

    // Get the FCM token
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.doc(user?.uid).set({
      'petName': _petNameController.text,
      'petGender': _petGenderController.text,
      'petAge': _petAgeController.text,
      'petWeight': _petWeightController.text,
      'ownerName': _ownerNameController.text,
      'email': _emailController.text,
      'ownersFb': _ownersFbController.text,
      'uid': user?.uid,
      'imageLink':
      'https://cdn.wallpapersafari.com/51/50/mPlCtx.jpg',
      'imageLink2':
      'https://media.istockphoto.com/id/1390616702/vector/senior-man-avatar-smiling-elderly-man-with-beard-with-gray-hair-3d-vector-people-character.jpg?s=612x612&w=0&k=20&c=CwU892ELqQlY65Xrnmo2N-pb9AE4xEXcp5gAJ6WpKJg=',
      'location': 'N/A',
      'forAdoption': 'no',
      'loveCount': 0,
      'species': _speciesController.text,
      'fcmToken': fcmToken, // Add FCM token field
      'groupId': [], // Initialize an empty array for groupId
      // Add more fields as needed
    });

    // Navigate to the home page or other destination
  }



  Future<void> registration() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final User? user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null && !registrationFailed) {
        // Store user data in Firestore


        // Send email verification
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email verification link sent to $email. Please check your email.'),
            backgroundColor: Colors.yellow,
          ),
        );



        //FirebaseAuth.instance.currentUser?.emailVerified;

        // Navigate to email verification page
      }
    } catch (e) {
      print('Registration failed: $e');
      // registrationFailed=true;
      String errorMessage = extractErrorMessage(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  String extractErrorMessage(String fullErrorMessage) {
    int startIndex = fullErrorMessage.indexOf(']') + 1;
    return fullErrorMessage.substring(startIndex).trim();
  }

  bool validateEmail(String email) {
    final RegExp emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$', caseSensitive: false);
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /*
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/register.png'),
          fit: BoxFit.cover,
        ),
      ),
       */

      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            'Petbook',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Theme.of(context).hintColor,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, 'login');
            },
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                  left: 35,
                  right: 35,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          roundedTextField(
                            controller: _petNameController,
                            hintText: 'Pet Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your pet\'s name';
                              }
                              return null;
                            },
                          ),
                          roundedTextField(
                            controller: _speciesController,
                            hintText: 'Species',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your pet\'s Species(like cat,dog or others)';
                              }
                              return null;
                            },
                          ),
                          roundedTextField(
                            controller: _petGenderController,
                            hintText: 'Pet Gender',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your pet\'s Gender';
                              }
                              return null;
                            },
                          ),
                          roundedTextField(
                            controller: _petAgeController,
                            hintText: 'Pet Age',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your pet\'s Age';
                              }
                              return null;
                            },
                          ),
                          roundedTextField(
                            controller: _petWeightController,
                            hintText: 'Pet Weight',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your pet\'s Age';
                              }
                              return null;
                            },
                          ),
                          roundedTextField(
                            controller: _ownerNameController,
                            hintText: 'Owner Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the pet owner\'s name';
                              }
                              return null;
                            },
                          ),
                          roundedTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the pet owner\'s email';
                              }
                              if (!validateEmail(value)) {
                                return 'Invalid email format';
                              }
                              email = value;
                              return null;
                            },
                          ),

                          roundedTextField(
                            controller: _ownersFbController,
                            hintText: 'Owners Facebook(Optional)',
                          ),
                          roundedTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a password';
                              }
                              // You can add password validation logic here if needed
                              password = value;
                              return null;
                            },
                          ),
                          roundedTextField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm Password',
                            obscureText: true,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                     // String email = _emailController.text;
                                     // String password = _passwordController.text;

                                      // Call the registration method with email and password
                                    //  registration(email, password);
                                      registration();
                                      // Perform registration logic
                                      if (password.length >= 6)
                                        registrationFailed = false;
                                      else
                                        registrationFailed = true;
                                    }
                                  },
                                  child: Text('Register',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Theme.of(context).hintColor,
                                    // Customize the button color
                                    //foregroundColor: Colors.white,
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

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget roundedTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    FormFieldValidator<String>? validator,
  }) {
    return Container(

      margin: EdgeInsets.only(bottom: 13.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
                color: Colors
                    .blueGrey), // Use a fallback color if bodyLargeColor is null
          ),
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            //borderSide: BorderSide.none,
          ),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          errorText: controller.text.isNotEmpty && validator != null
              ? validator(controller.text)
              : null,
        ),
        validator: validator,
      ),
    );
  }
}

