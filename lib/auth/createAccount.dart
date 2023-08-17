import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    super.dispose();
  }

  var email, password;
  late bool registrationFailed;

  // Function to store user data in Firestore
  Future<void> storeUserData(User user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.doc(user.uid).set({
      'petName': _petNameController.text,
      'petGender': _petGenderController.text,
      'petAge': _petAgeController.text,
      'petWeight': _petWeightController.text,
      'ownerName': _ownerNameController.text,
      'email': _emailController.text,
      'ownersFb': _ownersFbController.text,
      // Add more fields as needed
    });
  }

  Future<void> registration() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final User? user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null&&!registrationFailed) {
        // Store user data in Firestore
        await storeUserData(user);

        // Send email verification
        await user.sendEmailVerification();
        var emailLink;
        if (firebaseAuth.isSignInWithEmailLink(emailLink)) {
          // The client SDK will parse the code from the link for you.
          firebaseAuth.signInWithEmailLink(email: email, emailLink: emailLink).then((value) {
            // You can access the new user via value.user
            // Additional user info profile *not* available via:
            // value.additionalUserInfo.profile == null
            // You can check if the user is new or existing:
            // value.additionalUserInfo.isNewUser;
            var userEmail = value.user;
            print('Successfully signed in with email link!');
          }).catchError((onError) {
            print('Error signing in with email link $onError');
          });
        }

        // Navigate to email verification page
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => EmailVerificationPage(isEmailVerified: false),
          ),
        );
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
                          //SizedBox(height: 2.0),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      registration();
                                      // Perform registration logic
                                      if (password.length >= 6)
                                        registrationFailed=false;
                                      else
                                        registrationFailed=true;
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
      margin: EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blueGrey), // Use a fallback color if bodyLargeColor is null
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
class EmailVerificationPage extends StatelessWidget {
  final bool isEmailVerified;

  EmailVerificationPage({required this.isEmailVerified});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            _isDarkTheme(context)
                ? 'assets/resetBgDark.png'
                : 'assets/resetBg.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/emailReset.png',
                    width: 250,
                    height: 250,
                  ),
                ],
              ),
              Text(
                'Email Verification',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'A verification email has been sent to your email address. Please check your inbox and follow the instructions to verify your email.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: isEmailVerified
                    ? () {
                  Navigator.pushNamed(context, 'profile');
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Go to Profile',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),


              SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }

  bool _isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}