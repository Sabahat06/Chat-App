import 'package:chat_app_youtube/Chat/components/chatCard.dart';
import 'package:chat_app_youtube/constant.dart';
import 'package:chat_app_youtube/helper/profile.dart';
import 'package:chat_app_youtube/message/messageScreen.dart';
import 'package:chat_app_youtube/provider/chatMessageProvider.dart';
import 'package:chat_app_youtube/provider/userRelatedTask.dart';
import 'package:chat_app_youtube/widgets/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int selectedIndex = 1;
  List<Profile> allUser = [];

  @override
  void initState() {
    super.initState();
    Provider.of<UserRelatedTasks>(context, listen: false).getProfileData();
    Provider.of<ChatMessageProvider>(context, listen: false).getAllChatUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    allUser = Provider.of<ChatMessageProvider>(context).getAllUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
                kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
            color: kPrimaryColor,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: allUser.length,
                itemBuilder: (context, index) {
                  return ChatCard(
                    person: allUser[index],
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessageScreen(
                                  profile: allUser[index].profilePic,
                                  name: allUser[index].name,
                                  uid: allUser[index].uid,
                                )),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(selectedIndex, context),
    );
  }
}
