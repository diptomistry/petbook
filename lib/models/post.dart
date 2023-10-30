import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String image;
  final String userID;
  final String text;
  final DateTime time;
  final String id;
  int reactCount = 0;

  Post({
    required this.image,
    required this.userID,
    required this.text,
    required this.time,
    required this.id,
  });

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
        image: map['image'],
        userID: map['userID'],
        text: map['text'],
        time: (map['time'] as Timestamp).toDate(),
        id: id);
  }
}

class PetUser {
  final String uid;
  final String petName;
  final String petGender;
  final String petAge;
  final String petWeight;
  final String ownerName;
  final String email;
  final String ownersFb;
  final String petPhoto;

  PetUser({
    required this.uid,
    required this.petName,
    required this.petGender,
    required this.petAge,
    required this.petWeight,
    required this.ownerName,
    required this.email,
    required this.ownersFb,
    required this.petPhoto,
  });

  factory PetUser.fromMap(Map<String, dynamic> data) {
    return PetUser(
      uid: data['userID'] ?? '',
      petName: data['petName'] ?? '',
      petGender: data['petGender'] ?? '',
      petAge: data['petAge'] ?? '',
      petWeight: data['petWeight'] ?? '',
      ownerName: data['ownerName'] ?? '',
      email: data['email'] ?? '',
      ownersFb: data['ownersFb'] ?? '',
      petPhoto: data['imageLink'] ??
          'https://www.cdc.gov/healthypets/images/pets/cute-dog-headshot.jpg?_=42445',
    );
  }
}

class React {
  final String? postID;
  final String? userID;
  final bool fav;

  React({
    this.postID,
    this.userID,
    required this.fav,
  });

  factory React.fromMap(Map<String, dynamic> map) {
    return React(
      postID: map['postID'] as String?,
      userID: map['userID'] as String?,
      fav: map['fav'] as bool? ?? false,
    );
  }
}

class Comment {
  final String userID; // User ID of the comment author
  final String text; // Comment text
  final String postID;
  final DateTime timestamp; // ID of the post to which the comment belongs

  Comment({
    required this.userID,
    required this.text,
    required this.postID,
    required this.timestamp, // Add postID to the constructor
  });

  // Factory constructor to create a Comment object from a map
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      userID: map['userID'],
      text: map['text'],
      postID: map['postID'],
      timestamp: map['timestamp'],
    );
  }

  // Convert the Comment object to a map
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'text': text,
      'postID': postID,
      'timestamp': timestamp
    };
  }
}
