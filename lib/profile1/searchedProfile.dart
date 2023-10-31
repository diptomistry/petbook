import 'package:cached_network_image/cached_network_image.dart';
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
  bool isLoved = false;

  @override
  Widget build(BuildContext context) {
    final userData = widget.userData; // Access the user data from the widget

    return Scaffold(
      appBar: AppBar(
        title: Text(userData['petName'] ?? 'User Profile'),
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

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40), // Adjust the left padding as needed
                    child: Text(
                      userData['petName'] ?? '',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    UserModel firebaseContact = UserModel.fromMap(widget.userData.data() as Map<String, dynamic>);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(user: firebaseContact),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/messenger.svg',
                    color: Theme.of(context).hintColor,
                    height: 40,
                    width: 40,
                  ),
                ),
                Text('      '),
              ],
            ),





            SizedBox(height: 16),
            Row(
              children: [
                SizedBox(width: 3),
                Icon(
                  Icons.location_on, // Use the location icon
                  color: Theme.of(context).hintColor, // Customize the icon color
                  size: 30, // Customize the icon size
                ),
                SizedBox(width: 8), // Add spacing between the icon and text
                Text(
                  '${userData['location'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16), // Customize the text style
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        isLoved ? Icons.favorite : Icons.favorite_border, // Toggle between filled and outline heart icons
                        size: 40, // Increase the icon size
                        color: isLoved ? Theme.of(context).hintColor : Colors.black, // Change the icon color when loved
                      ),
                      onPressed: () async {
                        int currentLoveCount = userData?['loveCount'] ?? 0;
                        int newLoveCount = currentLoveCount + 1;
                        final userRef = FirebaseFirestore.instance.collection('users').doc(widget.userData.id); // Assuming 'users' is your collection name

                        await userRef.update({
                          'loveCount': newLoveCount,
                        });
                        // _userData?['loveCount'] = newLoveCount;
                        // Now, you can update the loveCount in Firestore
                       // _updateLoveCount(newLoveCount);
                        // Toggle the "love" state when the button is clicked
                        setState(() {
                          isLoved = !isLoved;
                        });

                        // Implement additional actions when loved/unloved
                        if (isLoved) {
                          // Perform an action when loved (e.g., add to favorites)
                        } else {
                          // Perform an action when unloved (e.g., remove from favorites)
                        }
                      },
                    ),
                  ),
                ),
                Text('      '),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 243), // Adjust the left padding as needed
                  child: Text(
                    ' ${userData?['loveCount'].toString()}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ],
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
                      launch('https://www.facebook.com/${userData['ownersFb']}');
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
                        'Adopt Me',
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
