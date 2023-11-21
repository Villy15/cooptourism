import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cooptourism/data/models/events.dart';
import 'package:cooptourism/data/repositories/events_repository.dart';
import 'package:cooptourism/data/repositories/task_repository.dart';
import 'package:cooptourism/pages/events/confirm_event.dart';
import 'package:cooptourism/pages/events/contribute_event.dart';
import 'package:cooptourism/pages/events/edit_event.dart';
import 'package:cooptourism/pages/events/join_event.dart';
import 'package:cooptourism/pages/events/manager_tasks.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final EventsRepository eventsRepository = EventsRepository();
final TaskRepository taskRepository = TaskRepository();

class SelectedEventsPage extends ConsumerStatefulWidget {
  final String eventId;
  const SelectedEventsPage({super.key, required this.eventId});

  @override
  ConsumerState<SelectedEventsPage> createState() => _SelectedEventsPageState();
}

class _SelectedEventsPageState extends ConsumerState<SelectedEventsPage> {
  String? role;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);
    role = user?.role ?? 'Customer';

    return SafeArea(
      child: Scaffold(
          // appBar: _appBar(context, "Event"),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: eventFutureBuilder()),
    );
  }

  FutureBuilder<EventsModel> eventFutureBuilder() {
    final user = ref.watch(userModelProvider);
    return FutureBuilder(
      future: eventsRepository.getSpecificEvent(widget.eventId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final event = snapshot.data!;
        // bool isContributor = event.contributors!.contains(user?.uid);
        bool isParticipant = event.participants!.contains(user?.uid);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.image != null && event.image!.isNotEmpty) ...[
                ImageSlider(event: event),
              ] else ...[
                const SizedBox(height: 10),
              ],

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  eventDurationBar(event),
                  // Edit Text button
                  user?.role == 'Manager'
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditEventPage(event: event)),
                            );
                          },
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Icon(Icons.edit,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        )
                      : const SizedBox(width: 10),
                ],
              ),
              eventTitle(event),
              eventsParticipant(event),
              eventDescription(event),

              if (event.tags != null && event.tags!.isNotEmpty) ...[
                eventTags(event),
              ] else ...[
                const SizedBox(height: 10),
              ],

              eventLocation(event),

              const SizedBox(height: 10),

              // Create a button that spans the entire width and has a height of 50
              if (role == 'Customer') customerFunctions(event),

              if (role == 'Member') ...[
                isParticipant
                    ? const SizedBox(height: 0)
                    : memberFunctions(event),
                customerFunctions(event)
              ],

              if (role == 'Manager') ...[managerFunctions(event)],

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget managerFunctions(EventsModel event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            // Push to the contribute event page use native
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ManagerTasksPage(event: event)),
            );
          },
          child: const Text(">     Check Event Details     < ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget memberFunctions(EventsModel event) {
    debugPrint("Event members: ${event.participants!}");
    final user = ref.watch(userModelProvider);
    final userId = user?.uid ?? 'null';

    // Check if uid is in the list of participants
    bool isMember = event.participants!.contains(userId);
    debugPrint("Is member: $isMember");

    // Check tasks collection for the event

    return FutureBuilder(
      future: taskRepository.getTaskByReferenceId(event.uid, userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final task = snapshot.data;

        debugPrint("Task: ${task?.uid}");

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Push to the contribute event page use native
                if (!isMember) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ContributeEventPage(event: event)),
                  );
                } else {
                  context.go('/member_dashboard_page/tasks_page/${task?.uid}');
                }
              },
              child: isMember
                  ? const Text(">     Check Tasks     < ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
                  : const Text(">     Contribute Event     < ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              // child: const Text(">     Contribute Event     < ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
        );
      },
    );

    // return Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //           child: SizedBox(
    //             width: double.infinity,
    //             height: 50,
    //             child: ElevatedButton(
    //               onPressed: () {
    //                 // Push to the contribute event page use native
    //                 if (!isMember) {
    //                   Navigator.push(context,
    //                     MaterialPageRoute(builder: (context) => ContributeEventPage(event: event)),
    //                   );
    //                 } else {
    //                   context.go('/member_dashboard_page/tasks_page/ewBh7JJqkpe0XwYRMiAsRwuw0in1');
    //                 }
    //               },
    //               child: isMember ? const Text(">     Check Tasks     < ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)) : const Text(">     Contribute Event     < ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    //               // child: const Text(">     Contribute Event     < ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    //             ),
    //           ),
    //         );
  }

  Widget customerFunctions(EventsModel event) {
    final user = ref.watch(userModelProvider);

    bool isUserParticipant = event.participants!.contains(user?.uid);

    return Column(
      children: [
        isUserParticipant
            ? const SizedBox(height: 0)
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16),
                    child: user?.role == 'Member'
                        ? const Text(
                            "Do you wish to join the event only instead of contributing?")
                        : Container(),
                  )
                ],
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              // Make it wider
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(300, 45)),
              ),
              onPressed: () {
                // Push to the contribute event page use native
                isUserParticipant
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ConfirmEventPage(event: event)),
                      )
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JoinEventPage(event: event)));
              },
              child: Text(
                  isUserParticipant
                      ? ">     Check Event Details     < "
                      : ">     Join Event     < ",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ],
    );
  }

  Padding eventLocation(EventsModel event) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              // Make the icon smaller
              Icon(
                Icons.location_on_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 10),
              Text(event.location,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: 350,
            height: 200,
            // color: Colors.grey[300],
            child: Center(
              child: Text("Map Placeholder",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Padding eventTags(EventsModel event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: SizedBox(
        height: 40,
        child: listViewFilter(event),
      ),
    );
  }

  ListView listViewFilter(EventsModel event) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: event.tags!.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
              child: Text(
                event.tags![index],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Padding eventTitle(EventsModel event) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
      child: Text(event.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 28)),
    );
  }

  Padding eventDescription(EventsModel event) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Text(event.description,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
    );
  }

  Padding eventsParticipant(EventsModel event) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Row(
        children: [
          // Make the icon smaller
          Icon(
            Icons.people_alt_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          ),
          const SizedBox(width: 10),
          // if length is null, print 0 else print the length
          Text(
              event.participants != null
                  ? "${event.participants!.length} Participants"
                  : "0 participants",
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
        ],
      ),
    );
  }

  Padding eventDurationBar(EventsModel event) {
    String formatDate(DateTime date) {
      return DateFormat('d MMM y')
          .format(date); // d for day, MMM for abbreviated month, y for year
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Row(
        children: [
          // Make the icon smaller
          Icon(
            Icons.calendar_today_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          ),
          const SizedBox(width: 10),
          Text("${formatDate(event.startDate)} - ${formatDate(event.endDate)}",
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
        ],
      ),
    );
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
  //               // showAddPostPage(context);
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
  final EventsModel event;
  const ImageSlider({super.key, required this.event});

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
    List<String> urls = await eventsRepository.getEventImageUrls(
        widget.event.uid, widget.event.image!);
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
    int maxImageIndex = widget.event.image!.length;
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
