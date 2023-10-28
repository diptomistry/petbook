import 'dart:developer';

//import 'package:petbook/common/models/user_model.dart'; // Import your UserModel definition
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petbook/common/modelss/user_model.dart';

final contactsRepositoryProvider = Provider(
      (ref) {
    return ContactsRepository(firestore: FirebaseFirestore.instance);
  },
);

class ContactsRepository {
  final FirebaseFirestore firestore;

  ContactsRepository({required this.firestore});

  Future<List<UserModel>> getFirebaseContacts() async {
    List<UserModel> firebaseContacts = [];
    //print("hello");
    try {
      final userCollection = await firestore.collection('userss').get();
      for (var firebaseContactData in userCollection.docs) {
        var firebaseContact = UserModel.fromMap(firebaseContactData.data());
        firebaseContacts.add(firebaseContact) ;
      }
    } catch (e) {
      log(e.toString());
    }
    return firebaseContacts;
  }
}
