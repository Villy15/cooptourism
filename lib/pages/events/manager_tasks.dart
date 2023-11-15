import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/events.dart';
import 'package:cooptourism/pages/events/manager_tasks_create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManagerTasksPage extends ConsumerStatefulWidget {
  final EventsModel event;
  const ManagerTasksPage({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManagerTasksPageState();
}

class _ManagerTasksPageState extends ConsumerState<ManagerTasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Event Details'),
      body: const SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      iconTheme: const IconThemeData(color: primaryColor),
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
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => ManagerTasksCreate(event: widget.event))
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
