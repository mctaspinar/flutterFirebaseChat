import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_app_chat/services/storage_base.dart';

class FireStorageService implements StorageBase {
  final firebase_storage.FirebaseStorage _firebaseStorage =
      firebase_storage.FirebaseStorage.instance;
  firebase_storage.Reference ref;

  @override
  Future<String> uploadFile(
      String userID, String fileType, File pickedFile) async {
    ref = _firebaseStorage
        .ref("users")
        .child(userID)
        .child(fileType)
        .child("profil_foto.png");
    var uploadTask = await ref.putFile(pickedFile);
    String url = await uploadTask.ref.getDownloadURL();
    return url;
  }
}
