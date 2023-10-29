import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/message.dart';
import 'package:cooptourism/data/repositories/messages_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoachingMessaging extends ConsumerStatefulWidget {
  final String coachId;

  const CoachingMessaging({
    super.key,
    required this.coachId,
  });
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyConsumerWidgetState();
}

class _MyConsumerWidgetState extends ConsumerState<CoachingMessaging> {
  final userRepository = UserRepository();
  String coachName = "";
  User? user;
  final textController = TextEditingController();
  final messageRepository = MessageRepository();

  @override
  void initState() {
    super.initState();
    
    user = FirebaseAuth.instance.currentUser;
    
    _fetchCoachName();
    // messageRepository.addCoachMessageManually();
  }

  Future<void> _fetchCoachName() async {
    final coach = await userRepository.getUser(widget.coachId);
    setState(() {
      coachName = "${coach.firstName!} ${coach.lastName}";
    });
  }


  @override
  Widget build(BuildContext context) {
    final Future<List<MessageModel>> chatRoom = messageRepository.getOneChatRoom(user!.uid, widget.coachId);
    return FutureBuilder(
      future: chatRoom,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }


        final Stream<List<MessageModel>> messages = messageRepository.getAllCoachingMsgs(user!.uid, widget.coachId);
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
              appBar: AppBar(
                title: Text(
                  coachName
                ),
              ),
              body: Column(
                children: [
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
                                .fontWeight,
                          ),
                        );
                      }),
                    )
                  ),

                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2, 
                        color: Colors.grey[800]!
                      ),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child : Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            textAlignVertical: const TextAlignVertical(y: 0),
                            cursorHeight: 15, 
                            cursorWidth: 2,
                            maxLines: null, 
                            expands: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type a message',
                              contentPadding: EdgeInsets.only(left: 10)
                            )
                          )
                        ), 
                        Container(
                          margin: const EdgeInsets.only(right: 2.5),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child: InkWell(
                            onTap: () {
                              messageRepository.addCoachMsg(
                                MessageModel(
                                  docId: "",
                                  senderId: user!.uid,
                                  receiverId: widget.coachId,
                                  content: textController.text,
                                  timeStamp: Timestamp.now()
                                ),
                                user!.uid,
                                widget.coachId
                              );
                              textController.clear();
                            },
                            child: const Icon(
                              Icons.arrow_upward_rounded,
                              color: Colors.white,
                              size: 30
                            )
                          )
                        )
                      ]
                    )
                  )
                ],
              )
            );
          }),
        );
      }
    );
    
    
  }
}
