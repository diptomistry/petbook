import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String image;
  final String userID;
  final String text;
  final DateTime time;

  Post({
    required this.image,
    required this.userID,
    required this.text,
    required this.time,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      image: map['image'],
      userID: map['userID'],
      text: map['text'],
      time: (map['time'] as Timestamp).toDate(),
    );
  }
}

class User {
  final String uid;
  final String petName;
  final String petGender;
  final String petAge;
  final String petWeight;
  final String ownerName;
  final String email;
  final String ownersFb;

  User({
    required this.uid,
    required this.petName,
    required this.petGender,
    required this.petAge,
    required this.petWeight,
    required this.ownerName,
    required this.email,
    required this.ownersFb,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['userID'] ?? '',
      petName: data['petName'] ?? '',
      petGender: data['petGender'] ?? '',
      petAge: data['petAge'] ?? '',
      petWeight: data['petWeight'] ?? '',
      ownerName: data['ownerName'] ?? '',
      email: data['email'] ?? '',
      ownersFb: data['ownersFb'] ?? '',
    );
  }
}

class React {
  final String? postID;
  final String? userID;
  final String? comment;
  final bool fav;

  React({
    this.postID,
    this.userID,
    this.comment,
    required this.fav,
  });

  factory React.fromMap(Map<String, dynamic> map) {
    return React(
      postID: map['postID'] as String?,
      userID: map['userID'] as String?,
      comment: map['comment'] as String?,
      fav: map['fav'] as bool? ?? false,
    );
  }
}
