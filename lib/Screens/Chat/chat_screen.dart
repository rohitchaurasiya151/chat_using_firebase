import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  // final QBDialog dialog;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<String> messageList = ["efref", "sdfsf", "asdesdfr"];
  bool connectedServer = false;
  var messageBodyController = TextEditingController();

  @override
  void initState() {
    log("chat screen init called");
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
                maxWidth: MediaQuery.of(context).size.width * 0.80,
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
                maxWidth: MediaQuery.of(context).size.width * 0.80,
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
              color: Theme.of(context).primaryColor,
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
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                log("messageBody::${messageBodyController.text}");
                try {
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
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: [
              TextSpan(
                  text: "Sdfsgdf",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(text: '\n'),
              /* widget.user.isOnline
                  ? TextSpan(
                      text: 'Online',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : */
              TextSpan(
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
              child: (messageList != null)
                  ? ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(20),
                      itemCount: messageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        // final Message message = messages[index];
                        const bool isMe = 122430715 == 21151141541;
                        final bool isSameUser = prevUserId == 32165141615;
                        prevUserId = 12362;
                        return _chatBubble(
                            messageList[index], isMe, isSameUser);
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
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
