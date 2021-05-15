import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './tab_items.dart';

class MyCustomButtomNavigation extends StatelessWidget {
  const MyCustomButtomNavigation(
      {Key key,
      @required this.currentTab,
      @required this.onSelectedTab,
      @required this.createPage,
      @required this.navigatorKeys})
      : super(key: key);

  final TabItems currentTab;
  final ValueChanged<TabItems> onSelectedTab;
  final Map<TabItems, Widget> createPage;
  final Map<TabItems, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _bottomNavigationBarItem(TabItems.AllUsers),
          _bottomNavigationBarItem(TabItems.Chats),
          _bottomNavigationBarItem(TabItems.Profile),
        ],
        onTap: (index) => onSelectedTab(TabItems.values[index]),
      ),
      tabBuilder: (context, index) {
        final showItem = TabItems.values[index];
        return CupertinoTabView(
            navigatorKey: navigatorKeys[showItem],
            builder: (context) {
              return createPage[showItem];
            });
      },
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(TabItems items) {
    final createTab = TabItemsData.allTabs[items];

    return BottomNavigationBarItem(
      icon: Icon(createTab.icon),
      label: createTab.title,
    );
  }
}
