import 'package:cooptourism/data/repositories/messages_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {

  final String userId;
  const ChatScreen({super.key, required this.userId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final userRepository = UserRepository();
  final messageRepository = MessageRepository();
  String chatName = "";
  User? user;
  final textController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    _fetchChatName();
    debugPrint(chatName);
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = false;
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  }

  Future<void> _fetchChatName() async {
    final chat = await userRepository.getUser(widget.userId);
    setState(() {
      chatName = "${chat.firstName!} ${chat.lastName}";
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
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [

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
        title: Text(chatName)
      );
}
