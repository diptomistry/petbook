import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:petbook/NavBar/HomeNavBar.dart';
import 'package:petbook/NewsFeed/HomePage.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  late String imageUrl;
  TextEditingController postEdit = TextEditingController();
  @override
  initState() {
    super.initState();
    setState(() {
      imageUrl = widget.imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        elevation: 0,
        actions: [
          InkWell(
            onTap: () async {
              FirebaseFirestore firestore = FirebaseFirestore.instance;
              CollectionReference posts = firestore.collection('posts');
              User? user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                String uid = user.uid;

                await posts.add({
                  'image': imageUrl,
                  'userID': uid, // Set the UID explicitly
                  'text': postEdit.text,
                  'time': DateTime.now(),
                }).then((_) {
                  Get.to(HomeNavigationBar(nav_Index: 0));
                  print(" posted");
                }).catchError((error) {
                  print("Failed to add post: $error");
                });
                CollectionReference users =
                    FirebaseFirestore.instance.collection('users');

                // Update the 'userID' field in the 'users' collection
                // await users
                //     .doc(uid)
                //     .set({'userID': uid}, SetOptions(merge: true)).then((_) {
                //   print("Updated 'userID' field in 'users' collection.");
                // }).catchError((error) {
                //   print(
                //       "Failed to update 'userID' field in 'users' collection: $error");
                // });
              } else {
                print(
                    "User is not signed in."); // Handle the case where the user is not signed in
              }

              // Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text('Post'),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 18),
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  imageUrl ??
                      'https://img.freepik.com/free-photo/isolated-happy-smiling-dog-white-background-portrait-4_1562-693.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 18),
            padding: EdgeInsets.only(left: 18),
            height: 100,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1))]),
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: postEdit,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Write ...............'),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
