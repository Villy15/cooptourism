import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/repositories/task_repository.dart';
import 'package:flutter/material.dart';

class ListingTasks extends StatefulWidget {
  final ListingModel listing;
  const ListingTasks({super.key, required this.listing});

  @override
  State<ListingTasks> createState() => _ListingTasksState();
}

class _ListingTasksState extends State<ListingTasks> {
  @override
  Widget build(BuildContext context) {
    debugPrint("HELLOOO");
    TaskRepository taskRepository = TaskRepository();
    final listingTasks =
        taskRepository.getAllTasksByReferenceId(widget.listing.id);
    return StreamBuilder(
        stream: listingTasks,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}  ');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final listingTasks = snapshot.data!;
          debugPrint("tewntfuirentfoire ${listingTasks.length}");
          return ListView.builder(
              itemCount: listingTasks.length,
              itemBuilder: (context, taskIndex) {
                return const Placeholder();
              });
        }));
  }
}
