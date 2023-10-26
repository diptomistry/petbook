
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
  bool _isEditing = false; // Variable to track editing state
  TextEditingController _petNameController = TextEditingController();
   TextEditingController _emailController = TextEditingController();
   TextEditingController _petGenderController = TextEditingController();
   TextEditingController _ownersFbController = TextEditingController();
   TextEditingController _petAgeController = TextEditingController();
   TextEditingController _petWeightController = TextEditingController();
   TextEditingController _ownerNameController = TextEditingController();



  @override
  void dispose() {
    _petNameController.dispose();
  _emailController.dispose();
     _petGenderController.dispose();
     _ownersFbController.dispose();

     _petAgeController.dispose();
     _petWeightController.dispose();
    _ownerNameController.dispose();
    super.dispose();
  }
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
    setState(() {
      _isEditing = true;
    });
    // Add navigation logic to the "Edit Profile" screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => EditProfilePage(userData: _userData)),
    // ).then((value) {
    //   setState(() {
    //     _isEditing = false;
    //   });
    //   _fetchUserData(); // Fetch updated user data after editing
    // });
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isEditing = false;
    });
    String resp = await StoreData().saveData(file: _image!);
    // Add logic to save the profile changes to Firebase
    // You can use _userData to update the Firebase document
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).hintColor,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _editProfile,
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                _image != null && _isEditing
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
                if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 1,
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
              child: _isEditing
                  ? TextFormField(
                controller: _petNameController,
                decoration: InputDecoration(
                  hintText: 'Pet Name',
                ),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
                  : Text(
                _userData['petName'],
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
                if(!_isEditing)
                _buildInfoColumn(
                  label: 'Gender',
                  value:  _userData['petGender'],
                  color: Color(0xFFDDD8AE),

                ),
                if(_isEditing)
                  _buildInfoColumnEdit(
                    label: 'Gender',

                    color: Color(0xFFDDD8AE),
                    controller: _petGenderController,

                 ),
                if(!_isEditing)
                _buildInfoColumn(
                  label: 'Age',
                  value:  _userData['petAge'],
                  color: Color(0xFFDDD8AE),
                ),
                if(_isEditing)
                  _buildInfoColumnEdit(
                    label: 'Age',

                    color: Color(0xFFDDD8AE), controller: _petAgeController,

                  ),
                if(!_isEditing)
                _buildInfoColumn(
                  label: 'Weight',
                  value: _userData['petWeight'],
                  color: Color(0xFFDDD8AE),
                ),
                if(_isEditing)
                  _buildInfoColumnEdit(
                    label: 'Weight',

                    color: Color(0xFFDDD8AE), controller: _petWeightController,

                  ),


              ],
            ),
            //if(_isEditing)




            if(!_isEditing)
            SizedBox(height: 46),
            if (!_isEditing)
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Stack(
                    children: [
                      _image != null&&_isEditing
                          ? CircleAvatar(
                        radius: 44,
                        backgroundImage: MemoryImage(_image!),
                      )
                          : const CircleAvatar(
                        radius: 44,
                        backgroundImage: NetworkImage(
                            'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?w=1380&t=st=1693564186~exp=1693564786~hmac=34badb23f9ce7734364a431e350be4ddba450762fc9d703bf10b4dc3d9f0e96b'),
                      ),
                      if (_isEditing)
                      Positioned(
                        bottom: -10, // Adjust the top position of the button
                        right: -15, // Adjust the right position of the button
                        child: IconButton(
                          onPressed: selectImage,

                          icon: Icon(Icons.add_a_photo,size: 18),

                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_userData['ownerName']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text('Pet Owner'),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launch('mailto:${_userData['email']}');
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                        color: Color(0xFFDDD8AE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(Icons.email, color: Color(0xFF00a19d)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launch('https://www.facebook.com/${_userData['ownersFb']}');
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                        color: Color(0xFFDDD8AE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(Icons.facebook, color: Color(0xFF00a19d)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(_isEditing)
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        _image != null && _isEditing
                            ? CircleAvatar(
                          radius: 44,
                          backgroundImage: MemoryImage(_image!),
                        )
                            : const CircleAvatar(
                          radius: 44,
                          backgroundImage: NetworkImage(
                              'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?w=1380&t=st=1693564186~exp=1693564786~hmac=34badb23f9ce7734364a431e350be4ddba450762fc9d703bf10b4dc3d9f0e96b'),
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: -10, // Adjust the top position of the button
                            right: -15, // Adjust the right position of the button
                            child: IconButton(
                              onPressed: selectImage,
                              icon: Icon(
                                Icons.add_a_photo,
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isEditing)
                              TextFormField(
                                controller: _ownerNameController,
                                decoration: InputDecoration(
                                  hintText: 'Edit Owner Name',
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            else
                              Text(
                                _userData['ownerName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            if (_isEditing)
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Edit Email',
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () {
                                  launch('mailto:${_userData['email']}');
                                },
                                child: Text(
                                  _userData['email'],
                                  style: TextStyle(
                                    color: Color(0xFF00a19d),
                                  ),
                                ),
                              ),
                            if (_isEditing)
                              TextFormField(
                                controller: _ownersFbController,
                                decoration: InputDecoration(
                                  hintText: 'Edit Facebook',
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () {
                                  launch('https://www.facebook.com/${_userData['ownersFb']}');
                                },
                                child: Text(
                                  _userData['ownersFb'],
                                  style: TextStyle(
                                    color: Color(0xFF00a19d),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if(!_isEditing)
            SizedBox(height: 26),
            if(_isEditing)
              SizedBox(height: 16),
            if(!_isEditing)
            Container(
              width: 335,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Define the action for marking the pet for adoption
                      },
                      icon: Icon(Icons.pets),
                      label: Text(
                        'Mark for Adoption',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).hintColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.blueGrey, width: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(_isEditing)
              Container(
                width: 335,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Define the action for marking the pet for adoption
                        },
                        icon: Icon(Icons.pets),
                        label: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).hintColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.blueGrey, width: 0.6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoColumnEdit({
  required String label,
  required TextEditingController? controller,
  required Color color,
}) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    width: 100,
    height: 100,
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF00a19d),
          ),
        ),
        if (controller != null) TextField(
          controller: controller,

          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF00a19d),
          ),
        ),
      ],
    ),
  );
}


Widget _buildInfoColumn({
  required String label,
  required String value,
  required Color color,
}) {
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

            color:  Color(0xFFA9ACAD), // Text color
          ),
        ),



        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:  Color(0xFF00a19d), // Text color
          ),
        ),
      ],
    ),
  );
}



