import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddVotePage extends ConsumerStatefulWidget {
  const AddVotePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddVotePageState();
}

class _AddVotePageState extends ConsumerState<AddVotePage> {

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