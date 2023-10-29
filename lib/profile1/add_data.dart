import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveData({
    required String userEmail,
    required Uint8List file1, // First image
    required Uint8List file2,
    required String petName,
    required String petGender,
    required String petAge,
    required String petWeight,
    //required String email,
    required String ownersFb,
    required String ownerName,// Second image
  }) async {
    try {
      // Upload the first image
      String imageUrl = await uploadImageToStorage('profileImage1', file1);

      // Upload the second image
      String imageUrl2 = await uploadImageToStorage('profileImage2', file2);

      // Query Firestore to find the document with a matching email
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      // Check if a document was found
      if (querySnapshot.docs.isNotEmpty) {
        // Update the existing document with the imageLink fields
        DocumentReference docRef = querySnapshot.docs.first.reference;
        await docRef.update({
          'petName': petName,
          'imageLink': imageUrl,
          'imageLink2': imageUrl2,
          'petGender': petGender,
           'petAge':petAge,
          'petWeight':petWeight,
          //'email':email,
          'ownersFb':ownersFb,
          'ownerName':ownerName,




        });

      }
    } catch (err) {
      print(err.toString());
    }
  }
}

//   Future<void> saveData({
//     required String userEmail,
//     required Uint8List file,
//   }) async {
//     try {
//       String imageUrl = await uploadImageToStorage('profileImage', file);
//
//       // Query Firestore to find the document with a matching email
//       QuerySnapshot querySnapshot = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: userEmail)
//           .get();
//
//       // Check if a document was found
//       if (querySnapshot.docs.isNotEmpty) {
//         // Update the existing document with the imageLink field
//         DocumentReference docRef = querySnapshot.docs.first.reference;
//         await docRef.update({'imageLink': imageUrl});
//       }
//     } catch (err) {
//       print(err.toString());
//     }
//   }
// }
/*
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName,Uint8List file) async {
    Reference ref = _storage.ref().child('profileImage');
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({
    // required String name,
    // required String bio,
    required Uint8List file,
  }) async {
    String resp = " Some Error Occurred";
    try{
      //if(name.isNotEmpty || bio.isNotEmpty) {
      String imageUrl = await uploadImageToStorage('profileImage', file);
      await _firestore.collection('users').add({
        // 'name': name,
        // 'bio': bio,
        'imageLink': imageUrl,
      });

      resp = 'success';
      //}
    }
    catch(err){
      resp =err.toString();
    }
    return resp;
  }
}

 */

