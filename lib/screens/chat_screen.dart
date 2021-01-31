import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../chat/new_message.dart';
import '../chat/messages.dart';
import '../config/consts.dart';

class ChatScreen extends StatelessWidget {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My chat!'),
        actions: [
          DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Logout'),
                      ],
                    ),
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              }),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: Messages(),
              ),
            ),
            NewMessage(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () async {
      //     await Firestore.instance.collection(Consts.messagesCollection).add({
      //       'text': 'This was added at ' + DateTime.now().toString(),
      //     });
      //   },
      // ),
    );
  }
}
