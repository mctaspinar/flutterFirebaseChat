import 'package:flutter_app_chat/models/chats.dart';
import 'package:flutter_app_chat/models/message.dart';
import 'package:flutter_app_chat/models/users.dart';

abstract class DBBase {
  Future<bool> saveUser(Users users);
  Future<Users> readUser(String userID);
  Future<bool> updateUserName(String userID, String userName);
  Future<bool> updateProfilePhoto(String userID, String profilePhotoURL);
  Future<List<Users>> getUserPaging(Users lastUser, int pagingUserCount);
  Stream<List<Message>> getMessages(String toUserID, String fromUserID);
  Future<bool> saveMessage(Message saveMessage);
  Future<List<Chats>> getAllChats(String userID);
  Future<DateTime> showTime(String userID);
}
