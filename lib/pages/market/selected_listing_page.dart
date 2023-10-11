// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SelectedListingPage extends StatefulWidget {
  final String listingId;
  const SelectedListingPage({super.key, required this.listingId});

  @override
  State<SelectedListingPage> createState() => _SelectedListingPageState();
}

class _SelectedListingPageState extends State<SelectedListingPage> {
  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();
    final ListingRepository listingRepository = ListingRepository();

    final Future<ListingModel> listings =
        listingRepository.getSpecificListing(widget.listingId);
    return FutureBuilder<ListingModel>(
      future: listings,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final listing = snapshot.data!;
        return Container(
          child: Text(widget.listingId),
        );
      },
    );
  }
}
