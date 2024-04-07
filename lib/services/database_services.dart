import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_tutorial/models/chat.dart';
import 'package:firestore_tutorial/models/message.dart';
import 'package:firestore_tutorial/models/user_profile.dart';
import 'package:firestore_tutorial/utils.dart';
import 'package:get_it/get_it.dart';

import 'auth_services.dart';

class DatabaseServices {
  final GetIt _getIt = GetIt.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _userCollectionReference;
  CollectionReference? _chatCollectionReference;
  late AuthServices _authServices;

  DatabaseServices() {
    _setupCollectionReference();
    _authServices = _getIt.get<AuthServices>();
  }

  void _setupCollectionReference() {
    _userCollectionReference = _firebaseFirestore
        .collection("users")
        .withConverter<UserProfile>(
            fromFirestore: (snapshots, _) =>
                UserProfile.fromJSON(snapshots.data()!),
            toFirestore: (userProfile, _) => userProfile.toJson());

    _chatCollectionReference = _firebaseFirestore
        .collection("chat")
        .withConverter<Chat>(
            fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
            toFirestore: (chat, _) => chat.toJson());
  }

  // Function to create a document:
  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _userCollectionReference!.doc(userProfile.uid).set(userProfile);
  }

  // Function which will give us the objects of the userprofile from the firestore:
  Stream<QuerySnapshot<UserProfile>> getUserProfiles() {
    return _userCollectionReference
        ?.where("uid", isNotEqualTo: _authServices.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatId = await generateChatId(uid1: uid1, uid2: uid2);
    final result = await _chatCollectionReference?.doc(chatId).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = _chatCollectionReference!.doc(chatId);
    final chat = Chat(id: chatId, participants: [uid1, uid2], messages: []);
    await docRef.set(chat);
  }

  Future<void> sendChatMessage(
      {required String uid1,
      required String uid2,
      required Message message}) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = _chatCollectionReference!.doc(chatId);
    await docRef.update({
      "messages": FieldValue.arrayUnion([message.toJson()])
    });
  }

  Stream<DocumentSnapshot<Chat>> getChatData(
      {required String uid1, required String uid2}) {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = _chatCollectionReference!.doc(chatId);
    return docRef.snapshots() as Stream<DocumentSnapshot<Chat>>;
  }

}
