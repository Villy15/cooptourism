import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConfirmEventPage extends StatefulWidget {
  final EventsModel event;
  const ConfirmEventPage({super.key, required this.event});

  @override
  State<ConfirmEventPage> createState() => _ContributeEventPageState();
}

class _ContributeEventPageState extends State<ConfirmEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Confirm Event"),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _confirmationSummary(context, widget.event),
          _eventDetails(context, widget.event),
          _eventContact(context, widget.event),
          _eventDay(context, widget.event),
          _qrCode(context, widget.event),
          _showQrCode(context, widget.event),
        ],
      ),
    );
  }

  Widget _showQrCode(BuildContext context, EventsModel event) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
      child: Text(
        '🔔 Show this on the day of the event at the registration',
        style: TextStyle(
          fontSize: 22,
          color: Theme.of(context).colorScheme.primary,
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
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: primaryColor,
            ),
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: primaryColor,
            ),
          ),
    );
  }

  Widget _eventDay(BuildContext context, EventsModel event) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('On the Day:',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('✔️ Check-in:',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                  '• Present your confirmation email or QR code at the registration desk',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary)),
              // Message icon
              const SizedBox(height: 20),
              // Event GC
              Text('👜 Tools and Equipment',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                  '• All necessary tools will be provided. If you wish to bring your own gloves or equipment, please do so.',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 20),
              // Food and beverages
              Text('🍽️ Food and Beverages',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                  '• Lunch and refreshments will be provided. Please bring your own water bottle.',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary)),
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
              Text('Keep this Information Handy',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('🗣️ Contact Person',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '• Adrian Villanueva',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary)),
                  // Message icon
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.message, color: primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Event GC
              Text('👥 • Event Group Chat',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Green Horizons',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary)),
                  // Message icon
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.message, color: primaryColor),
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
            style: TextStyle(
                fontSize: 24, color: primaryColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Thank you for joining us at Green Horizons!',
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
              Text(
                'Your participation is confirmed.',
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

   Widget _eventDetails(BuildContext context , EventsModel event) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Event Details',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('📅 Dates',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                  '${DateFormat('dd MMM').format(event.startDate)} - ${DateFormat('dd MMM').format(event.endDate)}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 20),
              Text('📍 Location',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),

              Text(event.location,
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary)),
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
      toolbarHeight: 70,
      title: Text(title, style: TextStyle(fontSize: 28, color: Theme.of(context).colorScheme.primary)),
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