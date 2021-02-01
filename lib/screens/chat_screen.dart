import 'package:chat_app/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../chat/new_message.dart';
import '../chat/messages.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print(msg);
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      print(msg);
      return;
    });
    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthProvider.getUsername(),
        builder: (ctx, user) {
          if (user.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: FittedBox(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(AuthProvider.userProfilePic),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('My chat! - ' + AuthProvider.username),
                  ],
                ),
              ),
              actions: [
                DropdownButton(
                    underline: Container(),
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
                    child: Messages(),
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
        });
  }
}
