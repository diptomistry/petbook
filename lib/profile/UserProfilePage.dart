import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
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
        title: Text('User Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display user profile information here
            Text('Pet Name: ${_userData['petName']}'),
            Text('Pet Gender: ${_userData['petGender']}'),
            Text('Pet Age: ${_userData['petAge']}'),
            Text('Pet Weight: ${_userData['petWeight']}'),
            Text('Owner Name: ${_userData['ownerName']}'),
            Text('Email: ${_userData['email']}'),
            Text('Owners Facebook: ${_userData['ownersFb']}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
