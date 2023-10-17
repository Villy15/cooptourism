// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/models/review.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/review_repository.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:cooptourism/widgets/review_card.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SelectedListingPage extends StatelessWidget {
  final String listingId;
  const SelectedListingPage({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    final ListingRepository listingRepository = ListingRepository();
    final ReviewRepository reviewRepository = ReviewRepository();

    final Future<ListingModel> listings =
        listingRepository.getSpecificListing(listingId);

    final Stream<List<ReviewModel>> reviews =
        reviewRepository.getAllListingReviews(listingId);

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

        return StreamBuilder<List<ReviewModel>>(
          stream: reviews,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final reviews = snapshot.data!;
            return ListView(
              children: [
                ImageSlider(listing: listing),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DisplayText(
                        text: listing.title!,
                        lines: 1,
                        style: Theme.of(context).textTheme.headlineSmall!,
                      ),
                      DisplayText(
                        text: "Type: ${listing.type!}",
                        lines: 4,
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.fontSize),
                      ),
                      DisplayText(
                        text: "Desciption: ${listing.description!}",
                        lines: 5,
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.fontSize,
                        ),
                      ),
                      DisplayText(
                          text: "Rating",
                          lines: 1,
                          style: Theme.of(context).textTheme.headlineSmall!),
                      RatingBarIndicator(
                        rating: listing.rating!,
                        itemBuilder: (context, index) {
                          return Icon(
                            Icons.star_rounded,
                            color: Theme.of(context).primaryColor,
                          );
                        },
                        itemCount: 5,
                        itemSize: 25,
                        direction: Axis.horizontal,
                      ),
                      DisplayText(
                        text: "Amenities",
                        lines: 1,
                        style: Theme.of(context).textTheme.headlineSmall!,
                      ),
                      DisplayText(
                        text: "Reviews",
                        lines: 1,
                        style: Theme.of(context).textTheme.headlineSmall!,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];

                          return ReviewCard(
                            reviewModel: review,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ImageSlider extends StatefulWidget {
  final ListingModel listing;
  const ImageSlider({super.key, required this.listing});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  Widget build(BuildContext context) {
    // int currentImageIndex = 0;
    // int maxImageIndex = widget.listing.images!.length;
    // CarouselController carouselController = CarouselController();
    
    return Stack(
      children: [
        CarouselSlider(
          // carouselController: carouselController,
          options: CarouselOptions(
            viewportFraction: 1.0,
            height: 250.0,
            enlargeFactor: .2,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            padEnds: true,
            onPageChanged: (index, reason) {
              setState(() {
                // currentImageIndex = index;
                // debugPrint("this is the index $index");
              });
            },
          ),
          items: widget.listing.images!
              .map<Widget>((e) => DisplayImage(
                  path:
                      "${widget.listing.owner}/listingImages/${widget.listing.id}$e",
                  height: 250,
                  width: double.infinity))
              .toList(),
        ),
        // if (currentImageIndex > 0)
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Container(
          //     height: 35,
          //     width: 35,
          //     decoration: BoxDecoration(
          //       color: Colors.grey[800],
          //       borderRadius: BorderRadius.circular(50),
          //     ),
          //     child: IconButton(
          //         icon: const Icon(
          //           Icons.arrow_back_ios,
          //           color: Colors.white,
          //           size: 15,
          //         ),
          //         onPressed: () {
          //           carouselController.previousPage();
          //         }),
          //   ),
          // ),
        // if (currentImageIndex <= maxImageIndex)
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Container(
          //     height: 35,
          //     width: 35,
          //     decoration: BoxDecoration(
          //       color: Colors.grey[800],
          //       borderRadius: BorderRadius.circular(50),
          //     ),
          //     child: IconButton(
          //         icon: const Icon(
          //           Icons.arrow_forward_ios,
          //           color: Colors.white,
          //           size: 15,
          //         ),
          //         onPressed: () {
          //           carouselController.nextPage();
          //         }),
          //   ),
          // ),
      ],
    );
  }
}
