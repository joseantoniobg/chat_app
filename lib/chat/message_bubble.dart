import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Key key;
  final String message;
  final String username;
  final bool isMe;
  final Timestamp messageSentTime;
  final Timestamp lastTimeStamp;
  final Timestamp nextTimeStamp;
  MessageBubble(this.message, this.username, this.isMe, this.messageSentTime,
      this.lastTimeStamp, this.nextTimeStamp,
      {this.key});

  String _formatTime() {
    var date = messageSentTime.toDate();
    var now = DateTime.now();
    var diffDays = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;

    if (diffDays == 0) {
      return DateFormat('HH:mm').format(date);
    } else if (diffDays == -1) {
      return 'Yesterday at ' + DateFormat('HH:mm').format(date);
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
  }

  String _timeSeparator() {
    if (lastTimeStamp == null) {
      //this is the first message in chat
      return '';
    }

    var date = messageSentTime.toDate();
    var lastDate = lastTimeStamp.toDate();
    var now = DateTime.now();
    var diffDays = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    var lastDiffDays = DateTime(lastDate.year, lastDate.month, lastDate.day)
        .difference(DateTime(date.year, date.month, date.day))
        .inDays;

    //this message is from today and last message is from at least yesterday
    if (diffDays == 0 && lastDiffDays < 0) {
      return 'Today';
    }
    //this message is from yesterday and last message more antique
    else if (diffDays == -1 && lastDiffDays < -1) {
      return 'Yesterday';
    } else if (diffDays != lastDiffDays) {
      //whenever the date of the last message is in a different day from this message, shows the date of this message
      return DateFormat('dd/MM/yyyy').format(date);
    } else {
      //the messages are in the same date
      return '';
    }
  }

  _sameDatetime() {
    if (nextTimeStamp == null) {
      return false;
    }

    return DateFormat('dd/mm/yyyy HH:mm').format(messageSentTime.toDate()) ==
        DateFormat('dd/mm/yyyy HH:mm').format(nextTimeStamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_timeSeparator() != '')
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            color: Colors.blue[900],
            child: Padding(
                padding: EdgeInsets.all(4),
                child: Text(
                  _timeSeparator(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                )),
          ),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        isMe ? Theme.of(context).accentColor : Colors.blue[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(isMe ? 12 : 0),
                      bottomRight: Radius.circular(!isMe ? 12 : 0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(2, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(minWidth: 10, maxWidth: 200),
                  padding: EdgeInsets.only(
                    top: !isMe ? 5 : 10,
                    bottom: !isMe ? 5 : 10,
                    left: 15,
                    right: 15,
                  ),
                  margin: EdgeInsets.only(
                    top: 4,
                    left: 8,
                    right: 8,
                    bottom: _sameDatetime() ? 0 : 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMe)
                        FutureBuilder(
                            future: Firestore.instance
                                .collection('users')
                                .document(username)
                                .get(),
                            builder: (ctx, userSnap) {
                              return Text(
                                userSnap.connectionState ==
                                        ConnectionState.waiting
                                    ? 'Loading...'
                                    : userSnap.data['username'],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                      Text(
                        message,
                        style: TextStyle(
                          color: isMe
                              ? Theme.of(context)
                                  .accentTextTheme
                                  .headline1
                                  .color
                              : Colors.blue[900],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!_sameDatetime())
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      _formatTime(),
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
