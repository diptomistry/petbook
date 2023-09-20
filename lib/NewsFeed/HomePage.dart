import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../add_post/add_photo.dart';
import '../models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  DocumentSnapshot? lastPostDocument;
  ScrollController _scrollController = ScrollController();
  List<Post> posts = [];
  @override
  void initState() {
    super.initState();

    // Attach a scroll listener to the controller
  }

  Future<User?> fetchUserWithID(String userID) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    DocumentSnapshot userSnapshot = await users.doc(userID).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      return User.fromMap(userData);
    } else {
      return null; // User not found
    }
  }

  Future<String?> getUserName(String userID) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    print(userID);
    QuerySnapshot userSnapshot =
        await users.where('userID', isEqualTo: userID).get();
    print(userSnapshot);
    if (userSnapshot.size > 0) {
      // Assuming there's only one document with the specified 'userID'
      QueryDocumentSnapshot userData = userSnapshot.docs[0];
      Map<String, dynamic> userDataMap =
          userData.data() as Map<String, dynamic>;

      // Make sure 'ownerName' is the correct field name in your Firestore document
      return userDataMap['ownerName'] as String?;
    } else {
      return null;
    }
  }

  Future<List<Post>> getPosts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference posts = firestore.collection('posts');

    QuerySnapshot querySnapshot = await posts.get();

    List<Post> postList = [];
    print(querySnapshot.size);
    querySnapshot.docs.forEach((doc) {
      postList.add(Post.fromMap(doc.data() as Map<String, dynamic>));
    });

    return postList;
  }

  Future<List<User?>> fetchUserNames(List<Post> posts) async {
    List<User?> userNames = [];

    for (int i = 0; i < posts.length; i++) {
      User? user = await fetchUserWithID(posts[i].userID);
      userNames.add(user);
    }

    return userNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  'PetBook',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPhotoPage()));
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: FutureBuilder<List<Post>>(
                future: getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(
                        child: Text('Error fetching posts ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No posts found'));
                  } else {
                    List<Post> posts = snapshot.data!;

                    return FutureBuilder(
                        future: fetchUserNames(posts),
                        builder: (context, userNamesSnapshot) {
                          if (userNamesSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                Post post = posts[index];
                                User? _user = userNamesSnapshot.data?[index];
                                return Card(
                                  elevation: 2,
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(20),
                                  // ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          child:
                                              Icon(Icons.manage_search_sharp),
                                        ),
                                        title: Text(
                                          _user?.ownerName ?? 'Unknown',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        subtitle: Text(
                                            "At ${DateFormat('h.mm a d MMMM').format(post.time)}"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18.0, bottom: 5),
                                        child: Text(
                                          post.text ?? 'Unknown',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      Image.network(
                                        post.image ??
                                            'https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg',
                                        fit: BoxFit.cover,
                                        height: 400,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.favorite_border),
                                            SizedBox(width: 10),
                                            Icon(Icons.comment_bank_outlined),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
