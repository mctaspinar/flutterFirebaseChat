import 'dart:io';

import 'package:timeago/timeago.dart' as timeago;

import '../models/chats.dart';
import '../models/message.dart';
import '../models/users.dart';

import '../services/auth_base.dart';
import '../services/fake_auth_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestorage_services.dart';
import '../services/firestore_db_service.dart';

import '../locator.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FireStoreDBService _fireStoreDBService = locator<FireStoreDBService>();
  FireStorageService _fireStorageService = locator<FireStorageService>();

  AppMode appMode = AppMode.RELEASE;

  List<Users> userList = [];

  @override
  Future<Users> currUser() async {
    try {
      if (appMode == AppMode.DEBUG) {
        return await _fakeAuthService.currUser();
      } else {
        Users _user = await _firebaseAuthService.currUser();
        return await _fireStoreDBService.readUser(_user.userId);
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Users> signInAnonym() async {
    try {
      if (appMode == AppMode.DEBUG) {
        return await _fakeAuthService.signInAnonym();
      } else {
        return await _firebaseAuthService.signInAnonym();
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      if (appMode == AppMode.DEBUG) {
        return await _fakeAuthService.signOut();
      } else {
        return await _firebaseAuthService.signOut();
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Users> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGoogle();
    } else {
      Users _user = await _firebaseAuthService.signInWithGoogle();
      bool result = await _fireStoreDBService.saveUser(_user);
      if (result) {
        return await _fireStoreDBService.readUser(_user.userId);
      } else {
        return null;
      }
    }
  }

  @override
  Future<Users> creatUserWithEmailandPass(String eMail, String pass) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.creatUserWithEmailandPass(eMail, pass);
    } else {
      Users _user =
          await _firebaseAuthService.creatUserWithEmailandPass(eMail, pass);
      bool result = await _fireStoreDBService.saveUser(_user);
      if (result) {
        return await _fireStoreDBService.readUser(_user.userId);
      } else {
        return null;
      }
    }
  }

  @override
  Future<Users> signInWithEmailandPass(String eMail, String pass) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmailandPass(eMail, pass);
    } else {
      Users _user =
          await _firebaseAuthService.signInWithEmailandPass(eMail, pass);
      return await _fireStoreDBService.readUser(_user.userId);
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _fireStoreDBService.updateUserName(userID, newUserName);
    }
  }

  Future<String> uploadFile(
      String userId, String fileType, File profilePhoto) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      var profilePhotoURL =
          await _fireStorageService.uploadFile(userId, fileType, profilePhoto);
      await _fireStoreDBService.updateProfilePhoto(userId, profilePhotoURL);
      return profilePhotoURL;
    }
  }

  Stream<List<Message>> getMessages(String currUser, String chatUser) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _fireStoreDBService.getMessages(currUser, chatUser);
    }
  }

  Future<bool> saveMessage(Message saveMessage) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return await _fireStoreDBService.saveMessage(saveMessage);
    }
  }

  Future<List<Chats>> getAllChats(String userId) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _time = await _fireStoreDBService.showTime(userId);

      var chatList = await _fireStoreDBService.getAllChats(userId);
      for (var temp in chatList) {
        var user = findUser(temp.chatWith);
        if (user != null) {
          print("veri localden okunuluyor...");
          temp.chatWithUserName = user.userName;
          temp.chatWithProfilePic = user.profilePic;
        } else {
          print(
              "Aranılan kullanıcı veri tabanından çekilmemiş, veri tabanından alınıyor...");
          var readUser = await _fireStoreDBService.readUser(temp.chatWith);
          temp.chatWithUserName = readUser.userName;
          temp.chatWithProfilePic = readUser.profilePic;
        }
        temp.lastReadTime = _time;
        var dur = _time.difference(temp.createdDate.toDate());
        timeago.setLocaleMessages("tr", timeago.TrMessages());
        temp.differenceTime = timeago.format(_time.subtract(dur), locale: "tr");
      }
      return chatList;
    }
  }

  Users findUser(String userId) {
    for (int i = 0; i < userList.length; i++) {
      if (userList[i].userId == userId) {
        return userList[i];
      } else {
        return null;
      }
    }
  }

  Future<List<Users>> getUserPaging(
      Users lastUserInfo, int setUserCountFirst) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<Users> _userList = await _fireStoreDBService.getUserPaging(
          lastUserInfo, setUserCountFirst);

      userList.addAll(_userList);
      return _userList;
    }
  }
}
