import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_chat/models/users.dart';
import 'package:flutter_app_chat/view_models/user_modelview.dart';
import 'package:provider/provider.dart';
import 'chat_screen.dart';
import 'empty_list_screen.dart';

class AllUsersPage extends StatefulWidget {
  @override
  _AllUsersPageState createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  List<Users> _allUsers = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _setUserCountFirst = 6;
  Users _lastUserInfo;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      getUser();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position == 0) {
          print("Liste tepesi");
        } else {
          getUser();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kişiler",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _allUsers.length == 0
                ? RefreshIndicator(
                    onRefresh: _refreshList,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: EmptyListScreen(
                        iconData: Icons.people,
                        message: "Henüz kişi listeniz boş..",
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshList,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        primary: false,
                        controller: _scrollController,
                        itemCount: _allUsers.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _allUsers.length) {
                            return _isLoading
                                ? Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Center(
                                      child: Text(
                                        "Yükleniyor...",
                                        style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize: 18),
                                      ),
                                    ),
                                  )
                                : null;
                          }

                          if (_allUsers[index].userId ==
                              _userModel.users.userId) {
                            return Container();
                          }

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  _allUsers[index].profilePic,
                                ),
                              ),
                              title: Text(_allUsers[index].userName),
                              subtitle: Text(_allUsers[index].eMail),
                              onTap: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) => Chatting(
                                                currentUser: _userModel.users,
                                                chatUser: _allUsers[index],
                                              ))),
                            ),
                          );
                        }),
                  ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }

  getUser() async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (!_hasMore) return;
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    List<Users> users =
        await _userModel.getUserPaging(_lastUserInfo, _setUserCountFirst);
    if (_allUsers == null) {
      _allUsers = [];
      _allUsers.addAll(users);
    } else {
      _allUsers.addAll(users);
    }
    if (users.length < _setUserCountFirst) {
      _hasMore = false;
    }

    _lastUserInfo = _allUsers.last;
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _isLoading = false;
    });
  }

  Future<Null> _refreshList() async {
    _allUsers = [];
    _hasMore = true;
    _lastUserInfo = null;
    getUser();
  }
}
