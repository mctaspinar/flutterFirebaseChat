import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/users.dart';
import '../services/auth_base.dart';

class FirebaseAuthService extends AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Users> currUser() async {
    try {
      User user = _firebaseAuth.currentUser;
      return _userFromFireBase(user);
    } catch (e) {
      print("Hata currUser : " + e.toString());
      return null;
    }
  }

  Users _userFromFireBase(User user) {
    if (user == null) {
      return null;
    } else {
      return Users(userId: user.uid, eMail: user.email);
    }
  }

  @override
  Future<Users> signInAnonym() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      return _userFromFireBase(result.user);
    } catch (e) {
      print("Hata anonymUser : " + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("SingOut : " + e.toString());
      return false;
    }
  }

  @override
  Future<Users> signInWithGoogle() async {
    GoogleSignIn _googleSingIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSingIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential result = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User _user = result.user;
        return _userFromFireBase(_user);
      }
    } else {
      return null;
    }
  }

  @override
  Future<Users> creatUserWithEmailandPass(String eMail, String pass) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: eMail, password: pass);
    return _userFromFireBase(result.user);
  }

  @override
  Future<Users> signInWithEmailandPass(String eMail, String pass) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: eMail, password: pass);
    return _userFromFireBase(result.user);
  }
}
