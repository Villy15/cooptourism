import 'package:cooptourism/widgets/chat_field.dart';
import 'package:flutter/material.dart';
import 'package:cooptourism/model/userChat.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [ChatTextField()],
          ),
        ),
    );
  }

   AppBar _buildAppBar() => AppBar(
    elevation: 0,
    foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    title: Row(
      children: [
        CircleAvatar(
          backgroundImage:
            NetworkImage(widget.user.image),
          radius: 20,
        ),
        const SizedBox(width: 10),
          Column(
            children: [
              Text(
                  widget.user.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
                )
            ],
          )
      ],)
  );
}