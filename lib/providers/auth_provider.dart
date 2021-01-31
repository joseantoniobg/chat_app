import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider {
  static String username;

  static Future<String> getUsername(String uID) async {
    if (username == null) {
      final data =
          await Firestore.instance.collection('users').document(uID).get();
      username = data['username'];
    }
    return username;
  }
}
