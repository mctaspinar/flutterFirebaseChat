import 'package:flutter/material.dart';
import 'package:flutter_app_chat/app/custom_buttom_navi.dart';
import 'package:flutter_app_chat/app/tab_items.dart';
import 'package:flutter_app_chat/models/users.dart';

import 'all_users_page.dart';
import 'chat_list_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final Users users;

  HomePage({Key key, @required this.users}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItems _currentItem = TabItems.AllUsers;
  Map<TabItems, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItems.AllUsers : GlobalKey<NavigatorState>(),
    TabItems.Chats : GlobalKey<NavigatorState>(),
    TabItems.Profile : GlobalKey<NavigatorState>(),
  };


  Map<TabItems, Widget> allPages() {
    return {
      TabItems.AllUsers: AllUsersPage(),
      TabItems.Chats: ChatsPage(),
      TabItems.Profile: ProfilePage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return !await navigatorKeys[_currentItem].currentState.maybePop();
      },
      child: MyCustomButtomNavigation(
        navigatorKeys: navigatorKeys,
        currentTab: _currentItem,
        createPage: allPages(),
        onSelectedTab: (selectedTab) {
          if(selectedTab == _currentItem){
            navigatorKeys[selectedTab].currentState.popUntil((route) => route.isFirst);
          }else{
            setState(() {
              _currentItem = selectedTab;
            });
            debugPrint("Seçilen item : " + selectedTab.toString());
          }
        },
      ),
    );
  }

}
