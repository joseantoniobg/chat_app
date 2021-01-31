import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      }

      await Firestore.instance
          .collection('users')
          .document(result.user.uid)
          .setData({
        'username': username,
        'email': email,
      });

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
