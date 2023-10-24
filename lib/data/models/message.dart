// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MessageModel {
  String? docId;
  String? senderId;
  String? receiverId;
  String? content;
  DateTime? timeStamp;
  MessageModel({
    this.docId,
    this.senderId,
    this.receiverId,
    this.content,
    this.timeStamp,
  });

  MessageModel copyWith({
    String? docId,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timeStamp,
  }) {
    return MessageModel(
      docId: docId ?? this.docId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timeStamp': timeStamp?.millisecondsSinceEpoch,
    };
  }

  factory MessageModel.fromMap(String docId, Map<String, dynamic> map) {
    return MessageModel(
      docId: docId,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      receiverId: map['receiverId'] != null ? map['receiverId'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      timeStamp: map['timeStamp'] != null ? DateTime.fromMillisecondsSinceEpoch(map['timeStamp'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap("",json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(docId: $docId, senderId: $senderId, receiverId: $receiverId, content: $content, timeStamp: $timeStamp)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.docId == docId &&
      other.senderId == senderId &&
      other.receiverId == receiverId &&
      other.content == content &&
      other.timeStamp == timeStamp;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
      senderId.hashCode ^
      receiverId.hashCode ^
      content.hashCode ^
      timeStamp.hashCode;
  }
}
