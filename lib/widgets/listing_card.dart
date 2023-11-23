// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/providers/listing_provider.dart';
import 'package:cooptourism/widgets/display_image.dart';
// import 'package:cooptourism/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

class ListingCard extends ConsumerStatefulWidget {
  final ListingModel listingModel;
  const ListingCard({super.key, required this.listingModel});

  @override
  ConsumerState<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends ConsumerState<ListingCard> {
  // String getTimeDifference() {
  //   final now = Timestamp.now().toDate();
  //   final postTime = widget.listingModel.postDate!.toDate();
  //   final difference = now.difference(postTime);

  //   if (difference.inMinutes < 60) {
  //     return '${difference.inMinutes}m ago';
  //   } else if (difference.inHours < 24) {
  //     return '${difference.inHours}h ago';
  //   } else {
  //     final formatter = DateFormat.yMd().add_jm();
  //     return formatter.format(postTime);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        clipBehavior: Clip.hardEdge,
        elevation: 1,
        surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: InkWell(
          splashColor: Colors.orange.withAlpha(30),
          onTap: () {
            ref
                .read(listingModelProvider.notifier)
                .setListing(widget.listingModel);
            context.push('/market_page/${widget.listingModel.id}');
          },
          child: SizedBox(
              width: double.infinity,
              height: 325,
              child: Column(
                children: [
                  // Random Image
                  DisplayImage(
                    path:
                        "${widget.listingModel.cooperativeOwned}/listingImages/${widget.listingModel.images![0]}",
                    height: 175,
                    width: double.infinity,
                    radius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

                  // Card Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                      child: Text(
                        widget.listingModel.title!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Card Location
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                          ),
                          Text(
                            widget.listingModel.city ?? 'City',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Price, Rating, and Distance
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Row(
                          children: [
                            Text(
                              '₱${widget.listingModel.price}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              '/night',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        // Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star_purple500_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Text(
                              widget.listingModel.rating?.toStringAsFixed(1) ??
                                  "No Rating",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // Distance
                        Row(
                          children: [
                            const Icon(
                              Icons.hotel_outlined,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              widget.listingModel.category ?? 'Accomodation',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
