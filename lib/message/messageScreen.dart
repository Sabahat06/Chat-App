import 'package:chat_app_youtube/constant.dart';
import 'package:chat_app_youtube/message/component/body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageScreen extends StatefulWidget {
  String name, uid, profile;
  MessageScreen({Key? key, this.name = '', this.uid = '', this.profile = ''})
      : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            BackButton(),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.profile),
            ),
            SizedBox(
              width: kDefaultPadding * 0.75,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.name}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Active 3m ago',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.local_phone)),
          IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
          SizedBox(
            width: kDefaultPadding / 2,
          )
        ],
      ),
      body: Body(
        uid: widget.uid,
        peerProfile: widget.profile,
      ),
    );
  }
}
