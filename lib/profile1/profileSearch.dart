import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petbook/profile1/searchedProfile.dart';

class ProfileSearchPage extends StatefulWidget {
  @override
  _ProfileSearchPageState createState() => _ProfileSearchPageState();
}

class _ProfileSearchPageState extends State<ProfileSearchPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _currentUser;
  List<QueryDocumentSnapshot> _userList = [];
  List<QueryDocumentSnapshot> _searchResults = [];
  String selectedFilter = 'All'; // Default selection

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

  void _search(String query) {
    setState(() {
      _searchResults = _userList.where((userData) {
        final petName = userData['petName']?.toLowerCase() ?? '';
        final ownerName = userData['ownerName']?.toLowerCase() ?? '';
        //final species = userData['species']?.toLowerCase() ?? ''; // Add 'species' field to your user data
        //final adoptionStatus = userData['adoptionStatus']?.toLowerCase() ?? ''; // Add 'adoptionStatus' field to your user data
        final lowerQuery = query.toLowerCase();

        // Check if the selected filter is 'All' or matches the user's species or adoption status
        final filterMatch =
            //selectedFilter == 'All' || species.contains(selectedFilter.toLowerCase()) || adoptionStatus.contains(selectedFilter.toLowerCase());
        selectedFilter == 'All';
        return petName.contains(lowerQuery) || ownerName.contains(lowerQuery) && filterMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _search,
                    decoration: InputDecoration(
                      hintText: 'Search by Pet Name or Owner Name',
                      prefixIcon: Icon(Icons.search),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 10),
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list, color: Colors.black), // Customize the filter icon
                  onSelected: (String value) {
                    setState(() {
                      selectedFilter = value;
                      _search('');
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                        value: 'All',
                        child: Text('All', style: TextStyle(color: Colors.black)), // Customize the text color
                      ),
                      PopupMenuItem<String>(
                        value: 'Cat',
                        child: Text('Cat', style: TextStyle(color: Colors.black)), // Customize the text color
                      ),
                      PopupMenuItem<String>(
                        value: 'Dog',
                        child: Text('Dog', style: TextStyle(color: Colors.black)), // Customize the text color
                      ),
                      PopupMenuItem<String>(
                        value: 'Bird',
                        child: Text('Bird', style: TextStyle(color: Colors.black)), // Customize the text color
                      ),
                      PopupMenuItem<String>(
                        value: 'Other',
                        child: Text('Other', style: TextStyle(color: Colors.black)), // Customize the text color
                      ),
                      PopupMenuItem<String>(
                        value: 'For Adoption',
                        child: Text('For Adoption', style: TextStyle(color: Colors.black)), // Customize the text color
                      ),
                      PopupMenuItem<String>(
                        value: 'Not for Adoption',
                        child: Text('Not for Adoption', style: TextStyle(color: Colors.black)), // Customize the text color
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                DocumentSnapshot userData = _searchResults[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(userData['imageLink'] ??
                        'https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg'),
                  ),
                  title: Text(
                    userData['petName'] ?? '',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(userData['ownerName'] ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSearch(userData: userData),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
