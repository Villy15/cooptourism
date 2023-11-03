import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetResultPage extends ConsumerStatefulWidget {
  final RangeValues currentRangeValues;

  const BudgetResultPage({Key? key, required this.currentRangeValues})
      : super(key: key);

  @override
  ConsumerState<BudgetResultPage> createState() => _BudgetResultPageState();
}

class _BudgetResultPageState extends ConsumerState<BudgetResultPage> {
  late RangeValues currentRangeValues;

  @override
  void initState() {
    super.initState();
    currentRangeValues = widget.currentRangeValues;
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = false;
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8),
                        child: Container(
                          height: 200,
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
                              Container(
                                width: 120,
                                color: Colors.red,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 12.0),
                                      child: Text("3 days",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text("Scuba Diving Palawan",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ),


                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 12.0),
                                      child: Text(
                                          "See plawanan chuchcu hcuhu c uhc hcu hcu hcuh cuh sssssssssssssshcu",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                    ),

                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 4.0),
                                      child: Text("~₱5000",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400)),
                                    ),

                                    // Create tags for the location
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 12.0),
                                      child: SingleChildScrollView (
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 6.0),
                                                child: Text("Scuba Diving",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                            const SizedBox(width: 8.0),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 6.0),
                                                child: Text("Palawan",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                            const SizedBox(width: 8.0),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 6.0),
                                                child: Text("Palawan",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  },
                ),
              ],
            ),
          )),
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
                      // Navigator.pop(context, currentRangeValues);
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
