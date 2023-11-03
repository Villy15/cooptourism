import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/pages/customer/budget_results.dart';
import 'package:cooptourism/widgets/leading_back_button.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CityPage extends ConsumerStatefulWidget {
  final String? cityId;
  const CityPage({Key? key, this.cityId}) : super(key: key);

  @override
  ConsumerState<CityPage> createState() => _CityPageState();
}

class _CityPageState extends ConsumerState<CityPage> {
   RangeValues currentRangeValues = const RangeValues(1000, 20000);
   
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              const ImageSlider(),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text("Palawan",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text("Puerto Prinsesa",
                          style: TextStyle(fontSize: 16.0)),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  height: 1,
                  thickness: 1,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Inteneraries",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500)),
                    Row(
                      children: [
                        const Text("Filter by budget",
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w500)),
                        IconButton(
                          onPressed: () {
                            _showFilterByBudget(context);
                          
                          },
                          icon: const Icon(Icons.filter_list,
                              color: primaryColor),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // Add a 4x4 grid of container
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,

                ),
                itemCount: 10, // Change this to the number of items you have
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container( 
                      color: Colors.white,
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150.0,
                            width: double.infinity,
                            color: primaryColor,
              
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text("8 days", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text("Puerto Princesa Underground River", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
                          )
              
              
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

void _showFilterByBudget(BuildContext context) {
    double minBudget = 0;
    double maxBudget = 50000;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Using a StatefulBuilder to manage state inside the modal
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
                      setModalState(() { // Use setModalState to update modal's internal state
                        currentRangeValues = values;
                      });
                    },
                  ),
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text("₱${currentRangeValues.start.round()}",),
                        const Spacer(),
                        Text("₱${currentRangeValues.end.round()}"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('Apply Filter'),
                    onPressed: () {
                      // Use Navigator.pop to return the selected range values to the main page
                      // Navigator.pop(context, currentRangeValues);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetResultPage(currentRangeValues: currentRangeValues)));

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
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final storageRef = FirebaseStorage.instance.ref();
  int currentImageIndex = 0;

  List<String>? imageUrls;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchImageUrls();
  // }

  // Future<void> _fetchImageUrls() async {
  //   List<String> urls = await eventsRepository.getEventImageUrls(
  //       widget.event.uid, widget.event.image!);
  //   setState(() {
  //     imageUrls = urls;
  //   });
  // }

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
    int maxImageIndex = 2;

    // int maxImageIndex = widget.event.image!.length;
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
                : [
                    CachedNetworkImage(
                      imageUrl: 'https://picsum.photos/250',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ],
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
