import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserProfilePage.dart'; // Import the UserProfilePage

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;
  late DocumentSnapshot _userData;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    DocumentSnapshot userData =
    await FirebaseFirestore.instance.collection('users').doc(_user.uid).get();
    setState(() {
      _userData = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: _user.emailVerified
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Congratulations! Your email is verified.'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Go to Profile'),
            ),
          ],
        )
            : Text('Please verify your email to access your profile.'),
      ),
    );
  }
}
