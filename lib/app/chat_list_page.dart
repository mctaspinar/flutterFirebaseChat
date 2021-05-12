import 'package:flutter/material.dart';
import 'package:flutter_app_chat/models/chats.dart';
import 'package:flutter_app_chat/models/users.dart';
import 'package:flutter_app_chat/view_models/user_modelview.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';
import 'empty_list_screen.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbetler"),
      ),
      body: FutureBuilder<List<Chats>>(
        future: _userModel.getAllChats(_userModel.users.userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var chatList = snapshot.data;
            if (chatList.length > 0) {
              return RefreshIndicator(
                onRefresh: _refreshList,
                child: ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                                  builder: (context) => Chatting(
                                        currentUser: _userModel.users,
                                        chatUser: Users.idAndPhoto(
                                            userId: chatList[index].chatWith,
                                            profilePic: chatList[index]
                                                .chatWithProfilePic,
                                            userName: chatList[index]
                                                .chatWithUserName),
                                      )));
                        },
                        child: ListTile(
                          title: Text(chatList[index].chatWithUserName),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text(
                                    chatList[index].lastMessage,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Text(chatList[index].differenceTime)
                            ],
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                chatList[index].chatWithProfilePic),
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _refreshList,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: EmptyListScreen(
                      iconData: Icons.message,
                      message: "Henüz yeni bir sohbetiniz yok..",
                    )),
              );
            }
          }
        },
      ),
    );
  }

  Future<Null> _refreshList() async {
    setState(() {});
    await Future.delayed(Duration(milliseconds: 700));
    return null;
  }
}
