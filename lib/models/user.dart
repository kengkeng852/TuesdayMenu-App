import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String username;
  List<String> savedRestaurants;

  User({required this.uid, required this.username, required this.savedRestaurants});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      username: data['username'] ?? '', 
      savedRestaurants: data['savedRes']?.cast<String>() ?? [], 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'savedRestaurants': savedRestaurants, 
    };
  }

   static User empty() {
    return User(
      uid: '', 
      username: 'Guest',
      savedRestaurants: [],
    );
  }
}
