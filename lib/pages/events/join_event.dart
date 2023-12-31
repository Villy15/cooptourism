import 'package:cooptourism/data/models/events.dart';
import 'package:cooptourism/data/repositories/events_repository.dart';
import 'package:cooptourism/pages/events/confirm_event.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final EventsRepository eventsRepository = EventsRepository();

class JoinEventPage extends ConsumerStatefulWidget {
  final EventsModel event;
  const JoinEventPage({super.key, required this.event});

  @override
  ConsumerState<JoinEventPage> createState() => _ContributeEventPageState();
}

class _ContributeEventPageState extends ConsumerState<JoinEventPage> {
  int _guestCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Join Event"),
      body: ListView(
        children: [
          _listingSummary(context, widget.event),
          _tripDetails(context, widget.event),
          // _priceDetails(context),
          // _paymentMethod(context),
          _listingRules(context),
          _confirmPay(context),
        ],
      ),
    );
  }

  Widget _listingRules(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ground Rules',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                  '• To ensure a safe and enjoyable event for everyone, we kindly ask you to follow these guidelines:',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              // Add a bulleted point list of text
              SizedBox(height: 10),
              Text(
                  '• Use tools and resources responsibly and return them after use',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              SizedBox(height: 10),
              Text(
                  '• Follow all safety instructions and stay within designated areas',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              SizedBox(height: 10),
              Text('• Dispose of waste properly in the provided bins',
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listingSummary(BuildContext context, EventsModel event) {
    // You will need to replace the Image.network with an image from your model
    return ListTile(
      leading: DisplayImage(
        path: "events/${event.uid}/${event.image![0]}",
        height: 100,
        width: 100,
        radius: const BorderRadius.only(),
      ),
      title: Text(
        event.title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      // subtitle: Row(
      //   children: [
      //     Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
      //     Text('${listing.rating?.toStringAsFixed(2)} (5 reviews)'),
      //   ],
      // ),
    );
  }

  Widget _tripDetails(BuildContext context, EventsModel event) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your trip',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dates',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                          '${DateFormat('dd MMM').format(event.startDate)} - ${DateFormat('dd MMM').format(event.endDate)} (${event.endDate.difference(event.startDate).inDays} days)',
                          style: const TextStyle(
                            fontSize: 16,
                          )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Guests',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${_guestCount.toString()} Guests',
                          style: const TextStyle(
                            fontSize: 16,
                          )),
                    ],
                  ),
                  // Add + and minus button
                  Row(
                    children: [
                      if (_guestCount > 1)
                        IconButton(
                          onPressed: _decrementGuestCount,
                          icon: Icon(Icons.remove_circle_outline,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      Text(_guestCount.toString()),
                      IconButton(
                        onPressed: _incrementGuestCount,
                        icon: Icon(Icons.add_circle_outline,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _incrementGuestCount() {
    setState(() {
      _guestCount++;
    });
  }

  void _decrementGuestCount() {
    setState(() {
      _guestCount--;
    });
  }

  Widget _confirmPay(BuildContext context) {
    final user = ref.watch(userModelProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'By confirming below, you agree to our terms and conditions, and privacy policy.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              // Make it wider
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(300, 45)),
              ),
              onPressed: () {
                // Add current id to the list of participants
                eventsRepository.updateEventParticipants(
                    widget.event.uid, user?.uid);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmEventPage(event: widget.event),
                  ),
                );
              },
              child: const Text('Confirm and Join Event'),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      actions: const [
        // Padding(
        //   padding: const EdgeInsets.only(right: 16.0),
        //   child: CircleAvatar(
        //       backgroundColor: Colors.grey.shade300,
        //       child: IconButton(
        //         onPressed: () {
        //           // showAddPostPage(context);
        //         },
        //         icon: const Icon(Icons.add, color: Colors.white),
        //       ),
        //     ),
        // ),
      ],
    );
  }
}
