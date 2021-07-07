import 'package:chat_app_youtube/UI/auth/loginScreen.dart';
import 'package:chat_app_youtube/constant.dart';
import 'package:chat_app_youtube/helper/profile.dart';
import 'package:chat_app_youtube/provider/chatMessageProvider.dart';
import 'package:chat_app_youtube/provider/userRelatedTask.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Chat/chatScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedScreen = 0;

  List screens = [
    LoginScreen(),
    ChatScreen(),
  ];

  void checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    if (uid != null) {
      setState(() {
        selectedScreen = 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserRelatedTasks(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatMessageProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: darkThemeData(context),
        home: screens[selectedScreen],
      ),
    );
  }
}
