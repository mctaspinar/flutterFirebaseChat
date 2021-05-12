import 'package:flutter/material.dart';

enum TabItems {AllUsers,Chats, Profile}

class TabItemsData{
  final String title;
  final IconData icon;

  TabItemsData(this.title, this.icon);

  static Map<TabItems,TabItemsData> allTabs = {
    TabItems.AllUsers : TabItemsData("Kullanıcıar",Icons.supervised_user_circle),
    TabItems.Chats : TabItemsData("Sohbetler",Icons.chat),
    TabItems.Profile : TabItemsData("Profil",Icons.person),
  };
}