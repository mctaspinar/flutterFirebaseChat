import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_view_model.dart';
import '../provider/all_user_view_model.dart';

import '../app/loading_page.dart';
import '../app/chat_screen.dart';
import '../app/empty_list_screen.dart';

class AllUsersPage extends StatefulWidget {
  @override
  _AllUsersPageState createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //minScrollExtent listenin sonuna geldiğinde
    //maxScrollExtent listenin başına geldiğinde
    _scrollController.addListener(_scrollListener);
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
        body: Consumer<AllUserModel>(
          builder: (context, model, _) {
            if (model.state == AllUserViewState.Busy) {
              return LoadingPage();
            } else if (model.state == AllUserViewState.Loaded) {
              return RefreshIndicator(
                onRefresh: model.refreshList,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    primary: false,
                    controller: _scrollController,
                    itemCount: model.hasMore
                        ? model.allUserList.length + 1
                        : model.allUserList.length,
                    itemBuilder: (context, index) {
                      if (model.allUserList.length == 0) {
                        return RefreshIndicator(
                          onRefresh: model.refreshList,
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: EmptyListScreen(
                              iconData: Icons.people,
                              message: "Henüz kişi listeniz boş..",
                            ),
                          ),
                        );
                      } else if (model.hasMore &&
                          index == model.allUserList.length) {
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Center(
                            child: Text(
                              "Diğer kullanıcıları görmek için yukarı kaydırın!",
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 18),
                            ),
                          ),
                        );
                      } else if (model.allUserList[index].userId ==
                          _userModel.users.userId) {
                        return Container();
                      } else {
                        return Card(
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                child: FadeInImage(
                                  image: NetworkImage(
                                    model.allUserList[index].profilePic,
                                  ),
                                  placeholder:
                                      AssetImage("assets/images/chat.png"),
                                ),
                              ),
                            ),
                            title: Text(model.allUserList[index].userName),
                            subtitle: Text(model.allUserList[index].eMail),
                            onTap: () => Navigator.of(context,
                                    rootNavigator: true)
                                .push(MaterialPageRoute(
                                    builder: (context) => Chatting(
                                          currentUser: _userModel.users,
                                          chatUser: model.allUserList[index],
                                        ))),
                          ),
                        );
                      }
                    }),
              );
            } else {
              return Container();
            }
          },
        ));
  }

  void loadMoreUser() async {
    if (_isLoading == false) {
      _isLoading = true;
      final _allUserViewModel =
          Provider.of<AllUserModel>(context, listen: false);
      await _allUserViewModel.loadMoreUser();
      _isLoading = false;
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      loadMoreUser();
    }
  }
}
