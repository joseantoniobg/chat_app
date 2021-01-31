import 'dart:io';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  Future<bool> _submitAuthForm(
    String email,
    String username,
    String password,
    bool isLogin,
    File userPic,
    BuildContext ctx,
  ) async {
    AuthResult result;
    try {
      if (isLogin) {
        result = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        AuthProvider.id = result.user.uid;
        AuthProvider.lastId = result.user.uid;
        AuthProvider.username = username;

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(result.user.uid + '.jpg');

        await ref.putFile(userPic).onComplete;

        final url = await ref.getDownloadURL();

        AuthProvider.userProfilePic = url;

        await Firestore.instance
            .collection('users')
            .document(result.user.uid)
            .setData({
          'username': username,
          'email': email,
          'profilePic': url,
        });
      }

      return true;
    } on PlatformException catch (err) {
      var message = 'An error occured. Please check your credentials.';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      throw err;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm),
    );
  }
}
