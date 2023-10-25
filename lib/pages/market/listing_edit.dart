import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/widgets/bottom_nav_selected_listing.dart';
import 'package:flutter/material.dart';

class ListingEdit extends StatefulWidget {
  final String listingId;
  const ListingEdit({super.key, required this.listingId});

  @override
  State<ListingEdit> createState() => _ListingEditState();
}

class _ListingEditState extends State<ListingEdit> {
  @override
  Widget build(BuildContext context) {
    final ListingRepository listingRepository = ListingRepository();
    final Future<ListingModel> listing =
        listingRepository.getSpecificListing(widget.listingId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
      ),
      body: FutureBuilder(
        future: listing,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final listing = snapshot.data!;
          TextEditingController titleController =
              TextEditingController(text: listing.title);
          TextEditingController descriptionController =
              TextEditingController(text: listing.description);
          TextEditingController priceController =
              TextEditingController(text: listing.price.toString());

          return Column(
            children: [
              TextField(
                controller: titleController,
              ),
              TextField(
                controller: descriptionController,
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar:
          BottomNavSelectedListing(listingId: widget.listingId),
    );
  }
}
