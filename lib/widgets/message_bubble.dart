import 'package:flutter/material.dart';
import 'package:cooptourism/model/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    });

final bool isMe;
final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: 
          isMe ? Alignment.topLeft : Alignment.topRight,
      child: Container(
            decoration: BoxDecoration(
              color : isMe ? Colors.blue : Colors.grey,
              borderRadius: isMe ? const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ) : const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            margin: const EdgeInsets.only(
              top: 10, right: 10, left: 10),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isMe 
              ? CrossAxisAlignment.start 
              : CrossAxisAlignment.end,
              children: [
                Text(message.content,
                  style:
                    const TextStyle(color: Colors.white)),
              ],
            )
            )
          );
  }
}