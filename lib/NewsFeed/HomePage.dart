import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../add_post/add_photo.dart';
import '../models/post.dart';

class PostsController extends GetxController {
  RxBool isLoading = false.obs;
  final RxList<Post> posts = <Post>[].obs;
  final RxList<RxInt> reactCounts = <RxInt>[].obs;
  final RxList<RxBool> isLikedList = <RxBool>[].obs;
  final RxList<List<String>> IscommentsList = <List<String>>[].obs;
  final RxList<List<Comment>> commentsList = <List<Comment>>[].obs;
  void addComment(String postIndex, String userID, String commentText) {
    final Comment comment = Comment(
        userID: userID,
        text: commentText,
        timestamp: DateTime.now(),
        postID: postIndex);

    // Call a function to save the comment to Firestore here
    saveCommentToFirestore(postIndex, comment);
  }

  Future<Map<String, dynamic>> getCommentsAndUsersForPost(String postID) async {
    final comments = await getCommentsForPost(postID);
    final user = await fetchUserWithID(
        posts.firstWhere((post) => post.id == postID).userID);

    return {
      'comments': comments,
      'user': user,
    };
  }

// ... other existing code ...

  Future<void> saveCommentToFirestore(String postID, Comment comment) async {
    final CollectionReference commentsCollection =
        FirebaseFirestore.instance.collection('comments');
    try {
      await commentsCollection.add({
        'postID': postID,
        'userID': comment.userID,
        'commentText': comment.text,
        'timestamp': comment.timestamp,
      });
      print('Comment data uploaded successfully');
    } catch (e) {
      print('Error uploading comment data: $e');
    }
  }

  Future<RxList<Comment>> getCommentsForPost(String postID) async {
    final CollectionReference commentsCollection =
        FirebaseFirestore.instance.collection('comments');

    final query = await commentsCollection
        .where('postID', isEqualTo: postID)
        .orderBy('timestamp',
            descending: false) // You can change the ordering as needed
        .get();

    final comments = query.docs
        .map((doc) => Comment(
              userID: doc['userID'],
              text: doc['commentText'],
              timestamp: doc['timestamp'].toDate(),
              postID: doc['postID'],
            ))
        .toList()
        .obs;

    return comments;
  }

  Future<RxInt> getTotalReactCountForPost(String postID) async {
    final CollectionReference reactCollection =
        FirebaseFirestore.instance.collection('reactions');

    final query = await reactCollection
        .where('postID', isEqualTo: postID)
        .where('fav', isEqualTo: true)
        .get();

    final reactCount = query.docs.length.obs;
    return reactCount;
  }

  RxInt getComputedReacCount(int postIndex) {
    return RxInt(reactCounts[postIndex].value);
  }

  final RxList<PetUser?> userNames = <PetUser?>[].obs;
  @override
  void onInit() {
    // Initialize the list with 'RxBool' values for each post

    super.onInit();
    loadPosts();
  }

  Future<bool> checkIfLiked(String postID, String userID) async {
    final CollectionReference reactCollection =
        FirebaseFirestore.instance.collection('reactions');
    final query = await reactCollection
        .where('postID', isEqualTo: postID)
        .where('userID', isEqualTo: userID)
        .get();

    return query.docs.isNotEmpty;
  }

  Future<List<PetUser?>> fetchUserNames(List<Post> posts) async {
    List<PetUser?> userNames = [];

    for (int i = 0; i < posts.length; i++) {
      PetUser? user = await fetchUserWithID(posts[i].userID);
      userNames.add(user);
    }

    return userNames;
  }

  Future<RxList<RxInt>> getReactionCountsForPosts(List<Post> posts) async {
    final RxList<RxInt> counts = <RxInt>[].obs;
    for (int i = 0; i < posts.length; i++) {
      RxInt reactionCount = await getTotalReactCountForPost(posts[i].id);
      counts.add(reactionCount);
    }
    return counts;
  }

  Future<void> loadPosts() async {
    try {
      final List<Post> fetchedPosts = await getPosts();
      posts.assignAll(fetchedPosts);
      final List<PetUser?> fetchedUserNames =
          await fetchUserNames(fetchedPosts);
      userNames.assignAll(fetchedUserNames);
      reactCounts.assignAll(await getReactionCountsForPosts(fetchedPosts));
      for (int i = 0; i < fetchedPosts.length; i++) {
        // Fetch reactions for the current user and post
        final isLiked = await checkIfLiked(
            fetchedPosts[i].id, FirebaseAuth.instance.currentUser!.uid);

        isLikedList.add(isLiked.obs);

        // int reactionCount = await getTotalReactCountForPost(fetchedPosts[i].id);
      }
    } catch (e) {
      print('Error loading posts: $e');
    }
    isLoading.toggle();
    print('isLoading: $isLoading');
  }

  Future<List<Post>> getPosts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference posts = firestore.collection('posts');

    QuerySnapshot querySnapshot = await posts.get();

    List<Post> postList = [];
    querySnapshot.docs.forEach((doc) {
      postList.add(Post.fromMap(doc.data() as Map<String, dynamic>, doc.id));
    });

    return postList;
  }

  void toggleLike(int postIndex, String userID) {
    final bool isLiked = isLikedList[postIndex].value;
    final String postID = posts[postIndex].id;

    if (isLiked) {
      // User unliked the post, so decrement the reaction count if it's greater than 0
      if (reactCounts[postIndex] > 0) {
        reactCounts[postIndex]--;
      }
    } else {
      // User liked the post, so increment the reaction count
      reactCounts[postIndex]++;
    }
    isLikedList[postIndex].value = !isLikedList[postIndex].value;
    postReact(posts[postIndex].id, userID, isLikedList[postIndex].value);
  }

  // void toggleCommenting(int postIndex) {
  //   isCommentingList[postIndex].value = !isCommentingList[postIndex].value;
  // }

  Future<PetUser?> fetchUserWithID(String userID) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    DocumentSnapshot userSnapshot = await users.doc(userID).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      return PetUser.fromMap(userData);
    } else {
      return null; // User not found
    }
  }

  Future<void> postReact(String postID, String userID, bool fav) async {
    final CollectionReference reactCollection =
        FirebaseFirestore.instance.collection('reactions');
    final query = await reactCollection
        .where('postID', isEqualTo: postID)
        .where('userID', isEqualTo: userID)
        .get();

    if (query.docs.isNotEmpty) {
      // Document already exists, update it.
      final docId = query.docs[0].id;
      await reactCollection.doc(docId).update({'fav': fav});
      print('React data updated successfully');
    } else {
      // Document does not exist, add a new one.
      try {
        await reactCollection.add({
          'postID': postID,
          'userID': userID,
          'fav': fav,
        });
        print('React data uploaded successfully');
      } catch (e) {
        print('Error uploading react data: $e');
      }
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PostsController postsController;

  DocumentSnapshot? lastPostDocument;
  ScrollController _scrollController = ScrollController();

  var _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    postsController = Get.put(PostsController());
  }

  String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays < 30) {
      return "${difference.inDays} days ago";
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "$months ${months == 1 ? 'month' : 'months'} ago";
    } else {
      final years = (difference.inDays / 365).floor();
      return "$years ${years == 1 ? 'year' : 'years'} ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: RefreshIndicator(
          onRefresh: () async {
            await postsController.loadPosts();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.04,
                  color: Color(0xFFFFF9C4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      Text(
                        'PetBook',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPhotoPage(),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/add-file.png',
                          height: 27,
                          width: 30,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
              Obx(() {
                final load = postsController.isLoading;
                if (load.value)
                  return Flexible(
                      child: ListView.builder(
                          itemCount: postsController.posts.length,
                          itemBuilder: (context, index) {
                            Post post = postsController.posts[index];
                            RxBool isCommenting = false.obs;
                            RxBool viewAll = false.obs;
                            RxInt reacCount =
                                postsController.reactCounts[index];

                            PetUser? _user = postsController.userNames[index];
                            RxBool? isLiked =
                                postsController.isLikedList[index];

                            return Obx(
                              () {
                                return Container(
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                              offset: Offset(1, 2))
                                        ]),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                child: Image.network(
                                                  _user?.petPhoto ??
                                                      'https://www.cdc.gov/healthypets/images/pets/cute-dog-headshot.jpg?_=42445',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              _user?.petName ?? 'Unknown',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            subtitle: Text(
                                              formatRelativeTime(post.time),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              post.text ?? 'Unknown',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          //post image
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.35,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.93,
                                                    // margin: EdgeInsets.symmetric(
                                                    //     horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: CachedNetworkImage(
                                                      imageUrl: post.image ??
                                                          'https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg',
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator()), // Placeholder widget while loading.
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(
                                                              Icons
                                                                  .error_outline,
                                                              size: 40,
                                                              color: Colors
                                                                  .red), // Error widget.
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (post.image ==
                                                  null) // Show when the image is null
                                                Icon(
                                                  Icons.error_outline,
                                                  size: 40,
                                                  color: Colors.red,
                                                ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          postsController
                                                              .toggleLike(
                                                                  index,
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid);
                                                        },
                                                        child: Icon(
                                                          Icons.favorite_border,
                                                          color: isLiked.value
                                                              ? Colors.pink
                                                              : null,
                                                        )),
                                                    Text(
                                                        '$reacCount Loves'), // Display the react count.

                                                    SizedBox(width: 10),
                                                    GestureDetector(
                                                      onTap: () {
                                                        isCommenting.toggle();
                                                      },
                                                      child: Image.asset(
                                                        'assets/speech-bubble.png',
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              isCommenting.value
                                                  ? Column(
                                                      children: [
                                                        Divider(
                                                          thickness: 1.2,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10.0,
                                                                  top: 10),
                                                          child: Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.1),
                                                                    )
                                                                  ]),
                                                              child: TextField(
                                                                controller:
                                                                    _textController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      '   Add a comment...',
                                                                ),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                onSubmitted:
                                                                    (comment) {
                                                                  postsController.addComment(
                                                                      post.id,
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid,
                                                                      comment);
                                                                  _textController
                                                                      .clear();
                                                                  // Add a function to post the comment to Firestore
                                                                  // postComment(post.id, comment);
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                              isCommenting.value
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              bottom: 10,
                                                              top: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.01,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              // Navigate to a new screen to view all comments
                                                              // Navigator.of(context).push(
                                                              //   MaterialPageRoute(
                                                              //     builder: (context) => AllCommentsScreen(post.id),
                                                              //   ),
                                                              // );
                                                            },
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                viewAll
                                                                    .toggle();
                                                              },
                                                              child: Text(
                                                                  'View all comments'),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              if (viewAll.value)
                                                Flexible(
                                                  child: FutureBuilder<
                                                      Map<String, dynamic>>(
                                                    future: postsController
                                                        .getCommentsAndUsersForPost(
                                                            post.id),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return CircularProgressIndicator();
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      } else if (!snapshot
                                                          .hasData) {
                                                        return Text(
                                                            'No comments available.');
                                                      } else {
                                                        final comments =
                                                            snapshot.data![
                                                                    'comments']
                                                                as List<
                                                                    Comment>;
                                                        PetUser? user = snapshot
                                                            .data!['user'];

                                                        return ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              comments.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final comment =
                                                                comments[index];
                                                            return Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.1),
                                                              ),
                                                              child: ListTile(
                                                                leading:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  child:
                                                                      Container(
                                                                    width: 50,
                                                                    height: 50,
                                                                    child: Image
                                                                        .network(
                                                                      _user?.petPhoto ??
                                                                          '',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                title: Text(
                                                                    user?.petName ??
                                                                        'Unknown',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    )),
                                                                subtitle: Text(
                                                                    formatRelativeTime(
                                                                        comment
                                                                            .timestamp)),
                                                                trailing: Text(
                                                                    comment
                                                                        .text),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                  ),
                                                )
                                            ],
                                          )
                                        ]));
                              },
                            );
                          }));
                else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
