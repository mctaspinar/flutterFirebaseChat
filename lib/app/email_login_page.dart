import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String butonText, linkText;
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
    linkText = _formtype == FormType.Login
        ? "Hesabınız yok mu? Kayıt olun."
        : "Hesabınız var mı? Giriş Yapın.";

    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.users != null) {
      Future.delayed(Duration(microseconds: 300), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Flutter Live Chat",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.white,
                letterSpacing: 1),
          ),
        ),
        backgroundColor: Colors.grey.shade300,
        body: _userModel.state == ViewState.Idle
            ? Center(
                child: SingleChildScrollView(
                  primary: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .2,
                            child: Text(
                              "Chat APP",
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 48,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                hintText: "E-mail giriniz",
                                labelText: "E-mail",
                                errorText: _userModel.emailErrorMessage != null
                                    ? _userModel.emailErrorMessage
                                    : null,
                                border: OutlineInputBorder()),
                            onSaved: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                errorText: _userModel.passErrorMessage != null
                                    ? _userModel.passErrorMessage
                                    : null,
                                prefixIcon: Icon(Icons.email),
                                hintText: "Şifre Giriniz",
                                labelText: "Şifre",
                                border: OutlineInputBorder()),
                            onSaved: (value) {
                              setState(() {
                                sifre = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          LogInButton(
                            btnText: butonText,
                            btnColor: Theme.of(context).primaryColor,
                            btnPressed: () => _formSubmit(context),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          LogInButton(
                              btnText: "Google ile Giriş Yap",
                              btnColor: Colors.white,
                              btnTextColor: Colors.black,
                              btnPressed: () => _googleGiris(context),
                              btnIcon: Image.asset(
                                "assets/images/google.png",
                                width: 35,
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          TextButton(
                              onPressed: () => _changeText(),
                              child: Text(
                                linkText,
                                style: TextStyle(fontSize: 18),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  void _googleGiris(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    await _userModel.signInWithGoogle();
  }
}
