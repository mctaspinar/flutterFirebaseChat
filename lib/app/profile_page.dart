import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../common_widget/alert_dialog.dart';
import '../common_widget/log_in_buttons.dart';
import '../provider/user_view_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _controllerUserName;
  File _profilePhoto;
  ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _usermodel = Provider.of<UserModel>(context);
    _controllerUserName.text = _usermodel.users.userName;
    print("profil page: " + _usermodel.users.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${_usermodel.users.userName}",
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.exit_to_app_sharp,
                size: 26,
                color: Colors.white,
              ),
              onPressed: () => _exitOK(context))
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          height: MediaQuery.of(context).size.height * .65,
          child: Stack(
            children: [
              Positioned(
                height: MediaQuery.of(context).size.height * (.45),
                width: MediaQuery.of(context).size.width - 20,
                left: 10,
                top: MediaQuery.of(context).size.height * 0.20,
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 90, left: 20, right: 20),
                        child: TextFormField(
                          initialValue: _usermodel.users.eMail,
                          readOnly: true,
                          decoration: InputDecoration(
                              labelText: "Email Adresiniz",
                              hintText: "Email",
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 20, right: 20),
                        child: TextFormField(
                          controller: _controllerUserName,
                          decoration: InputDecoration(
                              labelText: "Kullanıcı Adınız",
                              hintText: "Kullanıcı Adı",
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 20, right: 20),
                        child: LogInButton(
                          btnText: "Kaydet",
                          btnColor: Theme.of(context).primaryColor,
                          btnPressed: () {
                            _updateUserName(context);
                            _updateProfilePic(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Profilini güncellenmiştir."),
                              duration: Duration(milliseconds: 1500),
                            ));
                          },
                        ),
                      )
                    ],
                  ),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 170,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.camera),
                                    title: Text("Kameradan Çek"),
                                    onTap: () => _addPhoto(ImageSource.camera),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.image),
                                    title: Text("Galeriden Seç"),
                                    onTap: () => _addPhoto(ImageSource.gallery),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: _profilePhoto == null
                          ? NetworkImage(_usermodel.users.profilePic)
                          : FileImage(_profilePhoto),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _cksYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    var result = await _userModel.signOut();
    return result;
  }

  Future _exitOK(BuildContext context) async {
    final result = await CustomAlertDialog(
      title: "ÇIKIŞ YAP",
      content: "Çıkış yapmak istediğinizden emin misiniz?",
      actionText: "Evet",
      cancelText: "Vazgeç",
    ).show(context);

    if (result) {
      _cksYap(context);
    }
  }

  void _updateUserName(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.users.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.users.userId, _controllerUserName.text);

      if (!updateResult) {
        CustomAlertDialog(
          title: "Kullanıcı Adı Güncelleme Hatası",
          content:
              "Girmiş olduğunuz kullanıcı adı başka bir kullanıcı tarafından alınmıştır. "
              "Lütfen farklı bir kullanıcı adı giriniz.",
          actionText: "Tamam",
        ).show(context);
      } else {
        _userModel.users.userName = _controllerUserName.text;
      }
    }
  }

  _addPhoto(ImageSource source) async {
    var _pickedPhoto = await _imagePicker.getImage(source: source);
    Navigator.of(context).pop();
    setState(() {
      _profilePhoto = File(_pickedPhoto.path);
    });
  }

  void _updateProfilePic(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    try {
      if (File(_profilePhoto.path) != null) {
        var url = await _userModel.uploadFile(
            _userModel.users.userId, "profilFoto", _profilePhoto);
        print(url);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
