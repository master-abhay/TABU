import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageServices {
  StorageServices() {}

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadUserPfp(
      {required File file, required String uid}) async {
    Reference fileRef = _firebaseStorage
        .ref('users/pfps')
        .child('$uid${p.extension(file.path)}');
    print(
        "Printing the file refrence in storage_services......................................................${fileRef}");

    UploadTask task = fileRef.putFile(file);
    print(
        "printing the task in the storage_services class..............................................................${task}");
    return task.then((myTask) {
      if (myTask.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
    });
  }

  Future<String?> uploadChatMedia(
      {required File file, required String chatID}) async {
    Reference fileRef = _firebaseStorage
        .ref('chats/${chatID}')
        .child('${DateTime.now().microsecond.toString()}${p.extension(file.path)}');

    UploadTask task = fileRef.putFile(file);

    return task.then((myTask
        ) {
      if(myTask.state == TaskState.success){
        return fileRef.getDownloadURL();
      }
    });


  }




}
