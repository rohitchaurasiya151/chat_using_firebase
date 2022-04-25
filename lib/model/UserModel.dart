


import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.displayName,
    this.email,
    this.groups,
    this.photoUrl,
    this.uid,
  });
  String? displayName;
  String? email;
  List<String>? groups;
  String? photoUrl;
  String? uid;

  factory UserModel.fromDocumentSnapshot(QueryDocumentSnapshot doc) => UserModel(
        displayName: doc[keyDisplayName],
        email: doc[keyEmail],
        groups: List<String>.from(doc[keyGroups].map((x) => x)),
        photoUrl: doc[keyPhotoUrl],
        uid: doc[keyUid],
      );

  Map<String, dynamic> toMap() => {
        keyDisplayName: displayName,
        keyEmail: email,
        keyGroups: groups,
        keyPhotoUrl: photoUrl,
        keyUid: uid,
      };
}

const keyDisplayName = "displayName";
const keyEmail = "email";
const keyGroups = "groups";
const keyPhotoUrl = "photoUrl";
const keyUid = "uid";
