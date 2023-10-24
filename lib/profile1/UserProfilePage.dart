import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petbook/profile1/utils.dart';
import 'package:petbook/profile1/add_data.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Uint8List? _image;
  late User _user;
  late DocumentSnapshot _userData;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

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

  void _editProfile() {
    // Add code here to navigate to an editing screen and pass _userData for editing
    // After editing, update the Firebase data and fetch updated data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).hintColor,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            /*
            Stack(
              children: [
                _image != null
                    ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 328,
                    height: 210,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: MemoryImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                    : Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 328,
                    height: 210,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://cdn.dribbble.com/users/1044993/screenshots/4092551/australian-shepherd_dribbble.png?resize=400x0'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                ),
              ],
            ),
            */
            Stack(
              children: [
                _image != null
                    ? Container(
                  width: 328, // Set the desired width
                  height: 216, // Set the desired height
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      image: MemoryImage(_image!),
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                  ),
                )
                    : Container(
                  width: 328, // Set the desired width
                  height: 216, // Set the desired height
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://cdn.dribbble.com/users/1044993/screenshots/4092551/australian-shepherd_dribbble.png?resize=400x0'),
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),

            Center(
              child: Text(
                '${_userData['petName']}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn(
                  label: 'Gender',
                  value: _userData['petGender'], // Replace with the actual gender
                  color: Colors.blue, // Choose your desired color
                ),
                _buildInfoColumn(
                  label: 'Age',
                  value: _userData['petAge'], // Replace with the actual age
                  color: Colors.green, // Choose your desired color
                ),
                _buildInfoColumn(
                  label: 'Weight',
                  value: _userData['petWeight'], // Replace with the actual weight
                  color: Colors.orange, // Choose your desired color
                ),
              ],
            ),
            SizedBox(height: 46),
            Row(
              children: [
                _image != null
                    ? CircleAvatar(
                  radius: 44,
                  backgroundImage: MemoryImage(_image!),
                )
                    : const CircleAvatar(
                  radius: 44,
                  backgroundImage: NetworkImage(
                      'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?w=1380&t=st=1693564186~exp=1693564786~hmac=34badb23f9ce7734364a431e350be4ddba450762fc9d703bf10b4dc3d9f0e96b'),
                ),
                SizedBox(width: 16), // Add some spacing between the CircleAvatar and the Column
                Column(
                  children: [
                    Text(
                      'Owner Name: ${_userData['ownerName']}',
                    ),
                    Text(
                      'Email: ${_userData['email']}',
                    ),
                    Text(
                      'Owners Facebook: ${_userData['ownersFb']}',
                    ),
                  ],
                ),
              ],
            ),




          ],
        ),
      ),
    );
  }
}
Widget _buildInfoColumn({required String label, required String value, required Color color}) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10), // Adjust the border radius
    ),
    padding: EdgeInsets.all(16), // Increase padding for larger size
    height: 100, // Increase height for a larger box
    child: Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white, // Text color
          ),
        ),
      ],
    ),
  );
}


