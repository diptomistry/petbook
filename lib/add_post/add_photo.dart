import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petbook/add_post/add_post.dart';
import 'package:petbook/waiting_page.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({Key? key}) : super(key: key);

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  List<CameraDescription> cameras = [];
  late CameraController controller;
  bool _isCameraReady = false;
  late XFile? _imageFile;
  bool picPost = false;
  static ResolutionPreset resolutionPreset = ResolutionPreset.high;
//  ImagePicker picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      controller = CameraController(cameras[0], resolutionPreset);
      // Initialize the camera (usually use cameras[0] for the back camera)
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isCameraReady = true;
        });
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _takePhoto() async {
    if (!_isCameraReady) return;
    try {
      final XFile file = await controller.takePicture();
      setState(() {
        _imageFile = file;
      });
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  void _savePhoto() async {
    if (_imageFile == null) {
      print("no image");
      // Check if an image has been taken
    }

    final firebaseStorage = FirebaseStorage.instance;
    final storageReference = firebaseStorage
        .ref()
        .child('photos'); // Set your desired Firebase Storage path
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference posts = firestore.collection('posts');
    print(_imageFile?.path);
    final uploadTask = await storageReference.putFile(File(_imageFile!.path));
    User? user = FirebaseAuth.instance.currentUser;
    final imageUrl = await uploadTask.ref.getDownloadURL();
    //print(imageUrl);
    return posts.add({
      'image': imageUrl, // John Doe
      'userID': user?.uid, // Stokes and Sons
      'text': 'asdfadfasdf',
      'time': 'asdf' // 42
    }).then((value) {
      setState(() {
        picPost = true;
      });
      print(" image posted");
    }).catchError((error) => print("Failed to add user: $error"));
    // if (uploadTask.state == TaskState.success) {
    //
    //   // Save the image URL to Firestore
    //   await FirebaseFirestore.instance.collection('images').add({
    //     'url': imageUrl,
    //     'userID': user?.uid
    //
    //     // You can add more data like timestamps, user IDs, etc. here
    //   });

    //     // Optionally, you can show a success message or navigate to another screen.
    //   } else {
    //     // Handle the upload failure
    //   }
    // } catch (e) {
    //   print('Error uploading photo to Firestore: $e');
    // }
  }

  void _toggleCameraDirection() {
    // Toggle between front and back cameras.
    final CameraLensDirection newDirection =
        controller.description.lensDirection == CameraLensDirection.front
            ? CameraLensDirection.back
            : CameraLensDirection.front;
    for (final camera in cameras) {
      if (camera.lensDirection == newDirection) {
        controller = CameraController(camera, resolutionPreset);
        controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Update the camera direction.
          });
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 49,
          ),
          _isCameraReady
              ? Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CameraPreview(
                        controller,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    _takePhoto();
                                  },
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.orangeAccent,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                GestureDetector(
                                  onTap: _toggleCameraDirection,
                                  child: CircleAvatar(
                                    child: Icon(Icons.rotate_90_degrees_ccw),
                                    radius: 25,
                                    backgroundColor: Colors.orangeAccent,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  var img = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _imageFile = img;
                  });
                },
                child: Container(
                  width: 150,
                  child: Center(
                      child: Text(
                    'Choose from Galary',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black),
                  )),
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.orangeAccent),
                ),
              ),
              InkWell(
                onTap: () {
                  _savePhoto();
                  picPost
                      ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddPost()))
                      : null;
                },
                child: Container(
                  width: 150,
                  child: Center(
                      child: Text(
                    'Upload',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black),
                  )),
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.orangeAccent),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  final ImagePicker picker = ImagePicker();
}
