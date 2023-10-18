import 'package:flutter/material.dart';
import 'package:cooptourism/widgets/message_bubble.dart';
import 'package:cooptourism/data/models/message.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key, required this.receiverId});
  final String receiverId;

  final messages = [
    const Message(
        senderId: '102',
        receiverId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
        content: 'Hello Tim'),
    const Message(
        senderId: '101',
        receiverId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
        content: 'Hi Jaz'),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child : ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final isMe = 
              receiverId != messages[index].senderId;
        return MessageBubble(
              isMe: isMe,
              message: messages[index],
            );
      },
    ),
    );
  }
}