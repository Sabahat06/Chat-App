import 'package:chat_app_youtube/constant.dart';
import 'package:chat_app_youtube/helper/chatMessage.dart';
import 'package:chat_app_youtube/message/component/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  final uid, peerProfile;
  const Body({Key? key, required this.uid, required this.peerProfile})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController msgController = TextEditingController();

  var groupChatId = '';

  readLocals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    var peerUid = widget.uid;

    if (uid.hashCode <= peerUid.hashCode) {
      groupChatId = '$uid-$peerUid';
    } else {
      groupChatId = '$peerUid-$uid';
    }
    setState(() {});
  }

  void sentMessage(String content) async {
    msgController.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    var peerUid = widget.uid;

    var documentRefrence = FirebaseFirestore.instance
        .collection('Messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentRefrence, {
        'idFrom': uid,
        'idTo': peerUid,
        'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'content': content,
        'type': '----'
      });
    });
  }

  @override
  void initState() {
    super.initState();
    readLocals();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Messages')
              .doc(groupChatId)
              .collection(groupChatId)
              .orderBy('timestamp', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    var msg = snapshot.data?.docs[index];
                    var peeruid = widget.uid;
                    return Message(
                      profile: widget.peerProfile,
                      message: ChatMessage(
                          messageType: 'text',
                          messageStatus: '',
                          isSender:
                              msg?.get('idFrom') != peeruid ? true : false,
                          text: '${msg?.get("content")}'),
                    );
                  });
            } else {
              return Center(
                child: Text('Loading...'),
              );
            }
          },
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 32,
              color: Color(0xFF087949).withOpacity(0.08),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Icon(
                Icons.sentiment_satisfied_alt_outlined,
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.64),
              ),
              SizedBox(
                width: kDefaultPadding / 4,
              ),
              Expanded(
                child: TextField(
                  onSubmitted: (value) {
                    sentMessage(value);
                  },
                  controller: msgController,
                  decoration: InputDecoration(
                    hintText: 'Type message',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Icon(
                Icons.attach_file,
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.64),
              ),
              SizedBox(
                width: kDefaultPadding / 4,
              ),
              Icon(
                Icons.camera_alt_outlined,
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.64),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
