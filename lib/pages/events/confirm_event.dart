import 'package:cooptourism/data/models/events.dart';
import 'package:cooptourism/pages/events/add_event.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConfirmEventPage extends ConsumerStatefulWidget {
  final EventsModel event;
  const ConfirmEventPage({super.key, required this.event});

  @override
  ConsumerState<ConfirmEventPage> createState() => _ContributeEventPageState();
}

class _ContributeEventPageState extends ConsumerState<ConfirmEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Confirm Event"),
      body: ListView(
        children: [
          _confirmationSummary(context, widget.event),
          _eventDetails(context, widget.event),
          _eventContact(context, widget.event),
          _eventDay(context, widget.event),
          _qrCode(context, widget.event),
          _showQrCode(context, widget.event),
          _leaveEvent(context, widget.event),
        ],
      ),
    );
  }

  Widget _leaveEvent(BuildContext context, EventsModel event) {
    final user = ref.watch(userModelProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'If you wish to leave this event, please click the button below.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              // Make it larger
              style: ElevatedButton.styleFrom(
                // Color
                backgroundColor: Colors.red.shade700,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Color
              onPressed: () {
                // Delete current id to the list of participants
                // eventsRepository.updateEventParticipants(widget.event.uid, user?.uid);
                eventsRepository.removeEventParticipants(
                    widget.event.uid, user?.uid);

                // show snackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You have left the event'),
                  ),
                );

                context.pushReplacement('/events_page/${event.uid}');
              },
              child: const Text('Leave Event'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showQrCode(BuildContext context, EventsModel event) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          '🔔 Show this on the day of the event at the registration',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  Widget _qrCode(BuildContext context, EventsModel event) {
    return Center(
      child: QrImageView(
        data: 'This is a simple QR code',
        version: QrVersions.auto,
        size: 320,
        gapless: false,
        padding: const EdgeInsets.all(20.0),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Theme.of(context).colorScheme.primary,
        ),
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _eventDay(BuildContext context, EventsModel event) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('On the Day:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('✔️ Check-in:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(
                  '• Present your confirmation email or QR code at the registration desk',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              // Message icon
              SizedBox(height: 20),
              // Event GC
              Text('👜 Tools and Equipment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(
                  '• All necessary tools will be provided. If you wish to bring your own gloves or equipment, please do so.',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              SizedBox(height: 20),
              // Food and beverages
              Text('🍽️ Food and Beverages',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(
                  '• Lunch and refreshments will be provided. Please bring your own water bottle.',
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eventContact(BuildContext context, EventsModel event) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Keep this Information Handy',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('🗣️ Contact Person',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('• Adrian Villanueva',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  // Message icon
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.message,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Event GC
              const Text('👥 • Event Group Chat',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Green Horizons',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  // Message icon
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.message),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmationSummary(BuildContext context, EventsModel event) {
    // You will need to replace the Image.network with an image from your model
    // or use any image display widget that fits your application
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '✅ You\'re Registered!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Thank you for joining us at Green Horizons!',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Your participation is confirmed.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _eventDetails(BuildContext context, EventsModel event) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Event Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('📅 Dates',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                  '${DateFormat('dd MMM').format(event.startDate)} - ${DateFormat('dd MMM').format(event.endDate)}',
                  style: const TextStyle(
                    fontSize: 16,
                  )),
              const SizedBox(height: 20),
              const Text('📍 Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),

              Text(
                event.location,
                style: const TextStyle(fontSize: 16),
              ),
              // Add more event details if necessary
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      // automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.pushReplacement('/events_page/${widget.event.uid}');
        },
      ),
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
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
