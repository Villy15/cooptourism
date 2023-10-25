import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cooptourism/widgets/message_bubble.dart';
import 'package:cooptourism/data/models/message.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key, required this.receiverId});
  final String receiverId;

  final messages = [
    MessageModel(
        docId: 'null',
        senderId: '102',
        receiverId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
        content: 'Hello Test Send',
        timeStamp: Timestamp.now(),
        ),
    MessageModel(
        docId: null,
        senderId: '101',
        receiverId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
        content: 'Hi Jaz Test Send ',
        timeStamp: Timestamp.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final isMe = receiverId != messages[index].senderId;
          return MessageBubble(
            isMe: isMe,
            message: messages[index],
          );
        },
      ),
    );
  }
}
