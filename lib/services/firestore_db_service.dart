import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chats.dart';
import '../models/message.dart';
import '../models/users.dart';

import '../services/db_base.dart';

class FireStoreDBService implements DBBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(Users users) async {
    var userList = await _firestore
        .collection("users")
        .where("userID", isEqualTo: users.userId)
        .get();
    if (userList.docs.length == 0) {
      await _firestore.collection("users").doc(users.userId).set(users.toMap());
      return true;
    } else {
      return true;
    }
  }

  @override
  Future<Users> readUser(String userID) async {
    DocumentSnapshot _snapshot =
        await _firestore.collection("users").doc(userID).get();
    Users _user = Users.fromMap(_snapshot.data());
    print("okunan user : " + _user.toString());
    return _user;
  }

  @override
  Future<bool> updateUserName(String userID, String userName) async {
    var users = await _firestore
        .collection("users")
        .where("userName", isEqualTo: userName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestore
          .collection("users")
          .doc(userID)
          .update({"userName": userName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userID, String profilePhotoURL) async {
    await _firestore
        .collection("users")
        .doc(userID)
        .update({"profilePic": profilePhotoURL});
    return true;
  }

  @override
  Stream<List<Message>> getMessages(String toUser, String fromUser) {
    var snaps = _firestore
        .collection("konusmalar")
        .doc(toUser + '-' + fromUser)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .snapshots();
    return snaps.map((messageList) => messageList.docs
        .map((message) => Message.fromMap(message.data()))
        .toList());
  }

  @override
  Future<bool> saveMessage(Message saveMessage) async {
    var _messageID = _firestore.collection("konusmalar").doc().id;
    var _myDocID = saveMessage.fromMessage + "-" + saveMessage.toMessage;
    var _chatUserID = saveMessage.toMessage + "-" + saveMessage.fromMessage;
    var temp = saveMessage.toMap();

    await _firestore
        .collection("konusmalar")
        .doc(_myDocID)
        .collection("mesajlar")
        .doc(_messageID)
        .set(temp);

    await _firestore.collection("konusmalar").doc(_myDocID).set({
      "chatOwner": saveMessage.fromMessage,
      "chatWith": saveMessage.toMessage,
      "lastMessage": saveMessage.message,
      "isSeen": false,
      "createdDate": FieldValue.serverTimestamp()
    });

    temp.update("fromWho", (value) => false);

    await _firestore
        .collection("konusmalar")
        .doc(_chatUserID)
        .collection("mesajlar")
        .doc(_messageID)
        .set(temp);

    await _firestore.collection("konusmalar").doc(_chatUserID).set({
      "chatOwner": saveMessage.toMessage,
      "chatWith": saveMessage.fromMessage,
      "lastMessage": saveMessage.message,
      "isSeen": false,
      "createdDate": FieldValue.serverTimestamp()
    });

    return true;
  }

  @override
  Future<List<Chats>> getAllChats(String userID) async {
    QuerySnapshot snapshot = await _firestore
        .collection("konusmalar")
        .where("chatOwner", isEqualTo: userID)
        .orderBy("createdDate", descending: true)
        .get();

    List<Chats> allChats = [];

    for (DocumentSnapshot chat in snapshot.docs) {
      allChats.add(Chats.fromMap(chat.data()));
    }

    return allChats;
  }

  @override
  Future<DateTime> showTime(String userID) async {
    await _firestore
        .collection("server")
        .doc(userID)
        .set({"time": FieldValue.serverTimestamp()});

    var result = await _firestore.collection("server").doc(userID).get();
    Timestamp readTime = result.data()["time"];
    return readTime.toDate();
  }

  @override
  Future<List<Users>> getUserPaging(Users lastUser, int pagingUserCount) async {
    List<Users> _allUser = [];

    QuerySnapshot _querySnapshot;
    if (lastUser == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('userName')
          .limit(pagingUserCount)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('userName')
          .startAfter([lastUser.userName])
          .limit(pagingUserCount)
          .get();
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Users _user = Users.fromMap(snap.data());
      _allUser.add(_user);
    }

    return _allUser;
  }
}
