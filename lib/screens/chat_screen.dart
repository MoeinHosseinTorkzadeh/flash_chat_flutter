import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//creating instance of firestore
final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String screen_id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  late String messageText;
  final messageTextController =
      TextEditingController(); //used to clear textField

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    print(loggedInUser.email);
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }

  // void messagesStream() async {
  //   //_firestore.collection('messages').snapshots() it will give us a stream of messages
  //   // Gives A Query Snapshot object containing all documents within that collection
  //   // The function is used to listen to real-time database changes
  //   await for (var snapshot
  //       in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message['text']);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              //Implement logout functionality
              try {
                _auth.signOut();
                authNotificationHelper(context,
                    title: 'Sing Out',
                    message: 'User successfully signed out',
                    contentType: ContentType.warning);
                Navigator.pop(context);
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      //controls the text field with messageTextController
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      //Implement send functionality.
                      //messageText + senderEmail
                      //adding data to a collection
                      _firestore.collection('messages').add(
                        {
                          'text': messageText,
                          'sender': loggedInUser.email,
                          'timestamp': FieldValue.serverTimestamp()
                        },
                      );
                    },
                    child: Container(
                        padding: EdgeInsets.all(4.5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(19.0),
                        ),
                        child: Text('Send',
                            style: kSendButtonTextStyle)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //by using ! we are garentueeing dart it is not null
          final messages = snapshot.data!
              .docs; //gives us a list of messages as QuerySnapShot

          List<MessageBubble> messageBubblesList = [];

          //looping through that QuerySnapShot items and adding it to the empty list
          for (var message in messages) {
            final messageText = message['text'];
            final messageSender = message['sender'];

            final currentUser = loggedInUser
                .email; //email the user who is logged in currently

            final messageBubble = MessageBubble(
                sender: messageSender,
                text: messageText,
                isTheCurrentUser: currentUser == messageSender);
            messageBubblesList.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 20.0),
              children: messageBubblesList,
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlue,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.sender,
      required this.text,
      required this.isTheCurrentUser});

  final String sender;
  final String text;
  final bool isTheCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isTheCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: isTheCurrentUser
                    ? Radius.circular(30.0)
                    : Radius.circular(0),
                bottomRight: Radius.circular(30.0),
                topRight: isTheCurrentUser
                    ? Radius.circular(0)
                    : Radius.circular(30)),
            color: isTheCurrentUser
                ? Colors.lightBlueAccent
                : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 20.0),
              child: Text(
                '${text}',
                style: TextStyle(
                    fontSize: 15.0,
                    color: isTheCurrentUser
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
