import 'package:chat_app_youtube/Chat/chatScreen.dart';
import 'package:chat_app_youtube/constant.dart';
import 'package:chat_app_youtube/provider/userRelatedTask.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  bool otpSent = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          height: size.height * 0.3,
          width: size.width * 0.8,
          decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2)]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              otpSent
                  ? PinCodeTextField(
                      onDone: (value) async {
                        await Provider.of<UserRelatedTasks>(context,
                                listen: false)
                            .signInWithOtp(
                                value, phoneController.text, context);
                        // print(value);
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ChatScreen()));
                      },
                      pinBoxColor: Colors.white,
                      pinBoxHeight: size.height * 0.06,
                      pinBoxWidth: size.width * 0.1,
                      defaultBorderColor: Colors.white,
                      pinTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        shadows: [
                          BoxShadow(color: Colors.white, blurRadius: 2)
                        ],
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 15),
                          labelText: 'Phone Number',
                          prefix: Text("+92"),
                        ),
                      ),
                    ),
              // ignore: deprecated_member_use
              !otpSent
                  ? FlatButton(
                      onPressed: () async {
                        setState(() {
                          otpSent = true;
                        });
                        await Provider.of<UserRelatedTasks>(context,
                                listen: false)
                            .otpVerification(phoneController.text, context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 15),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Color(0xffF9991A),
                    )
                  : FlatButton(
                      onPressed: () {
                        phoneController.clear();
                        setState(() {
                          otpSent = false;
                        });
                      },
                      child: Text(
                        'Try Again',
                        style: TextStyle(fontSize: 15),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Color(0xffF9991A),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
