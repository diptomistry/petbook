import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petbook/profile1/utils.dart';
import 'package:petbook/profile1/add_data.dart';
import 'package:url_launcher/url_launcher.dart';

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
            Text(
                ''
            ),

            Center(
              child: Text(
                '${_userData['petName']}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                  color: Color(0xFFDDDDDD), // Choose your desired color
                ),
                _buildInfoColumn(
                  label: 'Age',
                  value: _userData['petAge'], // Replace with the actual age
                  color: Color(0xFFDDDDDD), // Choose your desired color
                ),
                _buildInfoColumn(
                  label: 'Weight',
                  value: _userData['petWeight'], // Replace with the actual weight
                  color:  Color(0xFFDDDDDD), // Choose your desired color
                ),
              ],
            ),
            SizedBox(height: 46),
            Row(
              children: [
                Stack(
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
                    Positioned(
                      top: 0, // Adjust the top position of the button
                      right: 0, // Adjust the right position of the button
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 16), // Add some spacing between the CircleAvatar and the Column
                Container(
                  width: 200, // Set a fixed width for the second column
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align column content to the start
                    children: [
                      Center(
                        child: Text(
                          '${_userData['ownerName']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Text color for the name
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle the email tap action, e.g., open an email compose screen
                          // Replace 'mailto:' with the desired email address
                          launch('mailto:${_userData['email']}');
                        },
                        child: Row(
                          children: [
                            Icon(Icons.email, color: Color(0xFF00a19d)), // Email icon
                            Text('  '), // Add some space between the icon and text
                            Text(' ${_userData['email']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:  Theme.of(context).hintColor, // Text color for the name
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle the Facebook tap action, e.g., open the Facebook app or website
                          // Replace 'https://www.facebook.com/' with the actual Facebook URL
                          launch('https://www.facebook.com/${_userData['ownersFb']}');
                        },
                        child: Row(
                          children: [
                            Icon(Icons.facebook, color: Color(0xFF00a19d)), // Facebook icon
                            Text('  '), // Add some space between the icon and text
                            Text(' ${_userData['ownersFb']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:  Theme.of(context).hintColor, // Text color for the name
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )

              ],
            )





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
    width: 100, // Set a fixed width
    height: 100, // Set a fixed height
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text(
            ''
        ),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:  Color(0xFFA9ACAD), // Text color
          ),
        ),


        Text(
          value,
          style: TextStyle(
            color:  Color(0xFF00a19d), // Text color
          ),
        ),
      ],
    ),
  );
}
