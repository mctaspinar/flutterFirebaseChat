import './repository/user_repository.dart';

import './services/fake_auth_service.dart';
import './services/firebase_auth_service.dart';
import './services/firestorage_services.dart';
import './services/firestore_db_service.dart';

import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => FireStoreDBService());
  locator.registerLazySingleton(() => FireStorageService());
  locator.registerLazySingleton(() => UserRepository());
}
