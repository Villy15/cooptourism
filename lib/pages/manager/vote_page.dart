import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/manager_dashboard.dart/votes.dart';
import 'package:cooptourism/data/repositories/manager_dashboard/votes_repository.dart';
import 'package:cooptourism/pages/manager/selected_vote_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final VoteRepository voteRepository = VoteRepository();

class VotePage extends ConsumerStatefulWidget {
  const VotePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VotePageState();
}

class _VotePageState extends ConsumerState<VotePage> {

  @override
  void initState() {
    super.initState();
    // voteRepository.addVoteManually();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Vote'),
      body: SingleChildScrollView (
        child: Column(
          children: [
            StreamBuilder<List<VoteModel>>(
              stream: voteRepository.getAllVotes(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                final votes = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: votes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.ballot, color: primaryColor),
                      title: Text(votes[index].title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
                      // Format the date to show to Show Jul 15, 2023

                      subtitle: Text("Due: ${DateFormat('MMM d, y').format(votes[index].date)}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                      // Add a trailing button that says Vote
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectedVotePage(vote: votes[index]),
                            ),
                          );
                        },
                        child: const Text('Vote'),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      // Style the icons
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
                
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}