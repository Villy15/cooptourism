import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListingCard extends StatelessWidget {
  final String owner;
  final String title;
  final String description;
  final int price;
  final String type;
  final List<dynamic> images;
  final int visits;
  final Timestamp postDate;

  const ListingCard({
    required Key key,
    required this.owner,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.images,
    required this.visits,
    required this.postDate,
  }) : super(key: key);

  String getTimeDifference() {
    final now = Timestamp.now().toDate();
    final postTime = postDate.toDate();
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DisplayImage(
            path: "$owner/listingImages/${images[0]}",
            height: 100,
            width: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
