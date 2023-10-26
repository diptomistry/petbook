import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  final DocumentSnapshot userData;

  EditProfilePage({required this.userData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _petNameController = TextEditingController();
  TextEditingController _petGenderController = TextEditingController();
  TextEditingController _petAgeController = TextEditingController();
  TextEditingController _petWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _petNameController.text = widget.userData['petName'];
    _petGenderController.text = widget.userData['petGender'];
    _petAgeController.text = widget.userData['petAge'];
    _petWeightController.text = widget.userData['petWeight'];
  }

  void _saveChanges() {
    // Add logic to update the user's profile data in Firebase with the new values
    // You can use _petNameController.text, _petGenderController.text, etc.
    // Then, return to the previous screen (the user's profile)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pet Name:'),
            TextField(
              controller: _petNameController,
            ),
            SizedBox(height: 16),
            Text('Pet Gender:'),
            TextField(
              controller: _petGenderController,
            ),
            SizedBox(height: 16),
            Text('Pet Age:'),
            TextField(
              controller: _petAgeController,
            ),
            SizedBox(height: 16),
            Text('Pet Weight:'),
            TextField(
              controller: _petWeightController,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
