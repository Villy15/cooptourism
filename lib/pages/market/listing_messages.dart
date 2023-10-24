import 'package:cooptourism/data/models/message.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/widgets/bottom_nav_selected_listing.dart';
import 'package:flutter/material.dart';

class ListingMessages extends StatefulWidget {
  final String listingId;
  const ListingMessages({super.key, required this.listingId});

  @override
  State<ListingMessages> createState() => _ListingMessagesState();
}

class _ListingMessagesState extends State<ListingMessages> {
  @override
  Widget build(BuildContext context) {
    final ListingRepository listingRepository = ListingRepository();
    final Stream<List<MessageModel>> messages =
        listingRepository.getAllMessages();
    return StreamBuilder(
        stream: messages,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // final messages = snapshot.data!;

          return Scaffold(appBar: AppBar(backgroundColor: Colors.grey[800],), body: Container(), bottomNavigationBar: BottomNavSelectedListing(listingId: widget.listingId));
        });
  }
}
