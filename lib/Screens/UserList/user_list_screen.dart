import 'dart:developer';

import 'package:chat_using_firebase/Screens/SettingsScreen/settings.dart';
import 'package:chat_using_firebase/model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../constant/string_constant.dart';
import '../Chat/chat_screen.dart';

class UsersList extends StatefulWidget {
  final String? searchString;

  const UsersList({Key? key, this.searchString}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList>
    with SingleTickerProviderStateMixin {
  //for display search bar
  bool isShowSearchBar = false;

  //current firebase user
  late User currentUser;

  //creating dynamic a list for side popup menu
  List<PopupMenuItem> popUpMenuItem = [];

  //Scroll controller
  final ScrollController _scrollController = ScrollController();

  //TabBar controller
  late TabController tbController;

  //icon for floating action button

  IconData? floatingActionIcon;

  @override
  void initState() {
    //firebase  current user
    currentUser = FirebaseAuth.instance.currentUser!;

    //creating popup menu list
    popUpMenuItem = popUpMenuItemList.map((element) {
      return PopupMenuItem(child: Text(element), value: element);
    }).toList();

    //initializing with 4 tab items
    tbController = TabController(length: 4, vsync: this);

    tbController.index = 1;

    tbController.addListener(() {
      setState(() {});
      switch (tbController.index) {
        case 0:
          floatingActionIcon = null;
          break;
        case 1:
          floatingActionIcon = Icons.message;
          break;
        case 2:
          floatingActionIcon = Icons.camera_alt_sharp;
          break;
        case 3:
          floatingActionIcon = Icons.call;
          break;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            title: searchBar(),
            backgroundColor: isShowSearchBar ? Colors.white : null,
            elevation: 0,
            pinned: true,
            floating: true,
            bottom: TabBar(
                controller: tbController,
                isScrollable: true,
                indicatorColor: Colors.white,
                indicatorWeight: 5,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                tabs: const [
                  Icon(Icons.camera_alt_outlined),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Tab(text: "CHATS"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Tab(text: "STATUS"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Tab(text: "CALLS"),
                  )
                ]),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: tbController,
              children: [
                const Center(
                  child: Text("Camera"),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .snapshots(),
                  builder: (context, streamSnapshot) {
                    if (streamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<UserModel>? users = streamSnapshot.data?.docs
                        .map((docSnapshot) =>
                            UserModel.fromDocumentSnapshot(docSnapshot))
                        .toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const ScrollPhysics(),
                      itemCount: users?.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        if (users![index].uid == currentUser.uid) {
                          return Container(
                            color: Colors.black,
                          );
                        }

                        return UserListTileWidget(userModel: users[index]);
                      },
                    );
                  },
                ),
                const Center(
                  child: Text("STATUS"),
                ),
                const Center(
                  child: Text("CALLS"),
                ),
              ],
            ),
          )
        ],
        shrinkWrap: true,
      ),
      floatingActionButton: Visibility(
        visible: (floatingActionIcon != null) ? true : false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (floatingActionIcon == Icons.camera_alt_sharp)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.grey,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
              ),
            FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  floatingActionIcon,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
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
        Row(
          children: [
            InkWell(
                onTap: () {
                  setState(() {
                    isShowSearchBar = !isShowSearchBar;
                  });
                },
                child: Icon(
                  isShowSearchBar ? Icons.close : Icons.search,
                  color: isShowSearchBar ? Colors.grey : Colors.white,
                )),
            PopupMenuButton(
                icon: const Icon(FontAwesomeIcons.ellipsisVertical),
                onSelected: _selectedMenu,
                itemBuilder: (context) => popUpMenuItem)
          ],
        )
      ],
    );
  }

  void _selectedMenu(value) {
    log("Selected menu => " + value.toString());
    switch (value) {
      case wcNewGroup:
        // Get.toNamed("/");
        break;
      case wcNewBroadcast:
        // Get.toNamed("/");
        break;
      case wcLinkedDevices:
        // Get.toNamed("/");
        break;
      case wcStarredMessages:
        // Get.toNamed("/");
        break;
      case wcPayments:
        // Get.toNamed("/");
        break;
      case wcSettings:
        Get.to(()=>const SettingsScreen());
        break;
    }
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
          Get.to(() => ChatScreen(
                userModel: userModel,
                currentUser: FirebaseAuth.instance.currentUser!,
              ));
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
                        children: <Widget>[
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
