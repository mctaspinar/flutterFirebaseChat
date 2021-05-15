import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/email_login_page.dart';
import '../app/home_page.dart';

import '../provider/user_view_model.dart';

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
