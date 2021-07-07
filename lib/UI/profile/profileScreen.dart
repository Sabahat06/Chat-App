import 'package:chat_app_youtube/UI/auth/loginScreen.dart';
import 'package:chat_app_youtube/helper/profile.dart';
import 'package:chat_app_youtube/provider/userRelatedTask.dart';
import 'package:chat_app_youtube/widgets/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 3;

  Profile userInfo = Profile(profilePic: '', name: '');

  @override
  void didChangeDependencies() {
    userInfo = Provider.of<UserRelatedTasks>(context).getUserInfo;
    super.didChangeDependencies();
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            Row(
              children: [
                Container(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('${userInfo.profilePic}'),
                    child: Stack(
                      children: [
                        Positioned(
                          left: size.width * 0.17,
                          top: size.height * 0.05,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.edit),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "${userInfo.name}",
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "${userInfo.phoneNumber}",
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.redAccent,
                  onPressed: () {
                    logOut();
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Color(0xffF9991A),
                  onPressed: () {},
                  child: Text(
                    "Update",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(selectedIndex, context),
    );
  }
}
