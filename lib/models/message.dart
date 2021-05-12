import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String fromMessage;
  final String toMessage;
  final String message;
  final bool fromWho; //true: from false: to
  final Timestamp date;

  Message(
      {this.fromMessage,
      this.toMessage,
      this.message,
      this.fromWho,
      this.date});

  Map<String, dynamic> toMap() {
    return {
      'fromMessage': fromMessage,
      'toMessage': toMessage,
      'message': message,
      'fromWho': fromWho,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  Message.fromMap(Map<String, dynamic> map)
      : fromMessage = map["fromMessage"],
        toMessage = map["toMessage"],
        message = map["message"],
        fromWho = map["fromWho"],
        date = map["date"];

  @override
  String toString() {
    return 'Message{fromMessage: $fromMessage, toMessage: $toMessage, message: $message, fromWho: $fromWho, date: $date}';
  }
}
