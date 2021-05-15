import '../models/users.dart';

import '../services/auth_base.dart';

class FakeAuthService extends AuthBase {
  @override
  Future<Users> currUser() async {
    return await Future.value(Users(userId: "asda", eMail: "fakeMail"));
  }

  @override
  Future<Users> signInAnonym() async {
    return await Future.delayed(Duration(seconds: 2),
        () => Users(userId: "anonym_asda", eMail: "fakeMail"));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<Users> signInWithGoogle() async {
    return await Future.delayed(Duration(seconds: 2),
        () => Users(userId: "google_asda", eMail: "fakeMail"));
  }

  @override
  Future<Users> creatUserWithEmailandPass(String eMail, String pass) async {
    return await Future.delayed(Duration(seconds: 2),
        () => Users(userId: "create_user_asda", eMail: "fakeMail"));
  }

  @override
  Future<Users> signInWithEmailandPass(String eMail, String pass) async {
    return await Future.delayed(Duration(seconds: 2),
        () => Users(userId: "signin_user_asda", eMail: "fakeMail"));
  }
}
