import 'package:flutter/material.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/widgets/chat_field.dart';
import 'package:cooptourism/widgets/chat_messages.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = false;
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ref.read(navBarVisibilityProvider.notifier).state = true;
        ref.read(appBarVisibilityProvider.notifier).state = true;
        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ChatMessages(receiverId: widget.user.uid ?? ''),
              const ChatTextField(),
              // const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            ref.read(navBarVisibilityProvider.notifier).state = true;
            ref.read(appBarVisibilityProvider.notifier).state = true;
            Navigator.of(context).pop(); // to go back
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(Icons.person,
                  size: 30, color: Theme.of(context).colorScheme.primary),
            ),
            // CircleAvatar(
            //   backgroundImage: NetworkImage(widget.user.image),
            //   radius: 20,
            // ),
            const SizedBox(width: 10),
            Column(
              children: [
                Text('${widget.user.firstName ?? ''} ${widget.user.lastName ?? ''}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            )
          ],
        ),
      );
}
