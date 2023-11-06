import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/itineraries.dart';
import 'package:cooptourism/data/repositories/itinerary_repository.dart';
import 'package:cooptourism/pages/customer/add_activity.dart';
import 'package:flutter/material.dart';

final ItineraryRepository itineraryRepository = ItineraryRepository();

class IteneraryPage extends StatefulWidget {
  final ItineraryModel itinerary;
  const IteneraryPage({super.key, required this.itinerary});

  @override
  State<IteneraryPage> createState() => _IteneraryPageState();
}

class _IteneraryPageState extends State<IteneraryPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   for (int i = 1; i <= 5; i++) {
  //     List<ActivityModel> dailyActivities;
  //     switch (i) {
  //       case 1:
  //         dailyActivities = [
  //           ActivityModel(
  //             datetime: DateTime(2023, 11, 7, 9, 0),
  //             description: "Breakfast at XYZ Cafe",
  //             location: "XYZ Cafe, Puerto Princesa",
  //             activityType: "Food",
  //           ),
  //           ActivityModel(
  //             datetime: DateTime(2023, 11, 7, 12, 0),
  //             description: "Underground River Tour",
  //             location: "Puerto Princesa Underground River",
  //             activityType: "Adventure",
  //           ),
  //         ];
  //         break;
  //       case 2:
  //         dailyActivities = [
  //           ActivityModel(
  //             datetime: DateTime(2023, 11, 8, 9, 0),
  //             description: "Island Hopping",
  //             location: "Honda Bay",
  //             activityType: "Adventure",
  //           ),
  //           ActivityModel(
  //             datetime: DateTime(2023, 11, 8, 19, 0),
  //             description: "Dinner at ABC Restaurant",
  //             location: "ABC Restaurant, Puerto Princesa",
  //             activityType: "Food",
  //           ),
  //         ];
  //         break;
  //       case 3:
  //         dailyActivities = [
  //           ActivityModel(
  //             datetime: DateTime(2023, 11, 9, 9, 0),
  //             description: "City Tour",
  //             location: "Various locations in Puerto Princesa",
  //             activityType: "Tour",
  //           ),
  //           ActivityModel(
  //             datetime: DateTime(2023, 11, 9, 19, 0),
  //             description: "Night Market Visit",
  //             location: "Puerto Princesa Night Market",
  //             activityType: "Shopping",
  //           ),
  //         ];
  //         break;
  //       case 4:
  //         dailyActivities = [
  //           ActivityModel(
  //             datetime: DateTime(2023, 11, 10, 9, 0),
  //             description: "Mangrove Paddle Boat Tour",
  //             location: "Sabang, Puerto Princesa",
  //             activityType: "Adventure",
  //           ),
  //         ];
  //         break;
  //       case 5:
  //         dailyActivities = [
  //           ActivityModel(
  //             datetime: DateTime(2023, 11, 11, 9, 0),
  //             description: "Leisure Day",
  //             location: "Various",
  //             activityType: "Leisure",
  //           ),
  //         ];
  //         break;
  //       default:
  //         dailyActivities = [];
  //     }
  //     final schedule = DaySchedModel(
  //       dayNumber: i,
  //       activities: dailyActivities,
  //     );
  //     if (widget.itinerary.uid != null) {
  //       itineraryRepository.addSchedule(widget.itinerary.uid ?? "", schedule);
  //     }
  //   }
  // }
  // final int _currentStep = 0; // to keep track of current step
  int _selectedDay = 1; // to keep track of selected day

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Itenary Page"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: itineraryRepository
                .getScheduleStream(widget.itinerary.uid ?? ""),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final schedules = snapshot.data as List<DaySchedModel>;
                // final schedule = schedules[_selectedDay - 1];
                final schedule = schedules
                    .firstWhere((element) => element.dayNumber == _selectedDay);

                return Column(
                  children: [
                    _dayTabs(schedules),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: schedule.activities.length,
                      itemBuilder: (context, index) {
                        final activity = schedule.activities[index];
                        return cardItenerary(activity);
                      },
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  // Widget cardItenerary(ActivityModel activity) {
  //   return ListTile(
  //     tileColor: Colors.red.shade100,
  //     // Make the tile bigger
  //     contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  //     // add photo on the left of the tile
  //     leading: Container(
  //       height: double.infinity,
  //       width: 100,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.rectangle,
  //         borderRadius: BorderRadius.circular(10),
  //         color: secondaryColor,
  //       ),
  //       child: Align(
  //         alignment: Alignment.center,
  //         child: Text(
  //           activity.activityType,
  //           style: const TextStyle(color: primaryColor, fontSize: 12),
  //         ),
  //       ),
  //     ),

  //     title: Text(activity.description),
  //     subtitle: Text(activity.location),
  //     trailing: Text(
  //       // Add AM or PM
  //       '${activity.datetime.hour > 12 ? activity.datetime.hour - 12 : activity.datetime.hour}:${activity.datetime.minute.toString().padLeft(2, '0')} ${activity.datetime.hour > 12 ? 'PM' : 'AM'}',
  //     ),
  //   );
  // }

  Widget cardItenerary(ActivityModel activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                color: secondaryColor,
              ),
            ),
            Expanded (
              child: SizedBox(
                // Take up the remaining space
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Text(activity.description,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(activity.location,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ],
                    ),
              
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(activity.activityType,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis
                            ),
                          Text(
                              '${activity.datetime.hour > 12 ? activity.datetime.hour - 12 : activity.datetime.hour}:${activity.datetime.minute.toString().padLeft(2, '0')} ${activity.datetime.hour > 12 ? 'PM' : 'AM'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _dayStepper() {
  //   List<Step> steps = _daysSchedule[_selectedDay - 1].activities.map((activity) {
  //     return Step(
  //       title: Text(activity.description),
  //       subtitle: Text(activity.location),
  //       content: Text(
  //         '${activity.datetime.hour}:${activity.datetime.minute.toString().padLeft(2, '0')}',
  //       ),
  //       isActive: true,
  //       state: StepState.indexed,
  //     );
  //   }).toList();

  //   return Stepper(
  //     steps: steps,
  //     currentStep: _currentStep,
  //     onStepTapped: (step) => setState(() => _currentStep = step),
  //     controlsBuilder: (BuildContext context, ControlsDetails details) {
  //       return Row(
  //         children: <Widget>[
  //           Container(
  //             child: null, // Here we do not want to show any control buttons
  //           ),
  //           Container(
  //             child: null, // Only for spacing, if needed
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _dayTabs(List<DaySchedModel> schedules) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setState(() {
              _selectedDay = index + 1;
            }),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Day",
                    style: TextStyle(
                      color: _selectedDay == index + 1
                          ? primaryColor
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: _selectedDay == index + 1
                          ? primaryColor
                          : secondaryColor,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                            color: _selectedDay == index + 1
                                ? Colors.white
                                : primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => AddActivityPage(itinerary: widget.itinerary , selectedDay: _selectedDay))
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
