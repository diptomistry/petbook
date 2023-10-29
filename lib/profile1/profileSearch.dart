import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petbook/profile1/searchedProfile.dart';
// Import your profile_search.dart file

class ProfileSearchPage extends StatefulWidget {
  @override
  _ProfileSearchPageState createState() => _ProfileSearchPageState();
}

class _ProfileSearchPageState extends State<ProfileSearchPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _currentUser;
  List<QueryDocumentSnapshot> _userList = [];

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
    setState(() {
      _userList = usersSnapshot.docs.where((doc) => doc.id != _currentUser.uid).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Search'),
      ),
      body: ListView.builder(
        itemCount: _userList.length,
        itemBuilder: (context, index) {
          DocumentSnapshot userData = _userList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userData['imageLink'] ??
                  'https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg'),
            ),
            title: Text(userData['petName'] ?? ''),
            subtitle: Text(userData['ownerName'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileSearch(userData: userData), // Use the ProfileSearch widget
                ),
              );
            },
          );
        },
      ),
    );
  }
}
