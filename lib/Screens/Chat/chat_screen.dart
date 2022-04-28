import 'dart:developer';

import 'package:chat_using_firebase/constant/color_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../model/UserModel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {Key? key, required this.userModel, required this.currentUser})
      : super(key: key);
  final UserModel userModel;
  final User currentUser;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool connectedServer = false;
  var messageBodyController = TextEditingController();
  String? groupChatId;
  dynamic chatStream;
  bool isSelectedChat = false;
  int selectedIndex = 0;
  List<String> selectedChatDocIdList = [];
  bool isShowSendMessageButton = false;

  @override
  void initState() {
    if (widget.currentUser.hashCode <= widget.userModel.hashCode) {
      groupChatId =
          "${widget.userModel.uid}-${FirebaseAuth.instance.currentUser?.uid.toString()}";
    } else {
      groupChatId =
          "${FirebaseAuth.instance.currentUser?.uid.toString()}-${widget.userModel.uid}";
    }
    chatStream = streamBuild();
    super.initState();
  }

  _chatBubble(String message, bool isMe, bool isSameUser) {
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 8),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          getTimeFormMillis(212152412),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      getTimeFormMillis(212152412),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // !isSameUser
          //     ? Row(
          //         children: <Widget>[
          //           // Container(
          //           //   decoration: BoxDecoration(
          //           //     shape: BoxShape.circle,
          //           //     boxShadow: [
          //           //       BoxShadow(
          //           //         color: Colors.grey.withOpacity(0.5),
          //           //         spreadRadius: 2,
          //           //         blurRadius: 5,
          //           //       ),
          //           //     ],
          //           //   ),
          //           //   child: const CircleAvatar(
          //           //     radius: 15,
          //           //     backgroundImage:
          //           //         AssetImage("assets/images/contact.jpeg"),
          //           //   ),
          //           // ),
          //           // const SizedBox(
          //           //   width: 10,
          //           // ),
          //           Text(
          //             getTimeFormMillis(12365421),
          //             style: const TextStyle(
          //               fontSize: 12,
          //               color: Colors.black45,
          //             ),
          //           ),
          //         ],
          //       )
          //     : Container(
          //         child: null,
          //       ),
        ],
      );
    }
  }

  _sendMessageArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.tag_faces,
                    ),
                    iconSize: 25,
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    onPressed: () async {},
                  ),
                  Expanded(
                    child: IntrinsicWidth(
                      child: TextField(
                        controller: messageBodyController,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Send a message..',
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (value) {
                          if (value.isNotEmpty && value.length > 0) {
                            setState(() {
                              isShowSendMessageButton = true;
                            });
                          } else {
                            setState(() {
                              isShowSendMessageButton = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.attach_file,
                      color: wcAppThemeColor,
                    ),
                    // iconSize: 25,
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    onPressed: () async {
                      if (messageBodyController.text.isEmpty) {
                        return;
                      }
                      sendMessage();
                    },
                  ),
                  Visibility(
                    visible: isShowSendMessageButton ? false : true,
                    child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: wcAppThemeColor,
                        child: Icon(
                          FontAwesomeIcons.indianRupeeSign,
                          color: Colors.white,
                          size: 15,
                        )),
                  ),
                  Visibility(
                    visible: isShowSendMessageButton ? false : true,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.camera,
                          color: Theme.of(context).appBarTheme.backgroundColor,
                        )),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: wcAppThemeColor,
              child: IconButton(
                  onPressed: () {
                    if (isShowSendMessageButton) {
                      sendMessage();
                    }
                  },
                  icon: Icon(
                    isShowSendMessageButton ? Icons.send : Icons.mic,
                    color: Colors.white,
                  )),
            ),
          )
        ],
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
        centerTitle: false,
        leadingWidth: 40,
        title: isSelectedChat
            ? Text(
                selectedChatDocIdList.length.toString(),
                style: const TextStyle(color: Colors.white),
              )
            : Row(
                children: [
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
                      backgroundColor: wcAppThemeColor,
                      backgroundImage: AssetImage("assets/images/contact.jpeg"),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.userModel.displayName!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Offline',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              if (isSelectedChat) {
                setState(() {
                  isSelectedChat = false;
                  selectedChatDocIdList = [];
                });
              } else {
                Navigator.pop(context);
              }
            }),
        actions: [
          Padding(
            padding: EdgeInsets.all(20.h),
            child: const Icon(FontAwesomeIcons.video),
          ),
          Padding(
            padding: EdgeInsets.all(20.h),
            child: const Icon(Icons.call),
          ),
          Padding(
            padding: EdgeInsets.all(20.h),
            child: const Icon(FontAwesomeIcons.ellipsisVertical),
          )
        ],
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
              stream: chatStream,
              builder: (BuildContext context, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (streamSnapshot.hasError) {
                  return Text("Some Error occur=>${streamSnapshot.error}");
                } else {
                  return ListView.builder(
                    reverse: true,
                    itemCount: streamSnapshot.data?.size,
                    itemBuilder: (BuildContext context, int index) {
                      var v = streamSnapshot.data?.docs[index];
                      // final Message message = v!["messageText"];
                      final bool isMe = widget.userModel.uid == v!["sendBy"];
                      final bool isSameUser = prevUserId == 32165141615;
                      prevUserId = 12362;
                      return InkWell(
                          onLongPress: () {
                            setState(() {
                              isSelectedChat = true;
                              selectedIndex = index;
                              if (selectedChatDocIdList
                                  .contains(selectedIndex.toString())) {
                                selectedChatDocIdList
                                    .remove(selectedIndex.toString());
                              } else {
                                selectedChatDocIdList
                                    .add(selectedIndex.toString());
                              }
                            });
                          },
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              if (selectedChatDocIdList
                                  .contains(selectedIndex.toString())) {
                                selectedChatDocIdList
                                    .remove(selectedIndex.toString());
                              } else {
                                selectedChatDocIdList
                                    .add(selectedIndex.toString());
                              }
                            });
                          },
                          child: Container(
                            color: isSelectedChat &&
                                    selectedChatDocIdList
                                        .contains(index.toString())
                                ? Colors.black12
                                : null,
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child:
                                _chatBubble(v["messageText"], isMe, isSameUser),
                          ));
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

  streamBuild() {
    return FirebaseFirestore.instance
        .collection("message/$groupChatId/messages")
        .orderBy("sendAt", descending: true)
        .snapshots();
  }

  sendMessage() {
    try {
      FirebaseFirestore.instance
          .collection("message/$groupChatId/messages")
          .doc()
          .set({
        "messageText": messageBodyController.text,
        "sendBy": widget.userModel.uid,
        "sendAt": DateTime.now()
      });
      messageBodyController.clear();
      setState(() {
        isShowSendMessageButton = false;
      });
    } on PlatformException catch (e) {
      log("Exception while send message::$e");
      // Some error occured, look at the exception message for more details
    }
  }
}
