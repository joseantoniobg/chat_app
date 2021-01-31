import 'package:firebase_auth/firebase_auth.dart';

import '../chat/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chats')
              .orderBy('dateTime', descending: true)
              .snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemBuilder: (ctx, index) => MessageBubble(
                chatDocs[index]['text'],
                chatDocs[index]['userId'],
                chatDocs[index]['userId'] == userSnapshot.data.uid,
                chatDocs[index]['dateTime'],
                index < chatDocs.length - 1
                    ? chatDocs[index + 1]['dateTime']
                    : null,
                index > 0 ? chatDocs[index - 1]['dateTime'] : null,
                key: ValueKey(chatDocs[index].documentID),
              ),
              itemCount: chatDocs.length,
            );
          },
        );
      },
    );
  }
}
