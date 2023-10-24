// import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cooptourism/data/models/events.dart';
import 'package:cooptourism/data/repositories/events_repository.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final EventsRepository eventsRepository = EventsRepository();

class SelectedEventsPage extends StatefulWidget {
  final String eventId;
  const SelectedEventsPage({super.key, required this.eventId});

  @override
  State<SelectedEventsPage> createState() => _SelectedEventsPageState();
}

class _SelectedEventsPageState extends State<SelectedEventsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // appBar: _appBar(context, "Event"),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: eventFutureBuilder()),
    );
  }

  FutureBuilder<EventsModel> eventFutureBuilder() {
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

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              event.image != ""
                  ? ImageSlider(event: event)
                  : const SizedBox(height: 10),
              eventDurationBar(event),
              eventTitle(event),
              eventsParticipant(event),
              eventDescription(event),
              eventTags(),
              eventLocation(event),
            ],
          ),
        );
      },
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
                  style:
                      const TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
            ],
          ),

          
        const SizedBox(height: 16.0),  
        Container(
          width: 350, 
          height: 200, 
          color: Colors.grey[300],  
          child: Center(
            child: Text(
              "Map Placeholder",
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ),
        const SizedBox(height: 16.0),  
        ],
      ),
    );
  }

  Padding eventTags() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: SizedBox(
        height: 40,
        child: listViewFilter(),
      ),
    );
  }

  ListView listViewFilter() {
    final List<String> tabTitles = ['Sports', 'Basketball'];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: tabTitles.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 28.0, vertical: 10.0),
              child: Text(
                tabTitles[index],
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
          const Text("Participants",
              style:
                  TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
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
                // showAddPostPage(context);
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageSlider extends StatefulWidget {
  final EventsModel event;
  const ImageSlider({super.key, required this.event});

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
    int maxImageIndex = 1; // widget.event.images!.length;
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
            items: [
              Image.network(
                widget.event.image!,
                fit: BoxFit.cover,
                width: double.infinity,
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
