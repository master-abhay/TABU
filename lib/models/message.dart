import 'package:cloud_firestore/cloud_firestore.dart';

const String SENDER_ID = 'senderID';
const String CONTENT = 'content';
const String MESSAGE_TYPE = 'messageType';
const String SENT_AT = 'sentAt';

enum MessageType { Text, Image }

class Message {
  String? senderID;
  String? content;
  MessageType? messageType;
  Timestamp? sentAt;

  Message(
      {required this.senderID,
      required this.content,
      required this.messageType,
      required this.sentAt});

  Message.fromJson(Map<String, dynamic> Json) {
    senderID = Json[SENDER_ID];
    content = Json[CONTENT];
    sentAt = Json[SENT_AT];
    messageType = MessageType.values.byName(Json[MESSAGE_TYPE]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data[SENDER_ID] = senderID;
    data[CONTENT] = content;
    data[MESSAGE_TYPE] = messageType!.name;
    data[SENT_AT] = sentAt;

    return data;
  }
}