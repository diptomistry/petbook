import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loversProfile.dart';

class LoversPage extends StatefulWidget {
  @override
  _LoversPageState createState() => _LoversPageState();
}

class _LoversPageState extends State<LoversPage> {
  List<Map<String, dynamic>>? lovers;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLovers();
  }

  Future<void> fetchLovers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final userSnapshot = await userRef.get();
    final lovedByList = userSnapshot.data()?['lovedBy'] as List<dynamic> ?? [];

    final usersData = <Map<String, dynamic>>[];

    for (final email in lovedByList) {
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
      lovers = usersData;
    });
  }

  void _searchLovers(String query) {
    if (query.isEmpty) {
      // If the search query is empty, display all lovers
      fetchLovers();
    } else {
      // Filter lovers by petName or ownerName
      final filteredLovers = lovers
          ?.where((lover) {
        final petName = lover['petName'] as String;
        final ownerName = lover['ownerName'] as String;
        return petName.toLowerCase().contains(query.toLowerCase()) ||
            ownerName.toLowerCase().contains(query.toLowerCase());
      })
          .toList();

      setState(() {
        lovers = filteredLovers;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lovers'),
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
                _searchLovers(query); // Call the search function
              },
            ),
          ),
          Expanded(
            child: lovers != null
                ? (lovers!.isEmpty
                ? Center(child: Text('No lovers found.'))
                : ListView.builder(
              itemCount: lovers!.length,
              itemBuilder: (context, index) {
                final user = lovers![index];
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
