import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/models/message.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/providers/listing_provider.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:cooptourism/widgets/bottom_nav_selected_listing.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final UserRepository userRepository = UserRepository();

class ListingMessages extends ConsumerStatefulWidget {
  final String listingId;
  final String docId;
  const ListingMessages(
      {super.key, required this.listingId, required this.docId});

  @override
  ConsumerState<ListingMessages> createState() => _ListingMessagesState();
}

class _ListingMessagesState extends ConsumerState<ListingMessages> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);
    final currentListing = ref.watch(listingModelProvider);
    final ListingRepository listingRepository = ListingRepository();
    final Future<ListingModel> listing =
        listingRepository.getSpecificListing(widget.listingId);
    return FutureBuilder(
        future: listing,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // final listing = snapshot.data!;
          final Stream<List<MessageModel>> messages = listingRepository
              .getReceivedFromMessages(widget.listingId, widget.docId);

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
                  appBar: _appBar(context, widget.docId),
                  body: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: messages.length,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) {
                            final message = messages[index];

                            return BubbleNormal(
                              text: message.content!,
                              isSender: user!.uid == message.senderId!,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1), // Colors.grey[800]!,
                              textStyle: TextStyle(
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
                        ),
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: primaryColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(children: [
                          Expanded(
                            child: TextField(
                              controller: textController,
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize,
                                fontWeight: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontWeight,
                              ),
                              // Color
                              textAlignVertical: const TextAlignVertical(y: 0),
                              cursorHeight: 15,
                              cursorWidth: 2,
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  // color
                                  hintText: 'Write a message...',
                                  contentPadding: EdgeInsets.only(left: 10)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 2.5),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              onTap: () {
                                String receiverId = "";
                                if (user!.uid == widget.docId) {
                                  receiverId = currentListing!.owner!;
                                } else {
                                  receiverId = widget.docId;
                                }
                                listingRepository.addMessage(
                                  MessageModel(
                                    senderId: user.uid,
                                    receiverId: receiverId,
                                    content: textController.text,
                                    timeStamp: Timestamp.now(),
                                  ),
                                  widget.listingId,
                                  widget.docId,
                                );
                                textController.clear();
                              },
                              child: const Icon(
                                Icons.arrow_upward_rounded,
                                size: 30,
                              ),
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                  // bottomNavigationBar:
                  //     BottomNavSelectedListing(listingId: widget.listingId),
                );
              }));
        });
  }

  AppBar _appBar(BuildContext context, String userId) {
    return AppBar(
      toolbarHeight: 70,
      title: FutureBuilder<String>(
        future: userRepository.getUserName(userId),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...'); // or some other placeholder
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Text(
              snapshot.data ??
                  '', // Use the data if available, otherwise use an empty string
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            );
          }
        },
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          GoRouter.of(context).pop();
          ref.read(navBarVisibilityProvider.notifier).state = true;
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                // showAddPostPage(context);
              },
              icon: const Icon(Icons.message, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
