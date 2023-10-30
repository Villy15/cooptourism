import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/providers/listing_provider.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ListingCard extends ConsumerStatefulWidget {
  final ListingModel listingModel;
  const ListingCard({super.key, required this.listingModel});

  @override
  ConsumerState<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends ConsumerState<ListingCard> {
  String getTimeDifference() {
    final now = Timestamp.now().toDate();
    final postTime = widget.listingModel.postDate!.toDate();
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[800]!, width: .25)),
        child: InkWell(
            onTap: () {
              ref
                  .read(listingModelProvider.notifier)
                  .setListing(widget.listingModel);
              context.push('/market_page/${widget.listingModel.id}');
            },
            child: Column(
              children: [
                DisplayImage(
                  path:
                      "${widget.listingModel.owner}/listingImages/${widget.listingModel.id}${widget.listingModel.images![0]}",
                  height: 175,
                  width: double.infinity,
                  radius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DisplayText(
                                text: widget.listingModel.title!,
                                lines: 2,
                                style:
                                    Theme.of(context).textTheme.headlineSmall!,
                              ),
                              DisplayText(
                                text: "₱${widget.listingModel.price}",
                                lines: 1,
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.fontSize),
                              ),
                            ],
                          ),
                          DisplayText(
                              text: widget.listingModel.description!,
                              lines: 3,
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.fontSize)),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
