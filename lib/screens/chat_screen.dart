import 'package:chat_app/config/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
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
      body: StreamBuilder(
          stream: Firestore.instance
              .collection(Consts.messagesCollection)
              .snapshots(),
          builder: (ctx, snap) {
            final docs = snap.data.documents;
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemBuilder: (ctx, i) => Container(
                padding: EdgeInsets.all(8),
                child: Text(docs[i]['text']),
              ),
              itemCount: docs.length,
            );
          }),
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
