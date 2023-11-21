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

  int navigationRailIndex = 0;
  bool railVisibility = false;
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

    // ignore: deprecated_member_use
    return WillPopScope(
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
                return Stack(
                  children: [
                    ListView(
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
                                    lines: 2,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: DisplayText(
                                  text: "Description: ${listing.description!}",
                                  lines: 10,
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.fontSize,
                                  ),
                                ),
                              ),
                              DisplayText(
                                text: "Category: ${listing.category!}",
                                lines: 4,
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.fontSize),
                              ),
                              DisplayText(
                                text: "Type: ${listing.type!}",
                                lines: 4,
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.fontSize),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: DisplayText(
                                    text: "Rating",
                                    lines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!),
                              ),
                              RatingBarIndicator(
                                rating:
                                    listing.rating?.toDouble() ?? 0.toDouble(),
                                itemBuilder: (context, index) {
                                  return Icon(
                                    Icons.star_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  );
                                },
                                itemCount: 5,
                                itemSize: 25,
                                direction: Axis.horizontal,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: DisplayText(
                                  text: "Reviews",
                                  lines: 1,
                                  style:
                                      Theme.of(context).textTheme.labelLarge!,
                                ),
                              ),
                              reviews.isEmpty
                                  ? const Center(child: Text('No reviews'))
                                  : ListView.builder(
                                      padding: const EdgeInsets.only(top: 0),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!,
                                  ),
                                ),
                              // if (role == 'Customer')
                              // customerFunctions(context, listing)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20))),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    railVisibility = !railVisibility;
                                  });
                                },
                                icon: const Icon(
                                    Icons.settings_accessibility_rounded),
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                            if (railVisibility == true)
                              Container(
                                height: MediaQuery.sizeOf(context).height,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20))),
                                child: NavigationRail(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  minWidth: 56,
                                  selectedIndex: navigationRailIndex,
                                  groupAlignment: 0,
                                  unselectedIconTheme: IconThemeData(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background),
                                  onDestinationSelected: (int index) {
                                    setState(() {
                                      navigationRailIndex = index;
                                    });
                                  },
                                  labelType: NavigationRailLabelType.none,
                                  destinations: const <NavigationRailDestination>[
                                    NavigationRailDestination(
                                      icon: Icon(Icons.message_rounded),
                                      selectedIcon: Icon(Icons.favorite),
                                      label: Text('Messages'),
                                    ),
                                    NavigationRailDestination(
                                      icon: Icon(Icons.edit_document),
                                      selectedIcon: Icon(Icons.book),
                                      label: Text('Edit Listing'),
                                    ),
                                    NavigationRailDestination(
                                      icon: Icon(Icons.task),
                                      selectedIcon: Icon(Icons.star),
                                      label: Text('Tasks'),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
        bottomNavigationBar: role == 'Customer'
            ? BottomAppBar(
                surfaceTintColor: Colors.white,
                height: 90,
                child: FutureBuilder(
                    future: listings,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final listing = snapshot.data!;
                      return customerRow(listing);
                    }),
              )
            : BottomNavSelectedListing(listingId: widget.listingId),
      ),
    );
  }

  Row customerRow(ListingModel listing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      Text('₱${listing.price!.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('/night',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            // Make it wider
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(const Size(180, 45)),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => listing.type ==
                              // If service show book service page
                              'Service'
                          ? BookServicePage(listing: listing)

                          // If product show buy product page
                          : BuyProductPage(listing: listing)));
            },
            child: const Text('Book Now'),
          ),
        ),
      ],
    );
  }

  // Padding customerFunctions(BuildContext context, ListingModel listing) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 160.0),
  //     child: Align(
  //       alignment: Alignment.bottomCenter,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           // Create a button that is an icon inside a container to favorite the listing
  //           ElevatedButton(
  //             onPressed: () {
  //               // context.go("/booking_page/${listing.id}");
  //             },
  //             child: const Padding(
  //               padding: EdgeInsets.symmetric(vertical: 16.0),
  //               child: Icon(Icons.favorite_border_rounded),
  //             ),
  //           ),

  //           const SizedBox(width: 10),

  //           ElevatedButton(
  //             onPressed: () {
  //               // context.go("/booking_page/${listing.id}");
  //             },
  //             style: ElevatedButton.styleFrom(
  //               foregroundColor: Theme.of(context).colorScheme.primary,
  //               backgroundColor:
  //                   Theme.of(context).colorScheme.secondary, // Text color
  //             ),
  //             child: const Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
  //               child: Text("Contact", style: TextStyle(fontSize: 20)),
  //             ),
  //           ),

  //           const SizedBox(width: 10),

  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => listing.type ==
  //                               // If service show book service page
  //                               'Service'
  //                           ? BookServicePage(listing: listing)

  //                           // If product show buy product page
  //                           : BuyProductPage(listing: listing)));
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(
  //                   horizontal: 10.0, vertical: 16.0),
  //               child: Text(
  //                   // If type is Service then display "Book" else display "Rent"
  //                   listing.type == 'Service' ? "Book Now" : "Buy Now",
  //                   style: const TextStyle(fontSize: 20)),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
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
                          "${widget.listing.cooperativeOwned}/listingImages/$e",
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
