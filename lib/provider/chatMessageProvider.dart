import 'package:chat_app_youtube/helper/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessageProvider with ChangeNotifier {
  List<Profile> allUsers = [];
  get getAllUser => allUsers;

  Future getAllChatUser() async {
    allUsers = [];

    List data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    await FirebaseFirestore.instance.collection('user').get().then((value) {
      data = value.docs;
      data.forEach((element) {
        if (element['uid'] != uid) {
          allUsers.add(Profile(
            name: element['Name'],
            phoneNumber: element['PhoneNumber'],
            profilePic: element['ProfilePic'],
            uid: element['uid'],
          ));
        }
      });
    });
    notifyListeners();
  }
}
