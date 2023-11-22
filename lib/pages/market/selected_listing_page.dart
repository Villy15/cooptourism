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
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/providers/user_provider.dart';
// import 'package:cooptourism/widgets/bottom_nav_selected_listing.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:cooptourism/widgets/leading_back_button.dart';
// import 'package:dots_indicator/dots_indicator.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

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

  int railIndex = 0;
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
            CooperativesRepository cooperativesRepository =
                CooperativesRepository();
            Future<List<String>> cooperativeNames =
                cooperativesRepository.getCooperativeNames(
                    ref.watch(userModelProvider)!.cooperativesJoined!);
            return FutureBuilder(
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
                          listing,
                          context,
                          showSnackBar,
                          images,
                          bedrooms,
                          beds,
                        ),
                      if (railIndex == 1)
                        ListingMessagesInbox(
                          listingId: listing.id!,
                        ),
                      if (railIndex == 2)
                        ListingEdit(
                          listingId: listing.id!,
                        ),
                      if (ref.watch(userModelProvider)!.role == "Manager" &&
                          names.contains(listing.cooperativeOwned) == true)
                        ManagerMenu(
                          railIndex: railIndex,
                          onDestinationSelected: (index) {
                            setState(() {
                              railIndex = index;
                            });
                          },
                          listingId: widget.listingId,
                        ),
                    ],
                  );
                });
          },
        ),
        bottomNavigationBar: railIndex == 0
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
              Row(
                children: [
                  Icon(Icons.star_rounded,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 5),
                  DisplayText(
                    text: "${listing.rating ?? 0}",
                    lines: 1,
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize),
                  ),
                  const SizedBox(width: 5),
                  TextButton(
                      onPressed: () {
                        // Show snackbar with reviews
                        showSnackBar(context, 'Reviews');
                      },
                      child: const Text('13 reviews',
                          style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.underline))),
                ],
              ),

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

              descriptionText(listing, context),

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

  String addSpaces(String description) {
    List<String> sentences = description.split('. ');
    for (int i = 3; i < sentences.length; i += 4) {
      sentences[i] = '\n\n\n${sentences[i]}';
    }
    return sentences.join('.');
  }

  Column descriptionText(ListingModel listing, BuildContext context) {
    String descriptionWithSpaces = addSpaces(listing.description!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: DisplayText(
            text: descriptionWithSpaces,
            lines: 5,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            showModalBottomSheet(
              // show indicator drag
              isScrollControlled: true,
              enableDrag: true,
              showDragHandle: true,
              context: context,
              builder: (context) {
                return Container(
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DisplayText(
                          text: 'About this Space',
                          lines: 1,
                          style: Theme.of(context).textTheme.titleLarge!,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          descriptionWithSpaces,
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('Show More'),
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
                          : BookServicePage(listing: listing)));
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
    // final decorator = DotsDecorator(
    //   activeColor: Colors.orange[700],
    //   size: const Size.square(7.5),
    //   activeSize: const Size.square(10.0),
    //   activeShape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(20.0),
    //   ),
    //   spacing: const EdgeInsets.all(2.5),
    // );
    int maxImageIndex = widget.listing.images!.length;
    CarouselController carouselController = CarouselController();

    return Stack(
      children: [
        InkWell(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return FractionallySizedBox(
                  heightFactor: 0.9,
                  child: GridView.count(
                    crossAxisCount: 1,
                    children: widget.listing.images!
                        .map<Widget>((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DisplayImage(
                                path:
                                    "${widget.listing.cooperativeOwned}/listingImages/$e",
                                height: 250,
                                width: double.infinity,
                                radius: BorderRadius.zero,
                              ),
                            ))
                        .toList(),
                  ),
                );
              },
            );
          },
          child: SizedBox(
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
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Text(
                '${currentImageIndex + 1} / $maxImageIndex',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 250,
        //   child: Padding(
        //     padding: const EdgeInsets.only(bottom: 10.0),
        //     child: Align(
        //       alignment: Alignment.bottomCenter,
        //       child: Container(
        //         decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.circular(25)),
        //         child: Padding(
        //           padding: const EdgeInsets.all(2.5),
        //           child: DotsIndicator(
        //             key: ValueKey(currentImageIndex),
        //             dotsCount: maxImageIndex,
        //             position: currentImageIndex,
        //             decorator: decorator,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class ManagerMenu extends StatefulWidget {
  final int railIndex;
  final Function onDestinationSelected;
  final String listingId;
  const ManagerMenu({
    super.key,
    required this.railIndex,
    required this.onDestinationSelected,
    required this.listingId,
  });

  @override
  State<ManagerMenu> createState() => _ManagerMenuState();
}

class _ManagerMenuState extends State<ManagerMenu> {
  bool railVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
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
                    bottomLeft: Radius.circular(20)),
              ),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      railVisibility = !railVisibility;
                    });
                  },
                  icon: const Icon(Icons.settings_accessibility_rounded)),
            ),
            if (railVisibility == true)
              Container(
                height: MediaQuery.sizeOf(context).height,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                child: NavigationRail(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minWidth: 56,
                  selectedIndex: widget.railIndex,
                  groupAlignment: 0,
                  unselectedIconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.background),
                  onDestinationSelected: (int index) {
                    widget.onDestinationSelected(index);
                  },
                  labelType: NavigationRailLabelType.none,
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.remove_red_eye_rounded),
                      selectedIcon: Icon(Icons.remove_red_eye_rounded),
                      label: Text('View'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.message_rounded),
                      selectedIcon: Icon(Icons.message_rounded),
                      label: Text('Chat'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.edit_outlined),
                      selectedIcon: Icon(Icons.edit_outlined),
                      label: Text('Edit'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.task),
                      selectedIcon: Icon(Icons.task),
                      label: Text('Tasks'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
