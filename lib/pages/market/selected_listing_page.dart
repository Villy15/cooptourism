// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/models/review.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/review_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/pages/market/customer/book_service.dart';
import 'package:cooptourism/pages/market/customer/buy_product.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:cooptourism/widgets/bottom_nav_selected_listing.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:cooptourism/widgets/leading_back_button.dart';
import 'package:cooptourism/widgets/review_card.dart';
import 'package:dots_indicator/dots_indicator.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final UserRepository userRepository = UserRepository();

class SelectedListingPage extends ConsumerStatefulWidget {
  final String listingId;
  const SelectedListingPage({super.key, required this.listingId});

  @override
  ConsumerState<SelectedListingPage> createState() =>
      _SelectedListingPageState();
}

class _SelectedListingPageState extends ConsumerState<SelectedListingPage> {
  String? role;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = false;
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ListingRepository listingRepository = ListingRepository();
    final ReviewRepository reviewRepository = ReviewRepository();

    final Future<ListingModel> listings =
        listingRepository.getSpecificListing(widget.listingId);

    final Stream<List<ReviewModel>> reviews =
        reviewRepository.getAllListingReviews(widget.listingId);

    final user = ref.watch(userModelProvider);
    role = user?.role ?? 'Customer';

    return WillPopScope (
      onWillPop: () async {
        ref.read(navBarVisibilityProvider.notifier).state = true;
        ref.read(appBarVisibilityProvider.notifier).state = true;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            leadingWidth: 45,
            toolbarHeight: 35,
            leading: LeadingBackButton(ref: ref)),
        extendBodyBehindAppBar: true,
        body: FutureBuilder<ListingModel>(
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
                  padding: const EdgeInsets.only(top: 0),
                  children: [
                    ImageSlider(listing: listing),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: DisplayText(
                                text: listing.title!,
                                lines: 1,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: DisplayText(
                                text: "₱${listing.price!.toStringAsFixed(2)}",
                                lines: 1,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                )),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: DisplayText(
                              text: "Desrciption: ${listing.description!}",
                              lines: 5,
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.fontSize,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: DisplayText(
                                text: "Rating",
                                lines: 1,
                                style:
                                    Theme.of(context).textTheme.headlineSmall!),
                          ),
                          RatingBarIndicator(
                            rating: listing.rating!.toDouble(),
                            itemBuilder: (context, index) {
                              return Icon(
                                Icons.star_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              );
                            },
                            itemCount: 5,
                            itemSize: 25,
                            direction: Axis.horizontal,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: DisplayText(
                              text: "Amenities",
                              lines: 1,
                              style: Theme.of(context).textTheme.headlineSmall!,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: DisplayText(
                              text: "Reviews",
                              lines: 1,
                              style: Theme.of(context).textTheme.headlineSmall!,
                            ),
                          ),
                          reviews.isEmpty
                              ? const Center(child: Text('No reviews'))
                              : ListView.builder(
                                  padding: const EdgeInsets.only(top: 0),
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
                          if (listing.ownerMember != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: DisplayText(
                                text: "Owner Information",
                                lines: 1,
                                style: Theme.of(context).textTheme.headlineSmall!,
                              ),
                            ),
                          if (listing.ownerMember != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 10.0),
                              child: ownerListing(listing: listing),
                            ),
                          if (role == 'Customer') customerFunctions(context, listing)
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        bottomNavigationBar: role == 'Customer'
            ? null
            : BottomNavSelectedListing(listingId: widget.listingId),
      ),
    );
  }

  Padding customerFunctions(BuildContext context, ListingModel listing) {
    return Padding(
      padding: const EdgeInsets.only(top: 160.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Create a button that is an icon inside a container to favorite the listing
            ElevatedButton(
              onPressed: () {
                // context.go("/booking_page/${listing.id}");
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Icon(Icons.favorite_border_rounded),
              ),
            ),

            const SizedBox(width: 10),

            ElevatedButton(
              onPressed: () {
                // context.go("/booking_page/${listing.id}");
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor:
                    Theme.of(context).colorScheme.secondary, // Text color
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                child: Text("Contact", style: TextStyle(fontSize: 20)),
              ),
            ),

            const SizedBox(width: 10),


            ElevatedButton(
              onPressed: () {
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => listing.type == 
                  // If service show book service page
                  'Service' ? BookServicePage(listing: listing) 

                  // If product show buy product page
                  : BuyProductPage(listing: listing))
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                child: Text(
                  // If type is Service then display "Book" else display "Rent"
                  listing.type == 'Service' ? "Book Now" : "Buy Now"
                  
                  , style: const TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row ownerListing({required ListingModel listing}) {
    return Row(
      children: [
        Container(
          width: 50, // Adjust width as needed
          height: 50, // Adjust height as needed
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary, // Color of the border
              width: 2, // Width of the border
            ),
            shape: BoxShape.circle, // Shape of the Container
          ),
          child: const Icon(
            Icons.person,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FutureBuilder(
            future: userRepository.getUser(listing.ownerMember!),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final user = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DisplayText(
                    text: "${user.firstName!} ${user.lastName!}",
                    lines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DisplayText(
                    text:
                        "Cooperative members since ${user.joinedAt!.toDate().year}",
                    lines: 1,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
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
                });
              },
            ),
            items: widget.listing.images!
                .map<Widget>((e) => DisplayImage(
                      path:
                          "${widget.listing.owner}/listingImages/${widget.listing.id}$e",
                      height: 250,
                      width: double.infinity,
                      radius: BorderRadius.zero,
                    ))
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
