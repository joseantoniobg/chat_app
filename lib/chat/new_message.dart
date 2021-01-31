import 'package:chat_app/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _textMessageController = TextEditingController();

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final username = await AuthProvider.getUsername(user.uid);
    Firestore.instance.collection('chats').add({
      'text': _enteredMessage,
      'dateTime': Timestamp.now(),
      'userId': user.uid,
      'username': username,
    });
    _textMessageController.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            decoration: InputDecoration(labelText: 'Send a message...'),
            controller: _textMessageController,
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
