import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_tutorial/firebase_options.dart';
import 'package:firestore_tutorial/services/alert_services.dart';
import 'package:firestore_tutorial/services/auth_services.dart';
import 'package:firestore_tutorial/services/database_services.dart';
import 'package:firestore_tutorial/services/media_services.dart';
import 'package:firestore_tutorial/services/navigation_services.dart';
import 'package:firestore_tutorial/services/storage_services.dart';
import 'package:get_it/get_it.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

// GetIt is used as service locator;
Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthServices>(AuthServices());
  getIt.registerSingleton<NavigationServices>(NavigationServices());
  getIt.registerSingleton<AlertServices>(AlertServices());
  getIt.registerSingleton<MediaServices>(MediaServices());
  getIt.registerSingleton<StorageServices>(StorageServices());
  getIt.registerSingleton<DatabaseServices>(DatabaseServices());


}

String generateChatId({required uid1, required uid2}) {
  List uids = [uid1,uid2];
  uids.sort();
  String chatId = uids.fold("", (id, uid) => "$id$uid");
  return chatId;

}
