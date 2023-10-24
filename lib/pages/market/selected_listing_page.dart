// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/models/review.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/review_repository.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:cooptourism/widgets/review_card.dart';
import 'package:dots_indicator/dots_indicator.dart';
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
                        rating: listing.rating ?? 0.0,
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
  int currentImageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final decorator = DotsDecorator(
      activeColor: Colors.orange[700],
      size: const Size.square(7.5),
      activeSize: const Size.square(10.0),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      spacing: const EdgeInsets.all(2.5),
    );
    int maxImageIndex = widget.listing.images!.length;
    CarouselController carouselController = CarouselController();

    return Stack(
      children: [
        SizedBox(
          height: 250,
          child: CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              viewportFraction: 1.0,
              height: 250.0,
              enlargeFactor: 0,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  currentImageIndex = index;
                  debugPrint("this is the index $index");
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
        ),
        SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: DotsIndicator(
                      key: ValueKey(currentImageIndex),
                      dotsCount: maxImageIndex,
                      position: currentImageIndex,
                      decorator: decorator,
                    ),
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
