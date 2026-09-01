import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
//Step1: import the authentication package
import 'package:firebase_auth/firebase_auth.dart';
import '../components/helper_functions.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String screen_id = 'registration_screen';

  @override
  _RegistrationScreenState createState() =>
      _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Step2: creating a new authentication instance
  final _auth = FirebaseAuth.instance; // it's a static instant

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
                textAlign: TextAlign.left,
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
                textAlign: TextAlign.left,
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
                color: Colors.blueAccent,
                title: 'Register',
                onPressed: () async {
                  //Step 3 : creating user with email and password ( this returns a future so we capture it in a final variable
                  // and because we don't wanna skip this part we must use await in async
                  try {
                    setState(
                      () {
                        showLoadingIcon = true;
                      },
                    );
                    final newUser =
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);

                    //showing the loading
                    if (newUser != null) {
                      //showing message that account created
                      authNotificationHelper(context,
                          title: 'Congratulations',
                          message: 'Your Account Has Been Created',
                          contentType: ContentType.success);
                      //if no problem move the user to chat_screen once registered
                      Navigator.pushNamed(
                          context, ChatScreen.screen_id);
                    }
                  } on FirebaseAuthException catch (e) {
                    //firebase special error with pop up notification
                    authNotificationHelper(context,
                        title: 'Invalid Details',
                        message: e.code,
                        contentType: ContentType.warning);
                  } catch (e) {
                    //general Dart error
                    print('$e');

                    setState(() {
                      showLoadingIcon = false;
                    });
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
