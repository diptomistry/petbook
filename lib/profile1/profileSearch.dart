
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petbook/profile1/searchedProfile.dart';

class ProfileSearchPage extends StatefulWidget {
  @override
  _ProfileSearchPageState createState() => _ProfileSearchPageState();
}

class _ProfileSearchPageState extends State<ProfileSearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _userList = [];
  String _selectedOption = 'All'; // Default selection
  TextEditingController _searchController = TextEditingController();




  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  Future<void> _fetchAllUsers() async {
    final usersSnapshot = await _firestore.collection('users').get();
    setState(() {
      _userList = usersSnapshot.docs;
    });
  }

  Future<void> _fetchUsersByAdoptionStatus() async {
    final usersSnapshot = await _firestore.collection('users').where('forAdoption', isEqualTo: _selectedOption == 'For Adoption' ? 'yes' : 'no').get();
    setState(() {
      _userList = usersSnapshot.docs;
    });
  }

  Future<void> _fetchUsersBySpecies(String species) async {
    final usersSnapshot = await _firestore.collection('users').where('species', isEqualTo: species).get();
    setState(() {
      _userList = usersSnapshot.docs;
    });
  }

  void _searchUsers(String query) async {
    if (_selectedOption == 'All') {
      final allUsersSnapshot = await _firestore.collection('users').where('petName', isGreaterThanOrEqualTo: query).get();
      setState(() {
        _userList = allUsersSnapshot.docs;
      });
    } else {
      final snapshot = await _firestore.collection('users').where('forAdoption', isEqualTo: _selectedOption == 'For Adoption' ? 'yes' : 'no').get();
      setState(() {
        _userList = snapshot.docs.where((user) {
          final userData = user.data() as Map<String, dynamic>;
          final petName = userData['petName']?.toLowerCase() ?? '';
          final ownerName = userData['ownerName']?.toLowerCase() ?? '';
          return petName.contains(query.toLowerCase()) || ownerName.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _viewUserProfile(DocumentSnapshot userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSearch(userData: userData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Profile'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      _searchUsers(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Pet/Owner Name',
                      hintStyle: TextStyle(color: Colors.grey), // Change the hint text color
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),

                ),
                SizedBox(width: 10),
                Container(
                  width: 160, // Adjust the width as needed
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Change the line color here
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedOption,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption = newValue!;
                        _searchController.clear();
                        if (_selectedOption == 'For Adoption' || _selectedOption == 'Not for Adoption') {
                          _fetchUsersByAdoptionStatus();
                        } else if (_selectedOption == 'All') {
                          _fetchAllUsers();
                        } else {
                          _fetchUsersBySpecies(_selectedOption);
                        }
                      });
                    },
                    underline: Container(),
                    items: <String>['All', 'For Adoption', 'Not for Adoption', 'cat', 'dog', 'bird'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black), // Change the text color here
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _userList.length,
              itemBuilder: (context, index) {
                final userData = _userList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(userData['imageLink'] ??
                        'https://cdn.wallpapersafari.com/51/50/mPlCtx.jpg'),
                  ),
                  title: Text(
                    userData['petName'] ?? 'Unknown Pet',
                    style: TextStyle(color: Theme.of(context).hintColor), // Change the text color here
                  ),
                  subtitle: Text(
                    userData['ownerName'] ?? 'Unknown Owner',
                    style: TextStyle(color: Colors.black), // Change the text color here
                  ),
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
