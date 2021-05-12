import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_chat/view_models/user_modelview.dart';

import 'package:provider/provider.dart';

import 'app/landing_page.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        title: "Flutter Live Chat",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.from(
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: "Raleway",
              ),
          colorScheme: ColorScheme.light(),
        ).copyWith(
          errorColor: Color(0xFF4b778d),
          primaryColor: Color(0xFF28b5b5),
          accentColor: Color(0xFFd2e69c),
          accentColorBrightness: Brightness.dark,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Color(0xFF28b5b5),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              primary: Color(0xFF8fd9a8),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                primary: Color(0xFF8fd9a8),
                side: BorderSide(color: Color(0xFF8fd9a8))),
          ),
        ),
        home: LandingPage(),
      ),
    );
  }
}
