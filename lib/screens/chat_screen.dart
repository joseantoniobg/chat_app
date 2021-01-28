import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My chat!'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) => Container(
          padding: EdgeInsets.all(8),
          child: Text('This works!'),
        ),
        itemCount: 10,
      ),
    );
  }
}
