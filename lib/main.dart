import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.screen_id,
      routes: {
        WelcomeScreen.screen_id: (context) => WelcomeScreen(),
        LoginScreen.screen_id: (context) => LoginScreen(),
        RegistrationScreen.screen_id: (context) =>
            RegistrationScreen(),
        ChatScreen.screen_id: (context) => ChatScreen()
      },
    );
  }
}
