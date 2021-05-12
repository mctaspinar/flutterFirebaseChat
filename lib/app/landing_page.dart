import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './email_login_page.dart';
import './home_page.dart';

import '../provider/user_modelview.dart';

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
