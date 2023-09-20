import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'api/profile_apis.dart';
import 'fromRasel.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isPasswordVisible1 = false;
  XFile? image;
  bool imageLoaded = false;

  void _selectAndUploadImage() async {
    ImagePicker imagePicker = new ImagePicker();
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getToolBar(() {
        Get.back();
      },
          title: getCustomFont('Edit Profile', 16, Colors.white, 1,
              fontWeight: FontWeight.w600)),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        screenHeight * 0.1,
                      ),
                      child: imageLoaded
                          ? Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?w=1380&t=st=1693564186~exp=1693564786~hmac=34badb23f9ce7734364a431e350be4ddba450762fc9d703bf10b4dc3d9f0e96b',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: screenHeight * 0.035,
                      height: screenHeight * 0.035,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          screenHeight * 0.035,
                        ),
                        color: ThemeData.light().primaryColor,
                      ),
                      child: InkWell(
                        onTap: _selectAndUploadImage,
                        child: Icon(
                          LineAwesomeIcons.camera,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,

                      onSaved: (value) {
                        print(value);
                      }, // Set the initial text here
                      decoration: InputDecoration(
                        labelText:
                            'Full Name', // Use labelText instead of label
                        prefixIcon: Icon(LineAwesomeIcons.user),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),

                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email', // Use labelText instead of label
                        prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),

                    TextFormField(
                      controller: phoneController,
                      // Set the initial text here
                      decoration: InputDecoration(
                        labelText: 'PhoneNo', // Use labelText instead of label
                        prefixIcon: Icon(LineAwesomeIcons.phone),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),

                    TextFormField(
                      controller: oldPasswordController,
                      // Set the initial text here
                      obscureText: !isPasswordVisible1,

                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText:
                            'Old Password', // Use labelText instead of label
                        prefixIcon: Icon(Icons.fingerprint),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible1
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            // Toggle password visibility when the icon button is pressed
                            setState(() {
                              isPasswordVisible1 = !isPasswordVisible1;
                            });
                          },
                        ),
                      ),
                    ),

                    TextFormField(
                      controller: newPasswordController,
                      // Set the initial text here
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText:
                            'New Password', // Use labelText instead of label
                        prefixIcon: Icon(Icons.fingerprint),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            // Toggle password visibility when the icon button is pressed
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = nameController.text;
                          final email = emailController.text;
                          final phone = phoneController.text;
                          final oldPassword = oldPasswordController.text;
                          final newPassword = newPasswordController.text;
                          try {
                            var user = FirebaseAuth.instance.currentUser;
                            await user?.updateDisplayName(name);

                            await user?.updateEmail(email);
                            await user?.updatePassword(newPassword);
                            if (image != null) {
                              final storageRef = FirebaseStorage.instance
                                  .ref('photos')
                                  .child(user?.uid ?? '');
                              await storageRef.putFile(File(image!.path));
                              final downloadURL =
                                  await storageRef.getDownloadURL();
                              print(downloadURL);
                              // Update user's photo URL with the download URL
                              await user?.updatePhotoURL(downloadURL);
                            }

                            // await user?.updatePhoneNumber(PhoneAuthCredential().);

                            // Call the updateUserWithImage function with the form data and selected image

                            final snackBar = SnackBar(
                              content: getCustomFont(
                                  "User profile updated successfully",
                                  14.7,
                                  Colors.white,
                                  1,
                                  fontWeight: FontWeight.w600),
                              backgroundColor: ThemeData.light().primaryColor,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } catch (e) {
                            print(e);
                            final snackBar = SnackBar(
                              content: getCustomFont(
                                  "Failed : $e", 14.7, Colors.white, 1,
                                  fontWeight: FontWeight.w600),
                              backgroundColor: ThemeData.light().errorColor,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide.none,
                          shape: StadiumBorder(),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    // -- Created Date and Delete Button
                  ],
                ),
              ),
              // ... (previous code)
            ],
          ),
        ),
      ),
    );
  }
}
