import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/models/message.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:cooptourism/widgets/bottom_nav_selected_listing.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListingMessages extends ConsumerStatefulWidget {
  final String listingId;
  const ListingMessages({super.key, required this.listingId});

  @override
  ConsumerState<ListingMessages> createState() => _ListingMessagesState();
}

class _ListingMessagesState extends ConsumerState<ListingMessages> {
  final textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);
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

          final listing = snapshot.data!;
          final Stream<List<MessageModel>> messages = listingRepository
              .getAllMessages(widget.listingId, user!.uid!, listing.owner!);

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
                    backgroundColor: Colors.grey[800],
                  ),
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
                              isSender: user.uid == message.senderId!,
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
                        ),
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 2, color: Colors.grey[800]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(children: [
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
                                  hintText: 'Message',
                                  contentPadding: EdgeInsets.only(left: 10)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 2.5),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              onTap: () {
                                listingRepository.addMessage(
                                  MessageModel(
                                    docId: "",
                                    senderId: user.uid,
                                    receiverId: listing.owner,
                                    content: textController.text,
                                    timeStamp: Timestamp.now(),
                                  ),
                                  widget.listingId,
                                );
                                textController.clear();
                              },
                              child: const Icon(
                                Icons.arrow_upward_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                  bottomNavigationBar:
                      BottomNavSelectedListing(listingId: widget.listingId),
                );
              }));
        });
  }
}
