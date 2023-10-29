import 'package:flutter/material.dart';
import 'package:cooptourism/pages/inbox/chat.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:go_router/go_router.dart';

class UserItem extends StatefulWidget {
  const UserItem({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: () {
        context.go('/inbox_page/${widget.user.uid!}}');
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(Icons.person, size: 30, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          '${widget.user.firstName} ${widget.user.lastName}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
