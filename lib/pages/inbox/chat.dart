import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/message.dart';
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
    final Future<List<MessageModel>> chatRoom =
        messageRepository.getOneChatRoom(user!.uid, widget.userId);
    final Stream<List<MessageModel>> messages =
        messageRepository.getAllInboxMsgs(user!.uid, widget.userId);
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          ref.read(navBarVisibilityProvider.notifier).state = true;
          ref.read(appBarVisibilityProvider.notifier).state = true;
          return true;
        },
        child: FutureBuilder(
            future: chatRoom,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return StreamBuilder(
                stream: messages,
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!;

                  return Scaffold(
                      appBar: _buildAppBar(),
                      body: Column(children: [
                        Expanded(
                            child: ListView.builder(
                                itemCount: messages.length,
                                shrinkWrap: true,
                                itemBuilder: ((context, index) {
                                  debugPrint(messages.length.toString());
                                  final message = messages[index];

                                  return BubbleNormal(
                                    text: message.content!,
                                    isSender: user?.uid == message.senderId!,
                                    color: Colors.grey[800]!,
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .fontSize,
                                        fontWeight: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .fontWeight),
                                  );
                                }))),
                        Container(
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: Colors.grey[800]!),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: textController,
                                  textAlignVertical:
                                      const TextAlignVertical(y: 0),
                                  cursorHeight: 15,
                                  cursorWidth: 2,
                                  maxLines: null,
                                  expands: true,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10)),
                                )),
                                Container(
                                    margin: const EdgeInsets.only(right: 2.5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: InkWell(
                                        onTap: () {
                                          messageRepository.addInboxMsg(
                                              MessageModel(
                                                  docId: "",
                                                  senderId: user!.uid,
                                                  receiverId: widget.userId,
                                                  content: textController.text,
                                                  timeStamp: Timestamp.now()),
                                              user!.uid,
                                              widget.userId);
                                          textController.clear();
                                        },
                                        child: const Icon(
                                            Icons.arrow_upward_rounded,
                                            color: Colors.white,
                                            size: 30)))
                              ],
                            ))
                      ]));
                }),
              );
            }));
  }

  AppBar _buildAppBar() => AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary),
        onPressed: () {
          ref.read(navBarVisibilityProvider.notifier).state = true;
          ref.read(appBarVisibilityProvider.notifier).state = true;
          Navigator.of(context).pop(); // to go back
        },
      ),
      title: Text(chatName));
}
