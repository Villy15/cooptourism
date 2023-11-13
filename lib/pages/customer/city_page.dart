import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/itineraries.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/models/locations.dart';
import 'package:cooptourism/data/repositories/itinerary_repository.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/pages/customer/budget_results.dart';
import 'package:cooptourism/pages/customer/home_page.dart';
import 'package:cooptourism/pages/customer/itenerary_page.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/providers/listing_provider.dart';
import 'package:cooptourism/widgets/leading_back_button.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final ItineraryRepository itineraryRepository = ItineraryRepository();
final ListingRepository listingRepository = ListingRepository();

class CityPage extends ConsumerStatefulWidget {
  final String? cityId;
  final LocationModel? locationModel;

  const CityPage({super.key, this.cityId, this.locationModel});

  @override
  ConsumerState<CityPage> createState() => _CityPageState();
}

class _CityPageState extends ConsumerState<CityPage> {
  RangeValues currentRangeValues = const RangeValues(1000, 20000);

  @override
  void initState() {
    super.initState();
    // itineraryRepository.deleteAllItinerary();
    // itineraryRepository.addItineraryManually();
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = false;
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  } 
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          ref.read(appBarVisibilityProvider.notifier).state = true;
          ref.read(navBarVisibilityProvider.notifier).state = true;
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              leadingWidth: 45,
              toolbarHeight: 35,
              leading: LeadingBackButton(ref: ref)),
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageSlider(location: widget.locationModel!),
                buildTitle(),
                buildDivider(),
                filterBudget(context),
                buildTourPackage(),
                buildServices(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding servicesText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
      child: Text(text,
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
    );
  }

  Widget buildServices() {
    return FutureBuilder(
      future: listingRepository.getListingsByCity(widget.locationModel!.city),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // show a loader while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<ListingModel> listings = snapshot.data as List<ListingModel>;

        // If listing is empty return nothing
        if (listings.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            servicesText("Services"),
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
              ),
              itemCount:
                  listings.length, // Change this to the number of items you have
              itemBuilder: (context, index) {
                ListingModel listingModel = listings[index];

                return GestureDetector(
                  onTap: () {
                    ref
                        .read(listingModelProvider.notifier)
                        .setListing(listingModel);
                    context.push('/market_page/${listingModel.id}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (listingModel.images != null &&
                              listingModel.images!.isNotEmpty) ...[
                            listingImage(context, listingModel),
                          ] else ...[
                            Container(
                              height: 150.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("₱${listingModel.price}",
                                style: const TextStyle(
                                    fontSize: 14.0, fontWeight: FontWeight.w400)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(listingModel.title!,
                                style: const TextStyle(
                                    fontSize: 12.0, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  FutureBuilder<List<ItineraryModel>> buildTourPackage() {
    return FutureBuilder(
      future: itineraryRepository.filterCityFuture(widget.locationModel!.city),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // show a loader while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No Iteneraries available');
        } else {
          return GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
            ),
            itemCount: snapshot
                .data!.length, // Change this to the number of items you have
            itemBuilder: (context, index) {
              ItineraryModel itineraryModel = snapshot.data![index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          IteneraryPage(itinerary: itineraryModel),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (itineraryModel.images != null &&
                            itineraryModel.images!.isNotEmpty) ...[
                          itineraryImage(context, itineraryModel),
                        ] else ...[
                          Container(
                            height: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                              "${itineraryModel.days} days - ₱${itineraryModel.budget}",
                              style: const TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(itineraryModel.name,
                              style: const TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Padding filterBudget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Tour Packages",
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
          Row(
            children: [
              const Text("Filter by budget",
                  style:
                      TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
              IconButton(
                onPressed: () {
                  _showFilterByBudget(context);
                },
                icon: const Icon(Icons.filter_list, color: primaryColor),
              ),
            ],
          )
        ],
      ),
    );
  }

  Padding buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider(
        height: 1,
        thickness: 1,
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(widget.locationModel!.city,
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(widget.locationModel!.province,
                style: const TextStyle(fontSize: 16.0)),
          ),
        ],
      ),
    );
  }

  FutureBuilder listingImage(BuildContext context, ListingModel listingModel) {
    final storageRef = FirebaseStorage.instance.ref();
    String imagePath =
        "${listingModel.owner}/listingImages/${listingModel.id}${listingModel.images![0]}";

    return FutureBuilder(
      future: storageRef.child(imagePath).getDownloadURL(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // show a loader while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No Events available');
        } else {
          String imageUrl = snapshot.data as String;
          return Container(
            height: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
        }
      },
    );
  }

  FutureBuilder itineraryImage(
      BuildContext context, ItineraryModel itineraryModel) {
    final storageRef = FirebaseStorage.instance.ref();
    String imagePath = "itineraries/${itineraryModel.images?[0]}";

    return FutureBuilder(
      future: storageRef.child(imagePath).getDownloadURL(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // show a loader while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No Events available');
        } else {
          String imageUrl = snapshot.data as String;
          return Container(
            height: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
        }
      },
    );
  }

  void _showFilterByBudget(BuildContext context) {
    double minBudget = 0;
    double maxBudget = 50000;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Using a StatefulBuilder to manage state inside the modal
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 250,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Filter by Budget',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RangeSlider(
                    values: currentRangeValues,
                    min: minBudget,
                    max: maxBudget,
                    divisions: 50,
                    onChanged: (RangeValues values) {
                      setModalState(() {
                        // Use setModalState to update modal's internal state
                        currentRangeValues = values;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          "₱${currentRangeValues.start.round()}",
                        ),
                        const Spacer(),
                        Text("₱${currentRangeValues.end.round()}"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('Apply Filter'),
                    onPressed: () {
                      // Use Navigator.pop to return the selected range values to the main page
                      Navigator.pop(context, currentRangeValues);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BudgetResultPage(
                                  currentRangeValues: currentRangeValues)));
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((returnedValues) {
      if (returnedValues != null && returnedValues is RangeValues) {
        setState(() {
          currentRangeValues = returnedValues;
          // Here you could also call a method to filter your content based on the new range
        });
      }
    });
  }

  // AppBar _appBar(BuildContext context, String title) {
  //   return AppBar(
  //     toolbarHeight: 70,
  //     title: Text(title,
  //         style: TextStyle(
  //             fontSize: 28, color: Theme.of(context).colorScheme.primary)),
  //     iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
  //     actions: [
  //       Padding(
  //         padding: const EdgeInsets.only(right: 16.0),
  //         child: CircleAvatar(
  //           backgroundColor: Colors.grey.shade300,
  //           child: IconButton(
  //             onPressed: () {
  //               // context.push('/market_page/add_listing');
  //             },
  //             icon: const Icon(Icons.add, color: Colors.white),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class ImageSlider extends StatefulWidget {
  final LocationModel location;
  const ImageSlider({super.key, required this.location});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final storageRef = FirebaseStorage.instance.ref();
  int currentImageIndex = 0;

  List<String>? imageUrls;

  @override
  void initState() {
    super.initState();
    _fetchImageUrls();
  }

  Future<void> _fetchImageUrls() async {
    List<String> urls =
        await locationRepository.getEventImageUrls(widget.location.images!);
    setState(() {
      imageUrls = urls;
    });
  }

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
    int maxImageIndex = widget.location.images!.length;
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
            items: imageUrls != null
                ? imageUrls!
                    .map<Widget>(
                      (url) => CachedNetworkImage(
                        imageUrl: url,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    )
                    .toList()
                : [const Center(child: CircularProgressIndicator())],
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
