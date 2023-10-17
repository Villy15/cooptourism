import 'package:cooptourism/pages/inbox/chat.dart';
import 'package:flutter/material.dart';
import 'package:cooptourism/data/models/user_chart.dart';

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.user});

  final UserModel user;

  @override
  State <UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
             ChatScreen(user: widget.user)));
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(widget.user.image),
        ),
      title: Text(
        widget.user.name,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      )
      ),
    );
  }
}