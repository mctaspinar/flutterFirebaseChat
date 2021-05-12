import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_chat/models/message.dart';
import 'package:flutter_app_chat/models/users.dart';
import 'package:flutter_app_chat/view_models/user_modelview.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Chatting extends StatefulWidget {
  final Users currentUser;
  final Users chatUser;

  const Chatting({this.currentUser, this.chatUser});

  @override
  _ChattingState createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  var _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    Users _currUser = widget.currentUser;
    Users _chatUser = widget.chatUser;
    ScrollController _scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(_chatUser.profilePic),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "${_chatUser.userName}",
              style: TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: StreamBuilder<List<Message>>(
              stream:
                  _userModel.getMessages(_currUser.userId, _chatUser.userId),
              builder: (context, streamList) {
                if (!streamList.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var allMessages = streamList.data;
                  return ListView.builder(
                      reverse: true,
                      itemCount: allMessages.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return _buildChatBalloon(allMessages[index]);
                      });
                }
              },
            )),
            Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _messageController,
                      cursorColor: Colors.blueGrey,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        filled: true,
                        hintText: "Mesajınızı yazınız.",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    height: 60,
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.send,
                        size: 28,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (_messageController.text.trim().length > 0) {
                          Message _saveMessage = Message(
                              toMessage: _chatUser.userId,
                              fromMessage: _currUser.userId,
                              fromWho: true,
                              message: _messageController.text);
                          var sonuc =
                              await _userModel.saveMessage(_saveMessage);
                          if (sonuc) {
                            _messageController.clear();
                            _scrollController.animateTo(0.0,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeInOut);
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChatBalloon(Message allMessages) {
    Color _fromMessageColor = Theme.of(context).primaryColor.withOpacity(.7);
    Color _toMessageColor = Theme.of(context).accentColor.withOpacity(.7);
    var value = "";

    try {
      value = _showTime(allMessages.date);
    } catch (e) {}

    var _myMessage = allMessages.fromWho;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                _myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!_myMessage)
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.chatUser.profilePic),
                ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: !_myMessage
                          ? Radius.circular(0)
                          : Radius.circular(16),
                      bottomRight:
                          _myMessage ? Radius.circular(0) : Radius.circular(16),
                    ),
                    color: _myMessage ? _fromMessageColor : _toMessageColor,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(4),
                  child: Text(
                    allMessages.message,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Text(value)
            ],
          )
        ],
      ),
    );
  }

  String _showTime(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formattedDate = _formatter.format(date.toDate());
    return _formattedDate;
  }
}
