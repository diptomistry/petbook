// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:petbook/profile1/utils.dart';
// import 'package:petbook/profile1/add_data.dart';
// import 'package:url_launcher/url_launcher.dart';
// class UserProfilePage extends StatefulWidget {
//   @override
//   _UserProfilePageState createState() => _UserProfilePageState();
// }
// class _UserProfilePageState extends State<UserProfilePage> {
//   bool isLoved = false;
//   Uint8List? _image;
//   Uint8List? _image2;
//   late User _user;
//    DocumentSnapshot? _userData;
//   bool isTextEntryVisible = false;
//   bool _isEditing = false; // Variable to track editing state
//   TextEditingController _petNameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _petGenderController = TextEditingController();
//   TextEditingController _ownersFbController = TextEditingController();
//   TextEditingController _petAgeController = TextEditingController();
//   TextEditingController _petWeightController = TextEditingController();
//   TextEditingController _ownerNameController = TextEditingController();
//   TextEditingController locationController= TextEditingController();
//
//
//
//   void toggleTextEntry() {
//     setState(() {
//       isTextEntryVisible = !isTextEntryVisible;
//     });
//   }
//
//
//
//   @override
//   void dispose() {
//     _petNameController.dispose();
//     _emailController.dispose();
//     _petGenderController.dispose();
//     _ownersFbController.dispose();
//     _petAgeController.dispose();
//     _petWeightController.dispose();
//     _ownerNameController.dispose();
//     locationController.dispose();
//     super.dispose();
//   }
//   void selectImage() async {
//     Uint8List img = await pickImage(ImageSource.gallery);
//     setState(() {
//       _image = img;
//     });
//   }
//   void selectImage2() async {
//     Uint8List img2 = await pickImage(ImageSource.gallery);
//     setState(() {
//       _image2 = img2;
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//     _user = FirebaseAuth.instance.currentUser!;
//     _fetchUserData();
//   }
//   Future<void> _fetchUserData() async {
//     DocumentSnapshot userData =
//     await FirebaseFirestore.instance.collection('users').doc(_user.uid).get();
//     setState(() {
//       _userData = userData;
//     });
//   }
//   void _editProfile() {
//     setState(() {
//       _isEditing = true;
//     });
//     // Add navigation logic to the "Edit Profile" screen
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(builder: (context) => EditProfilePage(userData: _userData)),
//     // ).then((value) {
//     //   setState(() {
//     //     _isEditing = false;
//     //   });
//     //   _fetchUserData(); // Fetch updated user data after editing
//     // });
//   }
//   Future<void> _saveProfile() async {
//     setState(() {
//       _isEditing = false;
//     });
//     String resp = await StoreData().saveData(file: _image!);
//     // Add logic to save the profile changes to Firebase
//     // You can use _userData to update the Firebase document
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:AppBar(
//         title: Text('Profile'),
//         backgroundColor: Theme.of(context).hintColor,
//         leading: Builder(
//           builder: (context) {
//             return IconButton(
//               icon: Icon(Icons.menu), // Replace with the icon you want for the menu
//               onPressed: () {
//                 Scaffold.of(context).openDrawer(); // Open the sidebar when the menu button is clicked
//               },
//             );
//           },
//         ),
//         actions: [
//           if (!_isEditing)
//             IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: _editProfile,
//             ),
//           if (_isEditing)
//             IconButton(
//               icon: Icon(Icons.save),
//               onPressed: _saveProfile,
//             ),
//         ],
//       ),
//       drawer: Drawer(
//         width: 250, // Adjust the width of the sidebar
//         child: ListView(
//           children: [
//             ListTile(
//               leading: Icon(Icons.arrow_back),
//               onTap: () {
//                 Navigator.of(context).pop(); // Close the sidebar
//               },
//
//             ),
//             ListTile(
//               leading: Icon(Icons.article),
//               title: Text('Posts', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
//               onTap: () {
//                 // Define the action for "Posts" button
//                 Navigator.of(context).pop(); // Close the sidebar
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.favorite),
//               title: Text('Loves', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
//               onTap: () {
//                 // Define the action for "Loves" button
//                 Navigator.of(context).pop(); // Close the sidebar
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.lock),
//               title: Text('Profile Lock', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
//               onTap: () {
//                 // Define the action for "Profile Lock" button
//                 Navigator.of(context).pop(); // Close the sidebar
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.circle),
//               title: Text('Active Status', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
//               onTap: () {
//                 // Define the action for "Active Status" button
//                 Navigator.of(context).pop(); // Close the sidebar
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.dark_mode),
//               title: Text('Dark Mode', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
//               onTap: () {
//                 // Define the action for "Dark Mode" button
//                 Navigator.of(context).pop(); // Close the sidebar
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.lock),
//               title: Text('Privacy and Security', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
//               onTap: () {
//                 // Define the action for "Privacy and Security" button
//                 Navigator.of(context).pop(); // Close the sidebar
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.help),
//               title: Text('Help & Support', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
//               onTap: () {
//                 // Define the action for "Help & Support" button
//                 Navigator.of(context).pop(); // Close the sidebar
//               },
//             ),
//             SizedBox(height: 16),
//             Container(
//               width: 300,
//               height: 50,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     //button in the whole row
//                     child: ElevatedButton(
//                       onPressed:(){},
//                       child: Text(
//                         'Logout',
//                         style: TextStyle(
//                             fontSize: 16,
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .secondary),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:Colors.grey,
//                         // Customize the button color
//                         // foregroundColor: Colors.red,
//                         // Customize the text color
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           side: BorderSide(
//                               color: Colors.blueGrey, width: 0.6),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//
//
//
//           ],
//         ),
//       ),
//       body: _userData == null
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 _image != null && _isEditing
//                     ? Container(
//                   width: 328, // Set the desired width
//                   height: 216, // Set the desired height
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(16.0),
//                     image: DecorationImage(
//                       image: MemoryImage(_image!),
//                       fit: BoxFit.cover, // Adjust the fit as needed
//                     ),
//                   ),
//                 )
//                     : Container(
//                   width: 328, // Set the desired width
//                   height: 216, // Set the desired height
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(16.0),
//                     image: DecorationImage(
//                       image: NetworkImage(
//                           'https://cdn.dribbble.com/users/1044993/screenshots/4092551/australian-shepherd_dribbble.png?resize=400x0'),
//                       fit: BoxFit.cover, // Adjust the fit as needed
//                     ),
//                   ),
//                 ),
//                 if (_isEditing)
//                   Positioned(
//                     bottom: 0,
//                     right: 1,
//                     child: IconButton(
//                       onPressed: selectImage,
//                       icon: Icon(Icons.add_a_photo),
//                     ),
//                   )
//               ],
//             ),
//             Text(
//                 ''
//             ),
//             Center(
//               child: _isEditing
//                   ? TextFormField(
//                 controller: _petNameController,
//                 decoration: InputDecoration(
//                   hintText: '   Pet Name',
//                 ),
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               )
//                   : Text(
//                 _userData?['petName']??'',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             Container(
//               width: 335,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           Icons.add_location,
//                           color: Theme.of(context).hintColor,
//                         ),
//                         onPressed: () {
//                           // Toggle the visibility of the text entry when the icon is clicked
//                           toggleTextEntry();
//                         },
//                       ),
//                       if (!isTextEntryVisible)
//                         Text(
//                           'Add Location',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                     ],
//                   ),
//                   if (isTextEntryVisible)
//                     Flexible(
//                       child: TextField(
//                         controller: locationController,
//                         decoration: InputDecoration(
//                           hintText: 'Location...',
//                           hintStyle: TextStyle(color: Theme.of(context).hintColor),
//                         ),
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                  if(!_isEditing)
//                    IconButton(
//                      icon: Icon(
//                        isLoved ? Icons.favorite : Icons.favorite_border, // Toggle between filled and outline heart icons
//                        size: 32, // Increase the icon size
//                        color: isLoved ? Theme.of(context).hintColor : Colors.black, // Change the icon color when loved
//                      ),
//                      onPressed: () {
//                        // Toggle the "love" state when the button is clicked
//                        setState(() {
//                          isLoved = !isLoved;
//                        });
//
//                        // Implement additional actions when loved/unloved
//                        if (isLoved) {
//                          // Perform an action when loved (e.g., add to favorites)
//                        } else {
//                          // Perform an action when unloved (e.g., remove from favorites)
//                        }
//                      },
//                    )
//
//                 ],
//               ),
//             ),
//
//
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 if(!_isEditing)
//                   _buildInfoColumn(
//                     label: 'Gender',
//                     value:  _userData?['petGender']??'',
//                     color: Color(0xFFDDD8AE),
//                   ),
//                 if(_isEditing)
//                   _buildInfoColumnEdit(
//                     label: 'Gender',
//                     color: Color(0xFFDDD8AE),
//                     controller: _petGenderController,
//                   ),
//                 if(!_isEditing)
//                   _buildInfoColumn(
//                     label: 'Age',
//                     value:  _userData?['petAge']??'',
//                     color: Color(0xFFDDD8AE),
//                   ),
//                 if(_isEditing)
//                   _buildInfoColumnEdit(
//                     label: 'Age',
//                     color: Color(0xFFDDD8AE), controller: _petAgeController,
//                   ),
//                 if(!_isEditing)
//                   _buildInfoColumn(
//                     label: 'Weight',
//                     value: _userData?['petWeight']??'',
//                     color: Color(0xFFDDD8AE),
//                   ),
//                 if(_isEditing)
//                   _buildInfoColumnEdit(
//                     label: 'Weight',
//                     color: Color(0xFFDDD8AE), controller: _petWeightController,
//                   ),
//               ],
//             ),
//             //if(_isEditing)
//             if(!_isEditing)
//               SizedBox(height: 46),
//             if (!_isEditing)
//               Padding(
//                 padding: EdgeInsets.only(left: 10),
//                 child: Row(
//                   children: [
//                     Stack(
//                       children: [
//                         _image != null&&_isEditing
//                             ? CircleAvatar(
//                           radius: 44,
//                           backgroundImage: MemoryImage(_image!),
//                         )
//                             : const CircleAvatar(
//                           radius: 44,
//                           backgroundImage: NetworkImage(
//                               'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?w=1380&t=st=1693564186~exp=1693564786~hmac=34badb23f9ce7734364a431e350be4ddba450762fc9d703bf10b4dc3d9f0e96b'),
//                         ),
//                         if (_isEditing)
//                           Positioned(
//                             bottom: -10, // Adjust the top position of the button
//                             right: -15, // Adjust the right position of the button
//                             child: IconButton(
//                               onPressed: selectImage,
//                               icon: Icon(Icons.add_a_photo,size: 18),
//                             ),
//                           ),
//                       ],
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Container(
//                         width: 200,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${_userData?['ownerName']??''}',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             Text('Pet Owner'),
//                           ],
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         launch('mailto:${_userData?['email']??''}');
//                       },
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         margin: EdgeInsets.only(right: 30),
//                         decoration: BoxDecoration(
//                           color: Color(0xFFDDD8AE),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: Icon(Icons.email, color: Color(0xFF00a19d)),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         launch('https://www.facebook.com/${_userData?['ownersFb']??''}');
//                       },
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         margin: EdgeInsets.only(right: 30),
//                         decoration: BoxDecoration(
//                           color: Color(0xFFDDD8AE),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: Icon(Icons.facebook, color: Color(0xFF00a19d)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             if(_isEditing)
//               Padding(
//                 padding: EdgeInsets.only(left: 10),
//                 child: Row(
//                   children: [
//                     Stack(
//                       children: [
//                         _image2 != null && _isEditing
//                             ? CircleAvatar(
//                           radius: 44,
//                           backgroundImage: MemoryImage(_image2!),
//                         )
//                             : const CircleAvatar(
//                           radius: 44,
//                           backgroundImage: NetworkImage(
//                               'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?w=1380&t=st=1693564186~exp=1693564786~hmac=34badb23f9ce7734364a431e350be4ddba450762fc9d703bf10b4dc3d9f0e96b'),
//                         ),
//                         if (_isEditing)
//                           Positioned(
//                             bottom: -10, // Adjust the top position of the button
//                             right: -15, // Adjust the right position of the button
//                             child: IconButton(
//                               onPressed: selectImage2,
//                               icon: Icon(
//                                 Icons.add_a_photo,
//                                 size: 18,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Container(
//                         width: 200,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (_isEditing)
//                               TextFormField(
//                                 controller: _ownerNameController,
//                                 decoration: InputDecoration(
//                                   hintText: 'Owner Name...',
//                                 ),
//                                 style: TextStyle(
//
//                                   color: Colors.black,
//                                 ),
//                               )
//                             else
//                               Text(
//                                 _userData?['ownerName']??'',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             if (_isEditing)
//                               TextFormField(
//                                 controller: _emailController,
//                                 decoration: InputDecoration(
//                                   hintText: 'Email...',
//                                 ),
//                                 style: TextStyle(
//
//                                   color: Colors.black,
//                                 ),
//                               )
//                             else
//                               GestureDetector(
//                                 onTap: () {
//                                   launch('mailto:${_userData?['email']??''}');
//                                 },
//                                 child: Text(
//                                   _userData?['email']??'',
//                                   style: TextStyle(
//                                     color: Color(0xFF00a19d),
//                                   ),
//                                 ),
//                               ),
//                             if (_isEditing)
//                               TextFormField(
//                                 controller: _ownersFbController,
//                                 decoration: InputDecoration(
//                                   hintText: 'Facebook...',
//                                 ),
//                                 style: TextStyle(
//
//                                   color: Colors.black,
//                                 ),
//                               )
//                             else
//                               GestureDetector(
//                                 onTap: () {
//                                   launch('https://www.facebook.com/${_userData?['ownersFb']??''}');
//                                 },
//                                 child: Text(
//                                   _userData?['ownersFb']??'',
//                                   style: TextStyle(
//                                     color: Color(0xFF00a19d),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             if(!_isEditing)
//               SizedBox(height: 26),
//             if(_isEditing)
//               SizedBox(height: 16),
//             if(!_isEditing)
//               Container(
//                 width: 335,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           // Define the action for marking the pet for adoption
//                         },
//                         icon: Icon(Icons.pets),
//                         label: Text(
//                           'Mark for Adoption',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Theme.of(context).colorScheme.secondary,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Theme.of(context).hintColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: BorderSide(color: Colors.blueGrey, width: 0.6),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             if(_isEditing)
//               Container(
//                 width: 335,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           // Define the action for marking the pet for adoption
//                         },
//                         icon: Icon(Icons.pets),
//                         label: Text(
//                           'Submit',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Theme.of(context).colorScheme.secondary,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Theme.of(context).hintColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: BorderSide(color: Colors.blueGrey, width: 0.6),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// Widget _buildInfoColumnEdit({
//   required String label,
//   required TextEditingController? controller,
//   required Color color,
// }) {
//   return Container(
//     decoration: BoxDecoration(
//       color: color,
//       borderRadius: BorderRadius.circular(10),
//     ),
//     width: 100,
//     height: 100,
//     padding: EdgeInsets.all(16),
//     child: Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: Color(0xFF00a19d),
//           ),
//         ),
//         if (controller != null) TextField(
//           controller: controller,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF00a19d),
//           ),
//         ),
//       ],
//     ),
//   );
// }
// Widget _buildInfoColumn({
//   required String label,
//   required String value,
//   required Color color,
// }) {
//   return Container(
//     decoration: BoxDecoration(
//       color: color,
//       borderRadius: BorderRadius.circular(10), // Adjust the border radius
//     ),
//     width: 100, // Set a fixed width
//     height: 100, // Set a fixed height
//     padding: EdgeInsets.all(16),
//     child: Column(
//       children: [
//         Text(
//             ''
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             color:  Color(0xFFA9ACAD), // Text color
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color:  Color(0xFF00a19d), // Text color
//           ),
//         ),
//       ],
//     ),
//   );
// }
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petbook/profile1/utils.dart';
import 'package:petbook/profile1/add_data.dart';
import 'package:url_launcher/url_launcher.dart';
class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}
class _UserProfilePageState extends State<UserProfilePage> {
  String? _userImageUrl;
  String? _userImage2Url;
  bool isLoved = false;
  Uint8List? _image;
  Uint8List? _image2;
  late User _user;
   DocumentSnapshot? _userData;
  bool isTextEntryVisible = false;
  bool _isEditing = false; // Variable to track editing state
  TextEditingController _petNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _petGenderController = TextEditingController();
  TextEditingController _ownersFbController = TextEditingController();
  TextEditingController _petAgeController = TextEditingController();
  TextEditingController _petWeightController = TextEditingController();
  TextEditingController _ownerNameController = TextEditingController();
  TextEditingController locationController= TextEditingController();



  void toggleTextEntry() {
    setState(() {
      isTextEntryVisible = !isTextEntryVisible;
    });
  }



  @override
  void dispose() {
    _petNameController.dispose();
    _emailController.dispose();
    _petGenderController.dispose();
    _ownersFbController.dispose();
    _petAgeController.dispose();
    _petWeightController.dispose();
    _ownerNameController.dispose();
    locationController.dispose();
    super.dispose();
  }
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }
  void selectImage2() async {
    Uint8List img2 = await pickImage(ImageSource.gallery);
    setState(() {
      _image2 = img2;
    });
  }
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _fetchUserData();
  }
  Future<void> _fetchUserData() async {
    DocumentSnapshot userData =
    await FirebaseFirestore.instance.collection('users').doc(_user.uid).get();
    setState(() {
      _userData = userData;
      //_userImageUrl = userData['imageLink'];
      //_userImage2Url = userData['imageLink'];


    });
  }
  void _editProfile() {
    setState(() {
      _isEditing = true;
    });

  }
  Future<void> _saveProfile() async {
    Future<void> _fetchUserData() async {
      DocumentSnapshot userData =
      await FirebaseFirestore.instance.collection('users').doc(_user.uid).get();
      setState(() {
        //_userData = userData;
        _userImageUrl = userData['imageLink'];
        _userImage2Url = userData['imageLink'];


      });
    }
    setState(() {
      _isEditing = false;
    });
    //String resp = await StoreData().saveData(file: _image!);
    // Add logic to save the profile changes to Firebase
    // You can use _userData to update the Firebase document
    String? userEmail = _user.email; // Get the user's email
    if (userEmail != null && _image != null) {
      await StoreData().saveData(userEmail: userEmail, file: _image!);
      // You can add additional logic here if needed
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).hintColor,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu), // Replace with the icon you want for the menu
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the sidebar when the menu button is clicked
              },
            );
          },
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _editProfile,
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveProfile,
            ),
        ],
      ),
      drawer: Drawer(
        width: 250, // Adjust the width of the sidebar
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.arrow_back),
              onTap: () {
                Navigator.of(context).pop(); // Close the sidebar
              },

            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Posts', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
              onTap: () {
                // Define the action for "Posts" button
                Navigator.of(context).pop(); // Close the sidebar
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Loves', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
              onTap: () {
                // Define the action for "Loves" button
                Navigator.of(context).pop(); // Close the sidebar
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Profile Lock', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
              onTap: () {
                // Define the action for "Profile Lock" button
                Navigator.of(context).pop(); // Close the sidebar
              },
            ),
            ListTile(
              leading: Icon(Icons.circle),
              title: Text('Active Status', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
              onTap: () {
                // Define the action for "Active Status" button
                Navigator.of(context).pop(); // Close the sidebar
              },
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Dark Mode', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
              onTap: () {
                // Define the action for "Dark Mode" button
                Navigator.of(context).pop(); // Close the sidebar
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Privacy and Security', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
              onTap: () {
                // Define the action for "Privacy and Security" button
                Navigator.of(context).pop(); // Close the sidebar
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help & Support', style: TextStyle(fontSize: 16,color: Colors.black)), // Increase font size
              onTap: () {
                // Define the action for "Help & Support" button
                Navigator.of(context).pop(); // Close the sidebar
              },
            ),
            SizedBox(height: 16),
            Container(
              width: 300,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    //button in the whole row
                    child: ElevatedButton(
                      onPressed:(){},
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.grey,
                        // Customize the button color
                        // foregroundColor: Colors.red,
                        // Customize the text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Colors.blueGrey, width: 0.6),
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
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                if (_image != null && _isEditing)
                  Container(
                    width: 328,
                    height: 216,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: MemoryImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  CachedNetworkImage(
                    imageUrl: _userImageUrl??
                        'https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg', // Use the image URL from Firestore
                    placeholder: (context, url) => CircularProgressIndicator(), // Add a placeholder widget
                    errorWidget: (context, url, error) => Icon(Icons.error), // Add an error widget
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
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 1,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo),
                    ),
                  ),
              ],
            ),

            Text(
                ''
            ),
            Center(
              child: _isEditing
                  ? TextFormField(
                controller: _petNameController,
                decoration: InputDecoration(
                  hintText: '   Pet Name',
                ),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
                  : Text(
                _userData?['petName']??'',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: 335,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add_location,
                          color: Theme.of(context).hintColor,
                        ),
                        onPressed: () {
                          // Toggle the visibility of the text entry when the icon is clicked
                          toggleTextEntry();
                        },
                      ),
                      if (!isTextEntryVisible)
                        Text(
                          'Add Location',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  if (isTextEntryVisible)
                    Flexible(
                      child: TextField(
                        controller: locationController,
                        decoration: InputDecoration(
                          hintText: 'Location...',
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  if(!_isEditing)
                    IconButton(
                      icon: Icon(
                        isLoved ? Icons.favorite : Icons.favorite_border, // Toggle between filled and outline heart icons
                        size: 32, // Increase the icon size
                        color: isLoved ? Theme.of(context).hintColor : Colors.black, // Change the icon color when loved
                      ),
                      onPressed: () {
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
                    )

                ],
              ),
            ),


            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if(!_isEditing)
                  _buildInfoColumn(
                    label: 'Gender',
                    value:  _userData?['petGender']??'',
                    color: Color(0xFFDDD8AE),
                  ),
                if(_isEditing)
                  _buildInfoColumnEdit(
                    label: 'Gender',
                    color: Color(0xFFDDD8AE),
                    controller: _petGenderController,
                  ),
                if(!_isEditing)
                  _buildInfoColumn(
                    label: 'Age',
                    value:  _userData?['petAge']??'',
                    color: Color(0xFFDDD8AE),
                  ),
                if(_isEditing)
                  _buildInfoColumnEdit(
                    label: 'Age',
                    color: Color(0xFFDDD8AE), controller: _petAgeController,
                  ),
                if(!_isEditing)
                  _buildInfoColumn(
                    label: 'Weight',
                    value: _userData?['petWeight']??'',
                    color: Color(0xFFDDD8AE),
                  ),
                if(_isEditing)
                  _buildInfoColumnEdit(
                    label: 'Weight',
                    color: Color(0xFFDDD8AE), controller: _petWeightController,
                  ),
              ],
            ),
            //if(_isEditing)
            if(!_isEditing)
              SizedBox(height: 46),
            if (!_isEditing)
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        if (_image2 != null && _isEditing)
                          CircleAvatar(
                            radius: 44,
                            backgroundImage: MemoryImage(_image2!),
                          )
                        else
                          CachedNetworkImage(
                            imageUrl: _userImage2Url??
                                'https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg', // Use the image URL from Firestore
                            imageBuilder: (context, imageProvider) => CircleAvatar(
                              radius: 44,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) => CircularProgressIndicator(), // You can use any placeholder widget
                            errorWidget: (context, url, error) => Icon(Icons.error), // You can use any error widget
                          ),
                        if (_isEditing)
                          Positioned(
                            bottom: -10, // Adjust the top position of the button
                            right: -15, // Adjust the right position of the button
                            child: IconButton(
                              onPressed: selectImage2,
                              icon: Icon(
                                Icons.add_a_photo,
                                size: 18,
                              ),
                            ),
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
                              '${_userData?['ownerName']??''}',
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
                        launch('mailto:${_userData?['email']??''}');
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
                        launch('https://www.facebook.com/${_userData?['ownersFb']??''}');
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
            if(_isEditing)
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        if (_image2 != null && _isEditing)
                          CircleAvatar(
                            radius: 44,
                            backgroundImage: MemoryImage(_image2!),
                          )
                        else
                          CircleAvatar(
                            radius: 44,
                            backgroundImage: NetworkImage(_userImage2Url??
                                'https://firebasestorage.googleapis.com/v0/b/petbook-8daf6.appspot.com/o/profileImage?alt=media&token=6033552b-4966-44b4-885c-11c3e742e0aa'), // Use the image URL from Firestore
                          ),
                        if (_isEditing)
                          Positioned(
                            bottom: -10, // Adjust the top position of the button
                            right: -15, // Adjust the right position of the button
                            child: IconButton(
                              onPressed: selectImage2,
                              icon: Icon(
                                Icons.add_a_photo,
                                size: 18,
                              ),
                            ),
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
                            if (_isEditing)
                              TextFormField(
                                controller: _ownerNameController,
                                decoration: InputDecoration(
                                  hintText: 'Owner Name...',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              )
                            else
                              Text(
                                _userData?['ownerName'] ?? '', // Add null check
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),

                            if (_isEditing)
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Email...',
                                ),
                                style: TextStyle(

                                  color: Colors.black,
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () {
                                  launch('mailto:${_userData?['email']??''}');
                                },
                                child: Text(
                                  _userData?['email']??'',
                                  style: TextStyle(
                                    color: Color(0xFF00a19d),
                                  ),
                                ),
                              ),
                            if (_isEditing)
                              TextFormField(
                                controller: _ownersFbController,
                                decoration: InputDecoration(
                                  hintText: 'Facebook...',
                                ),
                                style: TextStyle(

                                  color: Colors.black,
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () {
                                  launch('https://www.facebook.com/${_userData?['ownersFb']??''}');
                                },
                                child: Text(
                                  _userData?['ownersFb']??'',
                                  style: TextStyle(
                                    color: Color(0xFF00a19d),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if(!_isEditing)
              SizedBox(height: 26),
            if(_isEditing)
              SizedBox(height: 16),
            if(!_isEditing)
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
                          'Mark for Adoption',
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
            if(_isEditing)
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
                          'Submit',
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
}


Widget _buildInfoColumnEdit({
  required String label,
  required TextEditingController? controller,
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
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF00a19d),
          ),
        ),
        if (controller != null) TextField(
          controller: controller,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF00a19d),
          ),
        ),
      ],
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
      borderRadius: BorderRadius.circular(10), // Adjust the border radius
    ),
    width: 100, // Set a fixed width
    height: 100, // Set a fixed height
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text(
            ''
        ),
        Text(
          label,
          style: TextStyle(
            color:  Color(0xFFA9ACAD), // Text color
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:  Color(0xFF00a19d), // Text color
          ),
        ),
      ],
    ),
  );
}