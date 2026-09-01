import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../components/helper_functions.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String screen_id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  bool showLoadingIcon = false;
  late String email;
  late String password;
  late bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          color: Colors.yellowAccent,
        ),
        color: Colors.lightBlueAccent,
        inAsyncCall: showLoadingIcon,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  //Do something with the user input. Email
                  email = value;
                },
                decoration: kTextFieldDecoration,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: passwordVisible,
                onChanged: (value) {
                  //Do something with the user input. Password
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                title: 'Log In',
                onPressed: () async {
                  //Implement Login Functionality here
                  try {
                    setState(() {
                      showLoadingIcon = true;
                    });
                    final existingUser =
                        await _auth.signInWithEmailAndPassword(
                            email: email, password: password);

                    if (existingUser != null) {
                      //showing loading Icon

                      //Showing notification
                      authNotificationHelper(context,
                          title: 'Welcome Back',
                          message: 'Login Was Successful',
                          contentType: ContentType.success);

                      //once successful pushing the users to the next screen
                      Navigator.pushNamed(
                          context, ChatScreen.screen_id);
                    }
                  } catch (e) {
                    print(e);
                    authNotificationHelper(context,
                        title: 'Error!',
                        message: 'Invalid Email or Password',
                        contentType: ContentType.failure);
                  }
                  setState(() {
                    showLoadingIcon = false;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
