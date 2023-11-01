import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loversProfile.dart';

class FollowersPage extends StatefulWidget {
  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  List<Map<String, dynamic>>? Followers;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFollowers();
  }

  Future<void> fetchFollowers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final userSnapshot = await userRef.get();
    final followedbyList = userSnapshot.data()?['followedby'] as List<dynamic> ?? [];

    final usersData = <Map<String, dynamic>>[];

    for (final email in followedbyList) {
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userData = userQuery.docs.first.data() as Map<String, dynamic>;
        usersData.add(userData);
      }
    }

    setState(() {
      Followers = usersData;
    });
  }

  void _searchFollowers(String query) {
    if (query.isEmpty) {
      // If the search query is empty, display all Followers
      fetchFollowers();
    } else {
      // Filter Followers by petName or ownerName
      final filteredFollowers = Followers
          ?.where((lover) {
        final petName = lover['petName'] as String;
        final ownerName = lover['ownerName'] as String;
        return petName.toLowerCase().contains(query.toLowerCase()) ||
            ownerName.toLowerCase().contains(query.toLowerCase());
      })
          .toList();

      setState(() {
        Followers = filteredFollowers;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Pet Name or Owner Name',
                labelStyle: TextStyle(color: Colors.grey),
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.search),

              ),
              style: TextStyle(color: Colors.black),
              onChanged: (query) {
                _searchFollowers(query); // Call the search function
              },
            ),
          ),
          Expanded(
            child: Followers != null
                ? (Followers!.isEmpty
                ? Center(child: Text('No Followers found.'))
                : ListView.builder(
              itemCount: Followers!.length,
              itemBuilder: (context, index) {
                final user = Followers![index];
                final petName = user['petName'];
                final ownerName = user['ownerName'];
                final imageLink = user['imageLink'];

                return GestureDetector(
                  onTap: () {
                    // Navigate to the ProfileSearch page with the selected profile data
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>Loved(userData: user),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imageLink),
                    ),
                    title: Text(petName,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    subtitle: Text(ownerName,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ))
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
