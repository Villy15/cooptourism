import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/review.dart';
import 'package:cooptourism/widgets/display_text.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatefulWidget {
  final ReviewModel? reviewModel;

  const ReviewCard({super.key, this.reviewModel});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  String getTimeDifference() {
    final now = Timestamp.now().toDate();
    final postTime = widget.reviewModel?.reviewDate!.toDate();
    final difference = now.difference(postTime!);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      final formatter = DateFormat('MMMM yyyy'); // format to Month Year
      return formatter.format(postTime);
    }
  }

  int textLines = 2;
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    // final storageRef = FirebaseStorage.instance.ref();

    // final cooperativeRepository = CooperativesRepository();
    // final cooperative =
    //     cooperativeRepository.getCooperative(widget.reviewModel!.id!);

    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
            ),
            title: const Text(
              'Anonymous',
            ),
            subtitle: const Text(
              'Quezon City, Philippines',
            ),
          ),
          Row(
            children: [
              RatingBarIndicator(
                rating: widget.reviewModel!.rating?.toDouble() ?? 0,
                itemBuilder: (context, index) {
                  return Icon(
                    Icons.star_rounded,
                    color: Theme.of(context).primaryColor,
                  );
                },
                itemCount: 5,
                itemSize: 15,
                direction: Axis.horizontal,
              ),
              const SizedBox(width: 5),
              Text('· ${getTimeDifference()}')
            ],
          ),
          DisplayText(
            text: widget.reviewModel!.title!,
            lines: 3,
            style: Theme.of(context).textTheme.titleMedium!,
          ),
          if (widget.reviewModel!.positiveDescription != "")
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  setState(() {
                    expanded = !expanded;
                    if (expanded == false) {
                      textLines = 2;
                    } else {
                      textLines = 10;
                    }
                  });
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: DisplayText(
                        text: widget.reviewModel!.positiveDescription!,
                        lines: textLines,
                        style: Theme.of(context).textTheme.bodySmall!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (widget.reviewModel!.negativeDescription != "")
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  setState(() {
                    expanded = !expanded;
                    if (expanded == false) {
                      textLines = 2;
                    } else {
                      textLines = 10;
                    }
                  });
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: DisplayText(
                        text: widget.reviewModel!.negativeDescription!,
                        lines: textLines,
                        style: Theme.of(context).textTheme.bodySmall!,
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
