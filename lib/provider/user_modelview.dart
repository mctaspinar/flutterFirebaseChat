import 'dart:io';

import 'package:flutter/material.dart';

import '../models/chats.dart';
import '../models/message.dart';
import '../models/users.dart';
import '../repository/user_repository.dart';
import '../services/auth_base.dart';
import '../locator.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  Users _users;
  String emailErrorMessage;
  String passErrorMessage;

  Users get users => _users;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserModel() {
    currUser();
  }

  @override
  Future<Users> currUser() async {
    try {
      state = ViewState.Busy;
      _users = await _userRepository.currUser();
      return _users;
    } catch (e) {
      debugPrint("ViewModel currUser hata : " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Users> signInAnonym() async {
    try {
      state = ViewState.Busy;
      _users = await _userRepository.signInAnonym();
      return _users;
    } catch (e) {
      debugPrint("ViewModel signInAnonym hata : " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _users = null;
      return sonuc;
    } catch (e) {
      debugPrint("ViewModel signOut hata : " + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Users> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _users = await _userRepository.signInWithGoogle();
      return _users;
    } catch (e) {
      debugPrint("ViewModel signGoogle hata : " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Users> creatUserWithEmailandPass(String eMail, String pass) async {
    if (_emailAndPassCheck(eMail, pass)) {
      try {
        state = ViewState.Busy;
        _users = await _userRepository.creatUserWithEmailandPass(eMail, pass);
        return _users;
      } finally {
        state = ViewState.Idle;
      }
    } else {
      return null;
    }
  }

  @override
  Future<Users> signInWithEmailandPass(String eMail, String pass) async {
    try {
      if (_emailAndPassCheck(eMail, pass)) {
        try {
          state = ViewState.Busy;
          _users = await _userRepository.signInWithEmailandPass(eMail, pass);
          return _users;
        } finally {
          state = ViewState.Idle;
        }
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  bool _emailAndPassCheck(String email, String pass) {
    var sonuc = true;

    if (pass.length < 6) {
      passErrorMessage = "Şifreniz en az 6 karakter olmalıdır.";
      sonuc = false;
    } else {
      passErrorMessage = null;
      sonuc = true;
    }
    if (!email.contains("@")) {
      emailErrorMessage = "Geçersiz email adresi girdiniz.";
      sonuc = false;
    } else {
      emailErrorMessage = null;
      sonuc = true;
    }
    return sonuc;
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    var result = await _userRepository.updateUserName(userID, newUserName);
    return result;
  }

  Future<String> uploadFile(
      String userId, String fileType, File profilePhoto) async {
    var result =
        await _userRepository.uploadFile(userId, fileType, profilePhoto);
    return result;
  }

  Stream<List<Message>> getMessages(String currUser, String chatUser) {
    return _userRepository.getMessages(currUser, chatUser);
  }

  Future<bool> saveMessage(Message saveMessage) async {
    return await _userRepository.saveMessage(saveMessage);
  }

  Future<List<Chats>> getAllChats(String userId) async {
    return await _userRepository.getAllChats(userId);
  }

  Future<List<Users>> getUserPaging(
      Users lastUserInfo, int setUserCountFirst) async {
    return await _userRepository.getUserPaging(lastUserInfo, setUserCountFirst);
  }
}
