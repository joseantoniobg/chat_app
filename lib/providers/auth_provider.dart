import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider {
  static String username;
  static String userProfilePic;
  static String id;
  static String lastId = '';

  static Future<String> getUsername() async {
    if (username == null || id != lastId) {
      final data =
          await Firestore.instance.collection('users').document(id).get();
      username = data['username'];
      userProfilePic = data['profilePic'];
      lastId = id;
    }
    return username;
  }
}
