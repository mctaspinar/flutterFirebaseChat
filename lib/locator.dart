import 'package:flutter_app_chat/repository/user_repository.dart';
import 'package:flutter_app_chat/services/fake_auth_service.dart';
import 'package:flutter_app_chat/services/firebase_auth_service.dart';
import 'package:flutter_app_chat/services/firestorage_services.dart';
import 'package:flutter_app_chat/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => FireStoreDBService());
  locator.registerLazySingleton(() => FireStorageService());
  locator.registerLazySingleton(() => UserRepository());
}