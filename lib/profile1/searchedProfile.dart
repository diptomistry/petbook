import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petbook/common/modelss/user_model.dart';
import 'package:petbook/feature/chat/pages/chat_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSearch extends StatefulWidget {
  final DocumentSnapshot userData;


  ProfileSearch({required this.userData});

  @override
  _ProfileSearchState createState() => _ProfileSearchState();
}

class _ProfileSearchState extends State<ProfileSearch> {
  bool isFollowing = false;
  bool isLoved = false;
  bool isLoved2 = false;
  var flag=0;
  var flag2=0;
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  int currentLoveCount=0;


  @override
  Widget build(BuildContext context) {

    final userData = widget.userData;
   // int currentLoveCount = userData['loveCount'] ?? 0;
    Future<int> fetchLoveCount() async {
      final userRef = FirebaseFirestore.instance.collection('users').doc(widget.userData.id);
      final doc = await userRef.get();
      final userData = doc.data() as Map<String, dynamic>;
      currentLoveCount=userData['loveCount'];
      return userData['loveCount'] as int;
    }


    print('gh$isLoved');
    if (currentUserEmail != null && userData != null) {
      if (flag == 0) {
        final List<dynamic> lovedByList = userData['lovedBy'] ?? [];
        if (lovedByList.contains(currentUserEmail)) {
          isLoved = true;
        }
      }
    }

    if (currentUserEmail != null && userData != null) {
      if (flag2 == 0) {
        final List<dynamic> followedBy = userData['followedby'] ?? [];
        if (followedBy.contains(currentUserEmail)) {
          isFollowing = true;
        }
      }
    }
    void toggle(){
      isLoved = !isLoved;
      flag++;
    }
    void toggle2(){
      isFollowing = !isFollowing;
      flag2++;
    }

    print("ch$isLoved");



  // Access the user data from the widget

    return Scaffold(
      appBar: AppBar(
        title: Text(userData['species'] ?? 'User Profile'),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: userData['imageLink'] ??
                      'https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => Container(
                    width: 328,
                    height: 216,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

           // Row(
            //  children: [

               // SizedBox(width: 16),
               // Expanded(
                //  child: Padding(
                 //   padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
                   // child: 
                  Center(
                    child: Text(
                        '${userData['petName']}' ?? '',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    ),
                  ),
                 // ),
                //),

              //  SizedBox(width: 36),

           //   ],
           // ),
           Row(
             children: [
               Icon(
                 Icons.location_on,
                 color: Theme.of(context).hintColor,
                 size: 30,
               ),
               SizedBox(width: 8),
               Text(
                 '${userData['location'] ?? 'N/A'}',
                 style: TextStyle(fontSize: 16),
               ),
             ],

           ),
            SizedBox(height: 10),

            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      UserModel firebaseContact = UserModel.fromMap(widget.userData.data() as Map<String, dynamic>);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(user: firebaseContact),
                        ),
                      );
                      // Implement the action for the "Message" button
                    },
                    icon: Icon(Icons.message),
                    label: Text("Message"),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).hintColor, // Customize the button color
                    ),
                  ),
                  SizedBox(width: 6),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final userRef = FirebaseFirestore.instance.collection('users').doc(widget.userData.id);
                      List<dynamic> followedBy = List<dynamic>.from(userData['followedby'] ?? []);
                      if (isFollowing) {
                        followedBy.remove(currentUserEmail);
                      } else {
                        followedBy.add(currentUserEmail);
                      }

                      await userRef.update({
                        'followedby': followedBy,
                      });

                      setState(() {
                        toggle2();
                      });
                    },
                    icon: Icon(isFollowing ? Icons.person_remove : Icons.person_add), // Change the icon based on follow status
                    label: Text(isFollowing ? "Following" : "Follow"), // Change the text based on follow status
                    style: ElevatedButton.styleFrom(
                        backgroundColor: isFollowing ?Theme.of(context).hintColor :Colors.grey ,
                    ),
                  ),
                  SizedBox(width: 6),
                  FutureBuilder<int>(
                    future: fetchLoveCount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // You can return a loading indicator here if needed
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Handle the error
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final updatedLoveCount = snapshot.data ?? 0;
                        return  ElevatedButton.icon(
                          onPressed: () async {
                            final userRef = FirebaseFirestore.instance.collection('users').doc(widget.userData.id);
                            int currentLoveCount = userData['loveCount'] ?? 0;
                            List<dynamic> lovedByList = List<dynamic>.from(userData['lovedBy'] ?? []);

                            if (isLoved) {
                              if (lovedByList.contains(currentUserEmail)) {
                                lovedByList.remove(currentUserEmail);
                                currentLoveCount--; // Decrease the love count by 1
                              }
                            } else {
                              if (!lovedByList.contains(currentUserEmail)) {
                                lovedByList.add(currentUserEmail);
                                currentLoveCount++; // Increase the love count by 1
                              }
                            }

                            await userRef.update({
                              'lovedBy': lovedByList,
                              'loveCount': currentLoveCount, // Update the loveCount field
                            });


                            setState(() {
                              toggle();

                            });
                          },
                          icon: Icon(
                            isLoved ? Icons.favorite : Icons.favorite_border,
                            color: isLoved ? Color(0xFF7A6BBC) : null, // Set color to red when loved
                          ),
                          label: Text("$currentLoveCount Love"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLoved ? Theme.of(context).hintColor : Colors.grey,
                          ),
                        );
                      }
                    },
                  )





                ],
              ),
            ),










            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn(
                  label: 'Gender',
                  value: userData['petGender'] ?? '',
                  color: Color(0xFFDDD8AE),
                ),
                _buildInfoColumn(
                  label: 'Age',
                  value: userData['petAge'] ?? '',
                  color: Color(0xFFDDD8AE),
                ),
                _buildInfoColumn(
                  label: 'Weight',
                  value: userData['petWeight'] ?? '',
                  color: Color(0xFFDDD8AE),
                ),
              ],
            ),
            SizedBox(height: 26),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: userData['imageLink2'] ??
                            'https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg',
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 44,
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['ownerName'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text('Pet Owner'),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launch('mailto:${userData['email']}');
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                        color: Color(0xFFDDD8AE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(Icons.email, color: Color(0xFF00a19d)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launch('${userData['ownersFb']}');
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                        color: Color(0xFFDDD8AE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(Icons.facebook, color: Color(0xFF00a19d)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            if(userData['forAdoption']=='yes')
            Container(
              width: 335,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Define the action for marking the pet for adoption
                      },
                      icon: Icon(Icons.pets),
                      label: Text(
                        'Contact with ${userData['ownerName']} to adopt me',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).hintColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.blueGrey, width: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(!(userData['forAdoption']=='yes'))
            Container(
              width: 335,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Define the action for marking the pet for adoption
                      },
                      icon: Icon(Icons.pets),
                      label: Text(
                        'Not for Adoption',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.blueGrey, width: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 100,
      height: 100,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(''),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFFA9ACAD),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF00a19d),
            ),
          ),
        ],
      ),
    );
  }
}
