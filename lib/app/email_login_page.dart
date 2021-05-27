import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_chat/common_widget/social_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../common_widget/alert_dialog.dart';
import '../common_widget/log_in_buttons.dart';

import '../models/error_exception.dart';
import '../models/users.dart';
import '../provider/user_view_model.dart';

enum FormType { Register, Login }

class EmailPasswordLogIn extends StatefulWidget {
  @override
  _EmailPasswordLogInState createState() => _EmailPasswordLogInState();
}

class _EmailPasswordLogInState extends State<EmailPasswordLogIn> {
  String email, sifre;
  String butonText, linkText, placeHolderText;
  var _formtype = FormType.Login;
  final _formKey = GlobalKey<FormState>();

  void _formSubmit(context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("_form : " + email + sifre);
      final _userModel = Provider.of<UserModel>(context, listen: false);
      if (_formtype == FormType.Login) {
        try {
          Users _loggedUser =
              await _userModel.signInWithEmailandPass(email, sifre);
          if (_loggedUser != null) {}
        } on FirebaseAuthException catch (e) {
          CustomAlertDialog(
                  context: context,
                  title: "Oturum Açma Hatası",
                  content: ErrorList.showError(e.code.toString()),
                  actionText: "Tamam")
              .show(context);
        }
      } else {
        try {
          Users _createdUser =
              await _userModel.creatUserWithEmailandPass(email, sifre);
          if (_createdUser != null) {
            print("Kayıt olan user : " + _createdUser.userId);
          }
        } on FirebaseAuthException catch (e) {
          CustomAlertDialog(
                  context: context,
                  title: "Kullanıcı Oluşturma Hatası",
                  content: ErrorList.showError(e.code.toString()),
                  actionText: "Tamam")
              .show(context);
        }
      }
    }
  }

  void _changeText() {
    setState(() {
      _formtype =
          _formtype == FormType.Login ? FormType.Register : FormType.Login;
    });
  }

  @override
  Widget build(BuildContext context) {
    butonText = _formtype == FormType.Login ? "Giriş Yap" : "Kayıt Ol";
    linkText = _formtype == FormType.Login ? "Kayıt olun." : "Giriş Yapın.";
    placeHolderText =
        _formtype == FormType.Login ? "Hesabınız yok mu?" : "Hesabınız var mı?";

    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.users != null) {
      Future.delayed(Duration(microseconds: 300), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment(0, -1),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Align(
                      alignment: Alignment(0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Let's Chat!",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 45,
                            ),
                            child: Image.asset(
                              "assets/images/chat.png",
                              height: 75,
                              width: 75,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Align(
                alignment: Alignment(0, 1),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                hintText: "E-mail giriniz",
                                labelText: "E-mail",
                                errorText: _userModel.emailErrorMessage != null
                                    ? _userModel.emailErrorMessage
                                    : null,
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                filled: true,
                              ),
                              onSaved: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                errorText: _userModel.passErrorMessage != null
                                    ? _userModel.passErrorMessage
                                    : null,
                                prefixIcon: Icon(Icons.email),
                                hintText: "Şifre Giriniz",
                                labelText: "Şifre",
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                filled: true,
                              ),
                              onSaved: (value) {
                                setState(() {
                                  sifre = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _userModel.state == ViewState.Idle
                              ? LogInButton(
                                  btnText: butonText,
                                  btnColor: Theme.of(context).primaryColor,
                                  btnPressed: () => _formSubmit(context),
                                )
                              : CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  placeHolderText,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _changeText(),
                                  child: Text(
                                    linkText,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Sosyal Medya ile Giriş Yap',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialButton(
                                imgPath: ("assets/images/google.png"),
                                clickFunc: () => _googleGiris(context),
                              ),
                              SocialButton(
                                imgPath: ("assets/images/face.png"),
                              ),
                              SocialButton(
                                imgPath: ("assets/images/twitter.png"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _googleGiris(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    await _userModel.signInWithGoogle();
  }
}
