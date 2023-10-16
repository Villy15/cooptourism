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

class SelectedListingPage extends StatefulWidget {
  final String listingId;
  const SelectedListingPage({super.key, required this.listingId});

  @override
  State<SelectedListingPage> createState() => _SelectedListingPageState();
}

class _SelectedListingPageState extends State<SelectedListingPage> {
  @override
  Widget build(BuildContext context) {
    // final storageRef = FirebaseStorage.instance.ref();
    final ListingRepository listingRepository = ListingRepository();
    final ReviewRepository reviewRepository = ReviewRepository();

    final Future<ListingModel> listings =
        listingRepository.getSpecificListing(widget.listingId);

    final Stream<List<ReviewModel>> reviews =
        reviewRepository.getAllListingReviews(widget.listingId);

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                    height: 250.0,
                    enlargeFactor: .2,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    padEnds: true,
                  ),
                  items: listing.images!
                      .map<Widget>((e) => DisplayImage(
                          path:
                              "${listing.owner}/listingImages/${listing.id}$e",
                          height: 250,
                          width: double.infinity))
                      .toList(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            fontSize:
                                Theme.of(context).textTheme.headlineSmall?.fontSize,
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
                        Expanded(
                          child: ListView.builder(
                            itemCount: reviews.length,
                            itemBuilder: (context, index) {
                              final review = reviews[index];
                                  
                              return ReviewCard(
                                reviewModel: review,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
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
