import 'package:cooptourism/data/models/events.dart';
import 'package:cooptourism/data/repositories/events_repository.dart';
import 'package:cooptourism/pages/events/add_event.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final EventsRepository eventsRepository = EventsRepository();

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  final List<String> _tabTitles = ['All', 'Workshop', 'Sports', 'Music'];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // eventsRepository.deleteAllEvents();
    // eventsRepository.addEventManually();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Events"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: listViewFilter(),
            ),
            StreamBuilder(
              stream: eventsRepository.getAllEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // show a loader while waiting for data
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No Events available');
                } else {
                  List<EventsModel> eventsList = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: eventsList.length,
                    itemBuilder: (context, index) {
                      return eventsCard(context, eventsList[index]);
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Padding eventsCard(BuildContext context, EventsModel event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: GestureDetector(
        onTap: () {
          context.push('/events_page/${event.uid}');
        },
        child: Card(
          elevation: 1,
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(20.0),
            ),
            // Circular border
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                eventTitle(event),

                // eventImage(event),
                // If the length of the image list is greater than 0, show the image
                if (event.image != null && event.image!.isNotEmpty)
                  eventImage(event),

                taskProgress(context, event),

                eventDurationBar(event),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding taskProgress(BuildContext context, EventsModel event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: LinearProgressIndicator(
        value: calculateProgress(event),
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary),
      ),
    );
  }

  double calculateProgress(EventsModel event) {
    return 0.3;
  }

  Padding eventTitle(EventsModel event) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Text(event.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    );
  }

  Padding eventImage(EventsModel event) {
    final storageRef = FirebaseStorage.instance.ref();
    // Assuming event.image![0] is the path of the image in Firebase Storage
    String imagePath = "${event.uid}/${event.image?[0]}";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 400,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: FutureBuilder(
          future: storageRef.child(imagePath).getDownloadURL(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              // Rebuild the widget in case of any error
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
              });
              return Container();
            }

            final imageUrl = snapshot.data!;

            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            );
          },
        ),
      ),
    );
  }

  Padding eventDurationBar(EventsModel event) {
    String formatDate(DateTime date) {
      return DateFormat('d MMM y')
          .format(date); // d for day, MMM for abbreviated month, y for year
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
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

  ListView listViewFilter() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _tabTitles.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: Container(
              decoration: BoxDecoration(
                color: _selectedIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28.0, vertical: 10.0),
                child: Text(
                  _tabTitles[index],
                  style: TextStyle(
                    color: _selectedIndex == index
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: _selectedIndex == index
                        ? FontWeight.bold
                        : FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    final user = ref.watch(userModelProvider);

    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      actions: [
        user?.role == "Manager"
            ? Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddEventPage()));
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
