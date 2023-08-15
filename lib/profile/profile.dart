import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _petNameController;
  late TextEditingController _petGenderController;
  late TextEditingController _ownerNameController;
  String _imageUrl = ''; // Store the URL of the uploaded pet picture

  @override
  void initState() {
    super.initState();
    _petNameController = TextEditingController();
    _petGenderController = TextEditingController();
    _ownerNameController = TextEditingController();
    _loadUserData(); // Load user data from Firestore
  }

  @override
  void dispose() {
    _petNameController.dispose();
    _petGenderController.dispose();
    _ownerNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    // Load user's data from Firestore
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('user_id_here') // Replace with the user's UID
        .get();

    setState(() {
      _petNameController.text = userSnapshot['petName'] ?? '';
      _petGenderController.text = userSnapshot['petGender'] ?? '';
      _ownerNameController.text = userSnapshot['ownerName'] ?? '';
      _imageUrl = userSnapshot['petPictureUrl'] ?? '';
    });
  }

  Future<void> _updateUserData() async {
    // Update user's data in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc('user_id_here') // Replace with the user's UID
        .update({
      'petName': _petNameController.text,
      'petGender': _petGenderController.text,
      'ownerName': _ownerNameController.text,
      'petPictureUrl': _imageUrl,
    });
  }

  // TODO: Implement pet picture upload using Firebase Storage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              await _updateUserData();
              // TODO: Show a snackbar or navigate back after updating data
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _petNameController,
              decoration: InputDecoration(labelText: 'Pet Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _petGenderController,
              decoration: InputDecoration(labelText: 'Pet Gender'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _ownerNameController,
              decoration: InputDecoration(labelText: 'Owner Name'),
            ),
            SizedBox(height: 16),
            // TODO: Add pet picture upload widget here
            if (_imageUrl.isNotEmpty)
              Image.network(
                _imageUrl,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}

