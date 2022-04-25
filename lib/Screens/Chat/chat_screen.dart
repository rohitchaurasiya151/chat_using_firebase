import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../model/UserModel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.userModel,required this.currentUser}) : super(key: key);
  final UserModel userModel;
  final User currentUser;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool connectedServer = false;
  var messageBodyController = TextEditingController();
  String? groupChatId;

  @override
  void initState() {
    if(widget.currentUser.hashCode<=widget.userModel.hashCode){
      groupChatId = "${widget.userModel.uid}-${FirebaseAuth.instance.currentUser?.uid.toString()}";
    }
    else {
      groupChatId = "${FirebaseAuth.instance.currentUser?.uid.toString()}-${widget.userModel.uid}";

    }

    super.initState();
  }

  _chatBubble(String message, bool isMe, bool isSameUser) {
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width * 0.80,
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                getTimeFormMillis(212152412),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 15,
                  backgroundImage:
                  AssetImage("assets/images/contact.jpeg"),
                ),
              ),
            ],
          )
              : Container(
            child: null,
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width * 0.80,
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 15,
                  backgroundImage:
                  AssetImage("assets/images/contact.jpeg"),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                getTimeFormMillis(12365421),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          )
              : Container(
            child: null,
          ),
        ],
      );
    }
  }

  _sendMessageArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.photo),
              iconSize: 25,
              color: Theme
                  .of(context)
                  .primaryColor,
              onPressed: () async {},
            ),
            Expanded(
              child: TextField(
                controller: messageBodyController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message..',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              iconSize: 25,
              color: Theme
                  .of(context)
                  .primaryColor,
              onPressed: () async {
                log("messageBody::${messageBodyController.text}");

                try {
                  FirebaseFirestore.instance
                      .collection(
                      "message/$groupChatId/messages")
                      .doc()
                      .set({
                    "messageText": messageBodyController.text,
                    "sendBy": widget.userModel.uid,
                    "sendAt": DateTime.now()
                  });
                  messageBodyController.clear();
                } on PlatformException catch (e) {
                  log("Exception while send message::$e");
                  // Some error occured, look at the exception message for more details
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Future<List<String>> fetchChatHistory() async {
  //   try {
  //     List<QBMessage> messages =
  //         await QB.chat.getDialogMessages(widget.dialog.id, markAsRead: true);
  //     //sorting dcsending order
  //     messages.sort((a, b) => b.dateSent.compareTo(a.dateSent));
  //
  //     return messages;
  //   } on PlatformException catch (e) {
  //     print(e);
  //     // Some error occured, look at the exception message for more details
  //   }
  //   return [];
  // }

  @override
  Widget build(BuildContext context) {
    int prevUserId = 112132424;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: widget.userModel.displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              const TextSpan(text: '\n'),
              /* widget.user.isOnline
                  ? TextSpan(
                      text: 'Online',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : */
              const TextSpan(
                text: 'Offline',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/chat_background.jpg"),
                fit: BoxFit.cover),
            color: Colors.orange),
        child: Column(
          children: <Widget>[
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("message/$groupChatId/messages")
                      .orderBy("sendAt", descending: true)
                      .snapshots(),
                  builder: (BuildContext context, streamSnapshot) {
                    if (streamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (streamSnapshot.hasError) {
                      return Text("Some Error occur=>${streamSnapshot.error}");
                    } else {
                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(20),
                        itemCount: streamSnapshot.data?.size,
                        itemBuilder: (BuildContext context, int index) {
                          var v = streamSnapshot.data?.docs[index];
                          // final Message message = v!["messageText"];
                          final bool isMe = widget.userModel.uid ==
                              v!["sendBy"];
                          final bool isSameUser = prevUserId == 32165141615;
                          prevUserId = 12362;
                          return _chatBubble(v["messageText"], isMe,
                              isSameUser);
                        },
                      );
                    }
                  },
                )),
            _sendMessageArea(),
          ],
        ),
      ),
    );
  }

  String getTimeFormMillis(int dateSent) {
    DateTime date = DateTime.now();
    if (dateSent > 0) {
      date = DateTime.fromMillisecondsSinceEpoch(dateSent);
    }
    // log("${date.hour}:${date.minute}");
    String formattedTime = DateFormat('hh:mm:a').format(date);
    return formattedTime;
  }

  @override
  void dispose() {
    log("chat screen dispose called");
    super.dispose();
  }
}
