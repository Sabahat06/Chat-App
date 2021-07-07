import 'package:chat_app_youtube/Chat/chatScreen.dart';
import 'package:chat_app_youtube/helper/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRelatedTasks with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  var smsVerificationId;

  Profile userInfo = Profile(profilePic: '', name: '');
  get getUserInfo => userInfo;

  Future otpVerification(String phoneNumber, context) async {
    Firebase.initializeApp();
    phoneNumber = "+92" + phoneNumber;
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (authCredentials) =>
            _verificationCompleted(authCredentials, context, phoneNumber),
        verificationFailed: (authException) =>
            _verificationFailed(authException),
        codeSent: (verificationId, [code]) =>
            _smsCodeSent(verificationId, [code]),
        codeAutoRetrievalTimeout: (verificationId) =>
            _codeAutoRetrivalTimeout(verificationId));
  }

  _codeAutoRetrivalTimeout(verificationId) {
    smsVerificationId = verificationId;
  }

  _smsCodeSent(verificationId, code) {
    smsVerificationId = verificationId;
  }

  _verificationFailed(FirebaseAuthException authException) {
    print('------' + authException.toString());
  }

  _verificationCompleted(AuthCredential authCredentials, BuildContext context,
      String phoneNumber) async {
    var user = await auth
        .signInWithCredential(authCredentials)
        .then((value) => value.user);
    if (user != null) {
      loginUser(user.uid, phoneNumber, context);
    }
  }

  signInWithOtp(smsCode, phoneNumber, context) async {
    AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: smsVerificationId, smsCode: smsCode);
    var user = await auth
        .signInWithCredential(authCredential)
        .then((value) => value.user);
    if (user != null) {
      loginUser(user.uid, phoneNumber, context);
    }
  }

  loginUser(uid, phoneNumber, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);

    var alreadyUser;

    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) => alreadyUser = value.data());
    final DateTime now = DateTime.now();

    //Create New User
    if (alreadyUser == null) {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .set({'uid': uid, 'Name': '', 'ProfilePic': '', 'date': now});
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ChatScreen()));
  }

  getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    var data;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) => data = value.data());

    userInfo = Profile(
      name: data['Name'],
      phoneNumber: data['PhoneNumber'],
      profilePic: data['ProfilePic'],
    );
    notifyListeners();
  }
}
