import 'package:flutter_app_chat/models/users.dart';

abstract class AuthBase {
  Future<Users> currUser();

  Future<Users> signInAnonym();

  Future<bool> signOut();

  Future<Users> signInWithGoogle();

  Future<Users> signInWithEmailandPass(String eMail, String pass);

  Future<Users> creatUserWithEmailandPass(String eMail, String pass);

}
