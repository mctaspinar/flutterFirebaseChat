import 'package:flutter/material.dart';
import 'package:flutter_app_chat/view_models/user_modelview.dart';

import 'package:provider/provider.dart';

import 'email_login_page.dart';
import 'home_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.users == null) {
      return EmailPasswordLogIn();
    } else {
      return HomePage(users: _userModel.users);
    }
  }
}
