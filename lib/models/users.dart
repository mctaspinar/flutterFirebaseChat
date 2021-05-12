import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Users {
  final String userId;
  String eMail;
  String userName;
  String profilePic;
  DateTime createdAt;
  DateTime updatedAt;
  int grade;

  Users({@required this.userId, @required this.eMail});
  Users.idAndPhoto(
      {@required this.userId,
      @required this.profilePic,
      @required this.userName});

  Map<String, dynamic> toMap() {
    return {
      'userID': userId,
      'eMail': eMail,
      'userName': userName ??
          eMail.substring(0, eMail.indexOf("@")) +
              DateTime.now().year.toString() +
              DateTime.now().month.toString() +
              DateTime.now().day.toString(),
      'profilePic': profilePic ??
          'https://freepikpsd.com/wp-content/uploads/2019/10/default-profile-image-png-1-Transparent-Images.png',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'grade': grade ?? 1,
    };
  }

  Users.fromMap(Map<String, dynamic> map)
      : userId = map["userID"],
        eMail = map["eMail"],
        userName = map["userName"],
        profilePic = map["profilePic"],
        createdAt = (map["createdAt"] as Timestamp).toDate(),
        updatedAt = (map["updatedAt"] as Timestamp).toDate(),
        grade = map["grade"];

  @override
  String toString() {
    return 'Users{userId: $userId, eMail: $eMail, userName: $userName, profilePic: $profilePic, createdAt: $createdAt, updatedAt: $updatedAt, grade: $grade}';
  }
}
