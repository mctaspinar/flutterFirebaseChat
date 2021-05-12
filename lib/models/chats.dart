import 'package:cloud_firestore/cloud_firestore.dart';

class Chats {
  final String chatOwner;
  final String chatWith;
  final bool isSeen;
  final Timestamp createdDate;
  final String lastMessage;
  final Timestamp seenDate;
  String chatWithUserName;
  String chatWithProfilePic;
  DateTime lastReadTime;
  String differenceTime;

  Chats(
      {this.chatOwner,
      this.chatWith,
      this.isSeen,
      this.createdDate,
      this.lastMessage,
      this.seenDate});

  Map<String, dynamic> toMap() {
    return {
      'chatOwner': chatOwner,
      'chatWith': chatWith,
      'isSeen': isSeen,
      'createdDate': createdDate ?? FieldValue.serverTimestamp(),
      'lastMessage': lastMessage,
      'seenDate': seenDate ?? FieldValue.serverTimestamp(),
    };
  }

  Chats.fromMap(Map<String, dynamic> map)
      : chatOwner = map["chatOwner"],
        chatWith = map["chatWith"],
        isSeen = map["isSeen"],
        createdDate = map["createdDate"],
        lastMessage = map["lastMessage"],
        seenDate = map["seenDate"];

  @override
  String toString() {
    return 'Chats{chatOwner: $chatOwner, chatWith: $chatWith, isSeen: $isSeen, createdDate: $createdDate, lastMessage: $lastMessage, seenDate: $seenDate}';
  }
}
