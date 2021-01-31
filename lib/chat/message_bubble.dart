import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatefulWidget {
  final Key key;
  final String message;
  final String username;
  final bool isMe;
  final String profilePic;
  final Timestamp messageSentTime;
  final Timestamp lastTimeStamp;
  final String lastUserName;
  final Timestamp nextTimeStamp;

  MessageBubble(
      this.message,
      this.username,
      this.isMe,
      this.profilePic,
      this.messageSentTime,
      this.lastTimeStamp,
      this.lastUserName,
      this.nextTimeStamp,
      {this.key});

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  GlobalKey _key = GlobalKey();

  String _formatTime() {
    var date = widget.messageSentTime.toDate();
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
    if (widget.lastTimeStamp == null) {
      //this is the first message in chat
      return '';
    }

    var date = widget.messageSentTime.toDate();
    var lastDate = widget.lastTimeStamp.toDate();
    var now = DateTime.now();
    var diffDays = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    var lastDiffDays = DateTime(lastDate.year, lastDate.month, lastDate.day)
        .difference(DateTime(now.year, now.month, now.day))
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
    if (widget.nextTimeStamp == null) {
      return false;
    }

    return DateFormat('dd/mm/yyyy HH:mm')
            .format(widget.messageSentTime.toDate()) ==
        DateFormat('dd/mm/yyyy HH:mm').format(widget.nextTimeStamp.toDate());
  }

  final ValueNotifier<double> _rowHeight = ValueNotifier<double>(-1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _rowHeight.value = _key.currentContext.size.longestSide);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
                  widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      key: _key,
                      decoration: BoxDecoration(
                        color: widget.isMe
                            ? Theme.of(context).accentColor
                            : Colors.blue[100],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(widget.isMe ? 12 : 0),
                          bottomRight: Radius.circular(!widget.isMe ? 12 : 0),
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
                      constraints: BoxConstraints(
                          minWidth: widget.isMe
                              ? 0
                              : widget.username.length > 10
                                  ? 80
                                  : 70,
                          maxWidth: 300),
                      padding: EdgeInsets.only(
                        top: !widget.isMe ? 5 : 10,
                        bottom: !widget.isMe ? 5 : 10,
                        left: 15,
                        right: 15,
                      ),
                      margin: EdgeInsets.only(
                        top: widget.isMe ? 4 : 10,
                        left: 8,
                        right: 8,
                        bottom: _sameDatetime() ? 0 : 4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!widget.isMe)
                            FutureBuilder(
                                future: Firestore.instance
                                    .collection('users')
                                    .document(widget.username)
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
                            widget.message,
                            style: TextStyle(
                              color: widget.isMe
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
        ),
        if (!widget.isMe && widget.username != widget.lastUserName)
          ValueListenableBuilder<double>(
              valueListenable: _rowHeight,
              builder: (BuildContext context, double height, Widget child) {
                return Positioned(
                  top: -5,
                  left: _rowHeight.value - 23,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(widget.profilePic),
                  ),
                );
              })
      ],
      overflow: Overflow.visible,
    );
  }
}
