import 'package:cooptourism/core/get_time_difference.dart';
import 'package:cooptourism/data/models/message.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
// import 'package:cooptourism/widgets/bottom_nav_selected_listing.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ListingMessagesInbox extends ConsumerStatefulWidget {
  final String listingId;
  const ListingMessagesInbox({super.key, required this.listingId});

  @override
  ConsumerState<ListingMessagesInbox> createState() =>
      _ListingMessagesInboxState();
}

class _ListingMessagesInboxState extends ConsumerState<ListingMessagesInbox> {
  @override
  Widget build(BuildContext context) {
    final ListingRepository listingRepository = ListingRepository();
    final UserRepository userRepository = UserRepository();

    listingRepository.getSpecificListing(widget.listingId);
    final Stream<List<MessageModel>> receivedFrom =
        listingRepository.getAllReceivedFrom(widget.listingId);

    return Scaffold(
      // appBar: AppBar(backgroundColor: Colors.grey[800],),
      body: StreamBuilder(
        stream: receivedFrom,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final receivedFrom = snapshot.data!;
          debugPrint("testing the print ${receivedFrom.length}");
          if (receivedFrom.isNotEmpty) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final received = receivedFrom[index];
                  final Stream<List<MessageModel>> messages =
                      listingRepository.getReceivedFromMessages(
                          widget.listingId, received.docId!);

                  return StreamBuilder(
                    stream: messages,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final messages = snapshot.data!;
                      final sender =
                          userRepository.getUser(messages.first.senderId!);

                      return FutureBuilder(
                        future: sender,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final sender = snapshot.data!;
                          final path =
                              "users/${sender.email}/${sender.profilePicture}";
                          debugPrint('path: $path');
                          final time = TimeDifferenceCalculator(
                              messages.first.timeStamp!);

                          return InkWell(
                            onTap: () {
                              context.push(
                                  '/market_page/${widget.listingId}/listing_messages_inbox/${received.docId}');
                            },
                            child: Row(
                              children: [
                                DisplayImage(
                                    path: path,
                                    height: 50,
                                    width: 50,
                                    radius: BorderRadius.circular(100)),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DisplayText(
                                            text:
                                                "${sender.lastName} ${sender.firstName}",
                                            lines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!),
                                        DisplayText(
                                            text: messages.first.content!,
                                            lines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!),
                                      ],
                                    ),
                                  ),
                                ),
                                DisplayText(
                                    text: time.getTimeDifference(),
                                    lines: 1,
                                    style:
                                        Theme.of(context).textTheme.bodySmall!)
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                itemCount: receivedFrom.length,
              ),
            );
          } else {
            return Center(
              child: DisplayText(
                  text: "No Messages",
                  lines: 1,
                  style: Theme.of(context).textTheme.headlineMedium!),
            );
          }
        },
      ),
    );
  }
}
