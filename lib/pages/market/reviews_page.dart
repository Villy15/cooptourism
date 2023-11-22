import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/models/review.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:cooptourism/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewsPage extends ConsumerStatefulWidget {
  final List<ReviewModel> review;
  final ListingModel listing;
  const ReviewsPage({super.key, required this.review, required this.listing});

  @override
  ConsumerState<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends ConsumerState<ReviewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Reviews',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.primary)),
      body: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Rating Stars and Average
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 25,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 5),
                      DisplayText(
                        text:
                            "${widget.listing.rating?.toStringAsFixed(2) ?? 0.00}",
                        lines: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),

                ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.review.length,
                  itemBuilder: (context, index) {
                    final review = widget.review[index];
                    return ReviewCard(
                      reviewModel: review,
                    );
                  },
                ),

                // Reviews
              ],
            ),
          ),
        ),
      ),
    );
  }
}
