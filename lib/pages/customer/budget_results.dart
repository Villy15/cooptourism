import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooptourism/data/models/itineraries.dart';
import 'package:cooptourism/data/repositories/itinerary_repository.dart';
import 'package:cooptourism/pages/customer/itenerary_page.dart';
// import 'package:cooptourism/pages/customer/city_page.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetResultPage extends ConsumerStatefulWidget {
  final RangeValues currentRangeValues;

  const BudgetResultPage({Key? key, required this.currentRangeValues})
      : super(key: key);

  @override
  ConsumerState<BudgetResultPage> createState() => _BudgetResultPageState();
}

final ItineraryRepository itineraryRepository = ItineraryRepository();

class _BudgetResultPageState extends ConsumerState<BudgetResultPage> {
  late RangeValues currentRangeValues;

  @override
  void initState() {
    super.initState();
    currentRangeValues = widget.currentRangeValues;
    debugPrint("Curent range values: $currentRangeValues");
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = false;
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        ref.read(appBarVisibilityProvider.notifier).state = true;
        ref.read(navBarVisibilityProvider.notifier).state = true;
        return true;
      },
      child: Scaffold(
          appBar: _appBar(context, "Results Budget"),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                resultsHeading(context),
                StreamBuilder<List<ItineraryModel>>(
                  stream: itineraryRepository.filterBudget(currentRangeValues),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final itineraries = snapshot.data!;

                    // if empty
                    if (itineraries.isEmpty) {
                      return const Center(
                        child: Text("No results found"),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itineraries.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IteneraryPage(
                                  itinerary: itineraries[index],
                                ),
                              ),
                            );
                          },
                          child: budgetCard(itineraries[index])
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }

  Padding budgetCard(ItineraryModel itinerary) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
        child: Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (itinerary.images != null &&
                    itinerary.images!.isNotEmpty) ...[
                  itineraryImage(context, itinerary),
                ] else ...[
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        child: Text("${itinerary.days} days",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(itinerary.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        child: Text(
                            itinerary.description ?? "No description available",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400)),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        child: Text("~₱${itinerary.budget}",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400)),
                      ),

                      const Spacer(),

                      // Create tags for the location
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: itinerary.tags!
                                .map((activity) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 6.0),
                                          child: Text(activity,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )));
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
            width: 120,
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

  Padding resultsHeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Text(
            "Palawan < ₱${widget.currentRangeValues.end.round()} a day",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              _showFilterByBudget(context);
            },
            icon: Icon(Icons.filter_list,
                color: Theme.of(context).colorScheme.primary),
          )
        ],
      ),
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
              height: 200,
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
                      // Change the state of the currentRangeValues
                      setState(() {
                        currentRangeValues = currentRangeValues;
                      });
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

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                // context.push('/market_page/add_listing');
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
