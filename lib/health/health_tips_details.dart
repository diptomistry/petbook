import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthTipDetailsPage extends StatefulWidget {
  final String title;
  final String content;
  final String imagePath;
  final String id;

  HealthTipDetailsPage({
    required this.title,
    required this.content,
    required this.imagePath,
    required this.id,
  });

  @override
  _HealthTipDetailsPageState createState() => _HealthTipDetailsPageState();
}

class _HealthTipDetailsPageState extends State<HealthTipDetailsPage> {
  late String title;
  late String content;
  late String imagePath;
  late String id;

  RxBool tap = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool load = false;
  @override
  void initState() {
    super.initState();

    title = widget.title;
    content = widget.content;
    imagePath = widget.imagePath;
    id = widget.id;

    checkIfLiked();
    load = true;
    setState(() {});
  }

  void checkIfLiked() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final tipDocument =
          await _firestore.collection('tips').doc(widget.id).get();

      if (tipDocument.exists) {
        final likes = tipDocument.data()!['likes'];
        final List<String> likesList = List<String>.from(likes.cast<String>());

        if (likesList.contains(userId)) {
          tap.value = true;
        }
      }
    }
  }

  void toggleLike() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final tipDocument =
          await _firestore.collection('tips').doc(widget.id).get();

      if (tipDocument.exists) {
        final likes = tipDocument.data()!['likes'];

        if (likes is List<dynamic>) {
          final List<String> updatedLikes = List<String>.from(likes);

          if (updatedLikes.contains(userId)) {
            // User already liked the tip, so remove the like
            updatedLikes.remove(userId);
          } else {
            // User hasn't liked the tip, so add the like
            updatedLikes.add(userId);
          }

          // Update the likes in Firestore
          await _firestore
              .collection('tips')
              .doc(widget.id)
              .update({'likes': updatedLikes});

          // Update the UI
          setState(() {
            tap.value = !tap.value;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Health Tip Details'),
        // Customize the color
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: MediaQuery.of(context).size.height * 0.5,
            right: 0,
            left: 0,
            child: Container(
              child: Image.network(
                imagePath,
                fit: BoxFit.fill,
              ), // Replace with your image asset
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      30), // Adds a curve to the top-left corner
                  topRight: Radius.circular(30),
                ),
                color: Color(0xFFFFF9C4),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      Obx(() {
                        RxBool up = false.obs;
                        return !up.value
                            ? IconButton(
                                onPressed: () {
                                  // tap.toggle();
                                  toggleLike();
                                  up = true.obs;
                                  // Handle love button tap
                                },
                                icon: Icon(
                                  tap.value
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: tap.value
                                      ? Color(0xFF00a19d)
                                      : Colors.black,
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      }),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    content,
                    style: TextStyle(
                        fontSize: 16, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
