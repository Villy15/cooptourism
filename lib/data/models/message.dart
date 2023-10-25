// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? docId;
  String? senderId;
  String? receiverId;
  String? content;
  Timestamp? timeStamp;
  bool? isSender;
  MessageModel({
    this.docId,
    this.senderId,
    this.receiverId,
    this.content,
    this.timeStamp,
    this.isSender,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timeStamp': timeStamp,
      'isSender': isSender,
    };
  }

  factory MessageModel.fromMap(String docId, Map<String, dynamic> map) {
    return MessageModel(
      docId: docId,
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      content: map['content'],
      timeStamp: map['timeStamp'],
      isSender: map['isSender'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap("", json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(docId: $docId, senderId: $senderId, receiverId: $receiverId, content: $content, timeStamp: $timeStamp, isSender: $isSender)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.docId == docId &&
      other.senderId == senderId &&
      other.receiverId == receiverId &&
      other.content == content &&
      other.timeStamp == timeStamp &&
      other.isSender == isSender;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
      senderId.hashCode ^
      receiverId.hashCode ^
      content.hashCode ^
      timeStamp.hashCode ^
      isSender.hashCode;
  }
}
