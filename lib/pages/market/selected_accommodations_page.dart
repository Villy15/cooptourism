// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/models/review.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/review_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/pages/market/customer/book_service.dart';
// import 'package:cooptourism/pages/market/customer/buy_product.dart';
import 'package:cooptourism/pages/market/listing_edit.dart';
import 'package:cooptourism/pages/market/listing_messages_inbox.dart';
import 'package:cooptourism/pages/market/map_page.dart';
import 'package:cooptourism/pages/market/reviews_page.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/providers/user_provider.dart';
// import 'package:cooptourism/widgets/bottom_nav_selected_listing.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:cooptourism/widgets/leading_back_button.dart';
import 'package:cooptourism/widgets/listing_display_description.dart';
import 'package:cooptourism/widgets/listing_image_slider.dart';
import 'package:cooptourism/widgets/listing_manager_rail_menu.dart';
// import 'package:dots_indicator/dots_indicator.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

final UserRepository userRepository = UserRepository();

class SelectedAccommodationsPage extends ConsumerStatefulWidget {
  final ListingModel listing;
  const SelectedAccommodationsPage({super.key, required this.listing});

  @override
  ConsumerState<SelectedAccommodationsPage> createState() =>
      _SelectedAccommodationsPageState();
}

class _SelectedAccommodationsPageState
    extends ConsumerState<SelectedAccommodationsPage> {
  String? role;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = false;
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  }

  int railIndex = 0;
  @override
  Widget build(BuildContext context) {
    CooperativesRepository cooperativesRepository = CooperativesRepository();
    Future<List<String>> cooperativeNames = cooperativesRepository
        .getCooperativeNames(ref.watch(userModelProvider)!.cooperativesJoined!);
    final user = ref.watch(userModelProvider);
    role = user?.role ?? 'Customer';

    void showSnackBar(BuildContext context, String text) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(text),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
    }

    final List<String> images = [
      'https://via.placeholder.com/150',
      'https://via.placeholder.com/200',
      'https://via.placeholder.com/250',
      // Add more image URLs as needed
    ];

// Define a list of bedrooms
    final List<String> bedrooms = [
      'Bedroom 1',
      'Bedroom 2',
      'Bedroom 3',
      // Add more bedrooms as needed
    ];

// Define a list of beds
    final List<String> beds = [
      '2 queen beds',
      '1 king bed',
      '1 single bed',
      // Add more beds as needed
    ];

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
        body: FutureBuilder(
            future: cooperativeNames,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final names = snapshot.data!;
              return Stack(
                children: [
                  if (railIndex == 0)
                    viewListing(
                      widget.listing,
                      context,
                      showSnackBar,
                      images,
                      bedrooms,
                      beds,
                    ),
                  if (railIndex == 1)
                    ListingMessagesInbox(
                      listingId: widget.listing.id!,
                    ),
                  if (railIndex == 2)
                    ListingEdit(
                      listing: widget.listing,
                    ),
                  if (ref.watch(userModelProvider)!.role == "Manager" &&
                      names.contains(widget.listing.cooperativeOwned) == true)
                    ListingManagerRailMenu(
                      railIndex: railIndex,
                      onDestinationSelected: (index) {
                        setState(() {
                          railIndex = index;
                        });
                      },
                      listingId: widget.listing.id!,
                    ),
                ],
              );
            }),
        bottomNavigationBar: railIndex == 0
            ? BottomAppBar(
                surfaceTintColor: Colors.white,
                height: 90,
                child: customerRow(widget.listing))
            : null,
      ),
    );
  }

  ListView viewListing(
      ListingModel listing,
      BuildContext context,
      void Function(BuildContext context, String text) showSnackBar,
      List<String> images,
      List<String> bedrooms,
      List<String> beds) {
    final ReviewRepository reviewRepository = ReviewRepository();

    final Stream<List<ReviewModel>> reviews =
        reviewRepository.getAllListingReviews(widget.listing.id!);

    return ListView(
      padding: const EdgeInsets.only(top: 0),
      children: [
        ListingImageSlider(listing: listing),
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
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10.0),
              //   child: DisplayText(
              //       text: "₱${listing.price!.toStringAsFixed(2)}",
              //       lines: 1,
              //       style: const TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w500,
              //       )),
              // ),
              DisplayText(
                text:
                    "Location: ${listing.province ?? ''}, ${listing.city ?? ''}",
                lines: 4,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelLarge?.fontSize),
              ),
              DisplayText(
                text:
                    "${listing.pax ?? 1} guests · ${listing.type ?? ''} · ${listing.category ?? ''}",
                lines: 1,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelLarge?.fontSize),
              ),

              StreamBuilder(
                  stream: reviews,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }

                    final reviews = snapshot.data!;
                    return Row(
                      children: [
                        Icon(Icons.star_rounded,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 5),
                        DisplayText(
                          text: "${listing.rating ?? 0.00}",
                          lines: 1,
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.fontSize),
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            if (reviews.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('No reviews'),
                                  action: SnackBarAction(
                                    label: 'Close',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReviewsPage(
                                        review: reviews, listing: listing)),
                              );
                            }
                          },
                          child: Text(
                            '${reviews.length} reviews',
                            style: const TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    );
                  }),

              const Divider(),

              DisplayText(
                text: 'Description',
                lines: 1,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              listingDisplayDescription(listing, context),

              const Divider(),

              // Where you'll sleep
              DisplayText(
                text: 'Where you\'ll sleep',
                lines: 1,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                ),
              ),

              // Generate me a list of cards with an image, Bedroom 1, 2 queen beds that is scrollable horizontally
              SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Card(
                      elevation: 0,
                      surfaceTintColor:
                          Theme.of(context).colorScheme.background,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(images[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(bedrooms[0],
                                style: Theme.of(context).textTheme.labelLarge!),
                            Text(beds[0]),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      surfaceTintColor:
                          Theme.of(context).colorScheme.background,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(images[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(bedrooms[1],
                                style: Theme.of(context).textTheme.labelLarge!),
                            Text(beds[1]),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      surfaceTintColor:
                          Theme.of(context).colorScheme.background,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(images[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(bedrooms[2],
                                style: Theme.of(context).textTheme.labelLarge!),
                            Text(beds[2]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              DisplayText(
                text: 'Where you\'ll go',
                lines: 1,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                ),
              ),

              Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: 350,
                        height: 200,
                        child: MapSample(
                          address:
                              '${listing.province ?? ''}, ${listing.city ?? 'Philippines'}',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  )),

              const Divider(),

              // Hosted by owner
              ListTile(
                leading: DisplayImage(
                    path: '${listing.owner}/images/pfp.jpg',
                    height: 40,
                    width: 40,
                    radius: BorderRadius.circular(20)),
                // Contact owner
                trailing: IconButton(
                  onPressed: () {
                    // Show snackbar with reviews
                    showSnackBar(context, 'Contact owner');
                  },
                  icon: const Icon(Icons.message_rounded),
                ),
                title: Text(
                    'Hosted by ${listing.ownerMember ?? 'Timothy Mendoza'}',
                    style: Theme.of(context).textTheme.labelLarge),
                subtitle: Text(
                    listing.cooperativeOwned ??
                        'Iwahori Multi-Purpose Cooperative',
                    style: Theme.of(context).textTheme.bodySmall),
              ),

              const Divider(),

              const SizedBox(
                height: 100,
              ),
              // StreamBuilder<List<ReviewModel>>(
              //   stream: reviews,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     }

              //     if (snapshot.connectionState ==
              //         ConnectionState.waiting) {
              //       return const Center(
              //           child: CircularProgressIndicator());
              //     }
              //     final reviews = snapshot.data!;
              //     return Padding(
              //       padding: const EdgeInsets.only(top: 20.0),
              //       child: Column(
              //         children: [
              //           DisplayText(
              //             text: "Reviews",
              //             lines: 1,
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .labelLarge!,
              //           ),
              //           reviews.isEmpty
              //               ? const Center(
              //                   child: Text('No reviews'))
              //               : ListView.builder(
              //                   padding:
              //                       const EdgeInsets.only(top: 0),
              //                   physics:
              //                       const NeverScrollableScrollPhysics(),
              //                   shrinkWrap: true,
              //                   itemCount: reviews.length,
              //                   itemBuilder: (context, index) {
              //                     final review = reviews[index];
              //                     return ReviewCard(
              //                       reviewModel: review,
              //                     );
              //                   },
              //                 ),
              //         ],
              //       ),
              //     );
              //   },
              // ),

              // if (role == 'Customer')
              // customerFunctions(context, listing)
            ],
          ),
        ),
      ],
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              // Make it wider
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(180, 45)),
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
                            : BookServicePage(listing: listing)));
              },
              child: const Text('Book Now'),
            ),
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
