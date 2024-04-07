import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firestore_tutorial/models/chat.dart';
import 'package:firestore_tutorial/models/message.dart';
import 'package:firestore_tutorial/models/user_profile.dart';
import 'package:firestore_tutorial/services/auth_services.dart';
import 'package:firestore_tutorial/services/database_services.dart';
import 'package:firestore_tutorial/services/media_services.dart';
import 'package:firestore_tutorial/services/storage_services.dart';
import 'package:firestore_tutorial/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPage extends StatefulWidget {
  final UserProfile chatUser;
  const ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  File? _image;

  GetIt _getIt = GetIt.instance;
  late AuthServices _authServices;
  late DatabaseServices _databaseServices;
  late MediaServices _mediaServices;
  late StorageServices _storageServices;

  late ChatUser? currentUser, otherUser;
  @override
  void initState() {
    super.initState();
    _authServices = _getIt.get<AuthServices>();
    print(
        "printing the _authServicesUser user id in chat_page..................${_authServices.user!.uid}");

    _databaseServices = _getIt.get<DatabaseServices>();
    _mediaServices = _getIt.get<MediaServices>();
    _storageServices = _getIt.get<StorageServices>();
    currentUser = ChatUser(
        id: _authServices.user!.uid,
        firstName: _authServices.user!.displayName);
    print(
        "printing the current user id in chat_page..................${currentUser!.id}");
    otherUser = ChatUser(
        id: widget.chatUser.uid!,
        firstName: widget.chatUser.name,
        profileImage: widget.chatUser.pfpURL);
    print(
        "printing the other user id in chat_page..................${otherUser!.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.chatUser.pfpURL!),
              ),
            ),
            Text(widget.chatUser.name!)
          ],
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return StreamBuilder(
        stream: _databaseServices.getChatData(
            uid1: currentUser!.id, uid2: otherUser!.id),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting ||
              snapshots.connectionState == ConnectionState.none) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshots.hasError) {
            return const Expanded(
                child: Center(
              child: Text("Something went Wrong while fetching Data"),
            ));
          } else {
            Chat? chat = snapshots.data!.data();
            List<ChatMessage> messages = [];
            if (chat != null && chat.messages != null) {
              messages = _generateChatMessagesList(chat.messages!);
            }
            return DashChat(
                messageOptions: const MessageOptions(
                    showOtherUsersAvatar: true, showTime: true),
                inputOptions: InputOptions(
                  alwaysShowSend: true,
                  showTraillingBeforeSend: true,
                  trailing: [_mediaMessageButton()],
                ),
                currentUser: currentUser!,
                onSend: _sendMessage,
                messages: messages);
          }
        });
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      print("printing the chatMedia in chat_page.....................${chatMessage.medias!}");
      if (chatMessage.medias!.first.type == MediaType.image) {
        Message _message = Message(
            // senderID: currentUser!.id,
            senderID: chatMessage.user.id,
            content: chatMessage.medias!.first.url,
            messageType: MessageType.Image,
            sentAt: Timestamp.fromDate(chatMessage.createdAt));
        await _databaseServices.sendChatMessage(
            uid1: currentUser!.id, uid2: otherUser!.id, message: _message);
      }
    } else {
      Message _message = Message(
          // senderID: currentUser!.id,
          senderID: chatMessage.user.id,
          content: chatMessage.text,
          messageType: MessageType.Text,
          sentAt: Timestamp.fromDate(chatMessage.createdAt));
      await _databaseServices.sendChatMessage(
          uid1: currentUser!.id, uid2: otherUser!.id, message: _message);
    }
  }

  List<ChatMessage> _generateChatMessagesList(List<Message> messages) {
    List<ChatMessage> chatMessage = messages.map((m) {
      print(
          "printing the m.senderId  in chat_page..................${m.senderID}");

      if(m.messageType == MessageType.Image){
        return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            createdAt: m.sentAt!.toDate(),
            medias: [
              ChatMedia(url: m.content!, fileName: "", type: MediaType.image)
            ]);
      }else {
        return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            createdAt: m.sentAt!.toDate(),
            text: m.content!);
      }

    }).toList();
    chatMessage.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessage;
  }

  Widget _mediaMessageButton() {
    return IconButton(
        onPressed: () async {
          _image = await _mediaServices.getImageFromGallery();
          if (_image != null) {
            String chatID =
                generateChatId(uid1: currentUser!.id, uid2: otherUser!.id);

            String? imageDownloadUrl = await _storageServices.uploadChatMedia(
                file: _image!, chatID: chatID);

            if (imageDownloadUrl != null) {
              ChatMessage chatMessage = ChatMessage(
                  user: currentUser!,
                  createdAt: DateTime.now(),
                  medias: [
                    ChatMedia(
                        url: imageDownloadUrl,
                        fileName: "",
                        type: MediaType.image)
                  ]);
              _sendMessage(chatMessage);
            }
          }
        },
        icon: Icon(
          Icons.image,
          color: Theme.of(context).colorScheme.primary,
        ));
  }
}
