import 'package:cooptourism/data/models/events.dart';
import 'package:flutter/material.dart';

class JoinEventPage extends StatefulWidget {
  final EventsModel event;
  const JoinEventPage({super.key, required this.event});

  @override
  State<JoinEventPage> createState() => _ContributeEventPageState();
}

class _ContributeEventPageState extends State<JoinEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Join Event"),
      body: const Center(
        child: Text('Join Event Page'),
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title, style: TextStyle(fontSize: 28, color: Theme.of(context).colorScheme.primary)),
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