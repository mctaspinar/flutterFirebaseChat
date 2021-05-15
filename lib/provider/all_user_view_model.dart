import 'package:flutter/material.dart';

import '../repository/user_repository.dart';

import '../locator.dart';
import '../models/users.dart';

enum AllUserViewState {
  Idle,
  Loaded,
  Busy,
}

class AllUserModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<Users> _userList;
  Users _lastUserInfo;
  static final _getPostCount = 6;
  UserRepository _userRepository = locator<UserRepository>();
  bool _hasMore = true;

  bool get hasMore => _hasMore;
  List<Users> get allUserList => _userList;
  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserModel() {
    _userList = [];
    _lastUserInfo = null;
    getUserWithPaging(_lastUserInfo, false);
  }

  getUserWithPaging(Users lastUserInfo, bool getNewUsers) async {
    if (_userList.length > 0) {
      _lastUserInfo = _userList.last;
    }
    if (getNewUsers) {
    } else {
      state = AllUserViewState.Busy;
    }

    var tempList =
        await _userRepository.getUserPaging(_lastUserInfo, _getPostCount);
    if (tempList.length < _getPostCount) {
      _hasMore = false;
    }
    tempList.forEach((element) {});
    _userList.addAll(tempList);
    state = AllUserViewState.Loaded;
  }

  Future<void> loadMoreUser() async {
    if (_hasMore) {
      getUserWithPaging(_lastUserInfo, true);
    } else {}
    await Future.delayed(Duration(milliseconds: 750));
  }

  Future<Null> refreshList() async {
    _hasMore = true;
    _lastUserInfo = null;
    _userList = [];
    getUserWithPaging(_lastUserInfo, true);
  }
}
