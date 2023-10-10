import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cooptourism/data/repositories/cooperative_repository.dart';
// import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/widgets/display_image.dart';
// import 'package:cooptourism/widgets/display_profile_picture.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListingCard extends StatelessWidget {
  final String listingOwner;
  final String listingTitle;
  final String listingDescription;
  final int listingPrice;
  final String listingType;
  final List<dynamic> listingImages;
  final int listingVisits;
  final Timestamp listingPostDate;

  const ListingCard({
    required Key key,
    required this.listingOwner,
    required this.listingTitle,
    required this.listingDescription,
    required this.listingPrice,
    required this.listingType,
    required this.listingImages,
    required this.listingVisits,
    required this.listingPostDate,
  }) : super(key: key);

  String getTimeDifference() {
    final now = Timestamp.now().toDate();
    final postTime = listingPostDate.toDate();
    final difference = now.difference(postTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      final formatter = DateFormat.yMd().add_jm();
      return formatter.format(postTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Column(
      children: [
        DisplayImage(
          id: listingOwner,
          data: listingImages,
          height: 100,
          width: 100,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              Text(listingTitle),
            ],
          ),
        )
      ],
    ));
  }
}
