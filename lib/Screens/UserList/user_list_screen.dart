import 'dart:developer';

import 'package:chat_using_firebase/model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../Chat/chat_screen.dart';

class UsersList extends StatefulWidget {
  final String? searchString;

  const UsersList({Key? key, this.searchString}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool isShowSearchBar = false;
  late User currentUser ;
   List<String> qbUserList = [
    "rohit",
    "subham",
    "manish",
    "kavita",
    "nikhil",
    "nidhi"
  ];

  // List<QBUser> qbUserListforDisplay;
  // QBDialog createdDialog;

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: searchBar(),
          backgroundColor: isShowSearchBar ? Colors.white : null,
          elevation: 0,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, streamSnapshot) {
            // var user = streamSnapshot.data?.docs.map((doc) => UserModel.fromDocumentSnapshot(doc)).toList();

            if(streamSnapshot.connectionState == ConnectionState.waiting)
              {
                return const Center(child: CircularProgressIndicator(),);
              }
            List<UserModel>? users = streamSnapshot.data?.docs
                .map((docSnapshot) =>
                    UserModel.fromDocumentSnapshot(docSnapshot))
                .toList();
            return ListView.builder(
              itemCount: users?.length,
              itemBuilder: (BuildContext ctx, int index) {
                if(users![index].uid == currentUser.uid){
                  return const SizedBox();
                }
                return UserListTileWidget(userModel: users[index]);
              },
            );
          },
        ));
  }

  searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (isShowSearchBar)
            ? Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: "Search...",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      )),
                  onChanged: (searchQuery) {
                    setState(() {
                      searchQuery = searchQuery.toLowerCase();
                    });
                  },
                ),
              )
            : const Text("MyChat"),
        InkWell(
            onTap: () {
              setState(() {
                isShowSearchBar = !isShowSearchBar;
              });
            },
            child: Icon(
              isShowSearchBar ? Icons.close : Icons.search,
              color: isShowSearchBar ? Colors.grey : Colors.white,
            ))
      ],
    );
  }
}

class UserListTileWidget extends StatelessWidget {
  const UserListTileWidget({
    Key? key,
    required this.userModel,
  }) : super(key: key);
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          // Get.pu(
          //     MaterialPageRoute(builder: (_) => const ChatScreen()));
          Get.to(() =>  ChatScreen(userModel: userModel,currentUser: FirebaseAuth.instance.currentUser!,));
        } on PlatformException catch (e) {
          log("sdfcsfg");
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.h,
          vertical: 15.h,
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(2),
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
                radius: 25,
                backgroundImage: AssetImage("assets/images/contact.jpeg"),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              padding: const EdgeInsets.only(
                left: 20,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children:  <Widget>[
                          Text(
                          userModel.displayName!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          /*Container(
                            margin: const EdgeInsets.only(left: 5),
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange,
                            ),
                          )*/
                        ],
                      ),
                    ],
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
