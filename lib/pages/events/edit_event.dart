import 'package:cooptourism/data/models/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditEventPage extends ConsumerStatefulWidget {
  final EventsModel event;
  const EditEventPage({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditEventPageState();
}

class _EditEventPageState extends ConsumerState<EditEventPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Add Vote'),
      body: const SingleChildScrollView (
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }

   AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                // showAddPostPage(context);
              },
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}