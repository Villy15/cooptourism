

import 'package:cooptourism/core/theme/light_theme.dart';
import 'package:cooptourism/data/models/manager_dashboard.dart/votes.dart';
import 'package:cooptourism/data/models/poll.dart';
import 'package:cooptourism/data/repositories/manager_dashboard/votes_repository.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final VoteRepository voteRepository = VoteRepository();

class SelectedVotePage extends ConsumerStatefulWidget {
  final VoteModel vote;
  const SelectedVotePage({super.key, required this.vote});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectedVotePageState();
}

class _SelectedVotePageState extends ConsumerState<SelectedVotePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Vote'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Duration
          eventDurationBar(widget.vote),
          eventTitle(widget.vote),
          eventDescription(widget.vote),


          votePoll(),
        ],
      ),

    );
  }

  StreamBuilder<List<PollModel>> votePoll() {
    return StreamBuilder<List<PollModel>>(
          stream: voteRepository
              .getAllPolls(widget.vote.uid), // Assume uid is the post ID
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final polls = snapshot.data!;

              if (polls.isEmpty) {
                return const SizedBox.shrink(); // Returns an empty widget
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: PollingWidget(polls: polls, vote: widget.vote),
              );
            }
          },
        );
  }

  Padding eventDurationBar(VoteModel vote) {
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
          Text(formatDate(vote.date),
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
        ],
      ),
    );
  }

  Padding eventTitle(VoteModel vote) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
      child: Text(vote.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 28)),
    );
  }

  Padding eventDescription(VoteModel vote) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Text(vote.description,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
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
                // showAddPostPage(context);
              },
              icon: const Icon(Icons.edit, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}


class PollingWidget extends ConsumerStatefulWidget {
  final List<PollModel> polls;
  final VoteModel vote;

  const PollingWidget({Key? key, required this.polls, required this.vote})
      : super(key: key);

  @override
  ConsumerState<PollingWidget> createState() => PollingWidgetState();
}

class PollingWidgetState extends ConsumerState<PollingWidget> {
  int? _selectedChoice;
  int? totalVotes;

  // @override
  // void initState() {
  //   super.initState();

  //   for (int i = 0; i < widget.polls.length; i++) {
  //     if (widget.polls[i].voters != null &&
  //         widget.polls[i].voters!.contains(user?.uid)) {
  //       _selectedChoice = i;
  //       break;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);
    // Only set _selectedChoice if it hasn't been set yet
    if (_selectedChoice == null) {
      for (int i = 0; i < widget.polls.length; i++) {
        if (widget.polls[i].voters != null &&
            widget.polls[i].voters!.contains(user?.uid)) {
          setState(() {
            _selectedChoice = i;
          });
          break;
        }
      }

      // Get the totalVotes by adding up the length of each poll's voters
      totalVotes = widget.polls.fold(
          0, (sum, poll) => sum! + (poll.voters?.length ?? 0));
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Add padding around the container
      decoration: BoxDecoration(
        color: Colors.white, // Setting a background color
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: Column(
        children: [
          // Display total votes at the top
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(16.0), // Add padding around the container
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary, // Setting a background color
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0)), // Rounded corners
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$totalVotes Total Votes',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.white),
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MM/dd/yyyy, hh:mm a').format(widget.vote.date), // Format includes date and time/ Format as per your requirement
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondary, // Setting a background color
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0)), // Rounded corners
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              shrinkWrap: true, // Makes the list view confined to its content
              itemCount: widget.polls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Setting a background color
                      borderRadius:
                          BorderRadius.circular(8.0), // Rounded corners
                    ),
                    child: ListTile(
                      title: Text(widget.polls[index].optionText,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                      leading: Radio(
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: index,
                        groupValue: _selectedChoice,
                        onChanged: (int? value) {
                          setState(() {
                            // Check if the user is clicking on the same selected index
                            if (_selectedChoice == value) {
                              // Remove the user's vote
                              if (widget.polls[value!].voters != null) {
                                widget.polls[value].voters!.remove(user?.uid);
                                voteRepository.updatePoll(
                                    widget.vote.uid,
                                    widget.polls[value].uid,
                                    widget.polls[value]);
                              }
                              _selectedChoice =
                                  null; // Reset _selectedChoice to null
                              debugPrint("Vote removed for choice: $value");
                            } else {
                              // Remove the user's vote from the previously voted option
                              if (_selectedChoice != null &&
                                  widget.polls[_selectedChoice!].voters !=
                                      null) {
                                widget.polls[_selectedChoice!].voters!
                                    .remove(user?.uid);
                                debugPrint(
                                    "Current voters for choice $_selectedChoice: ${widget.polls[_selectedChoice!].voters}");
                                voteRepository.updatePoll(
                                    widget.vote.uid,
                                    widget.polls[_selectedChoice!].uid,
                                    widget.polls[_selectedChoice!]);
                              }

                              // Add the user's vote to the new selected option
                              if (widget.polls[value!].voters == null) {
                                widget.polls[value].voters = [];
                              }
                              widget.polls[value].voters!.add(user!.uid!);

                              // Set the selected choice to the new value
                              _selectedChoice = value;

                              
                              setState(() {
                                // Update total votes
                                widget.polls[value].votes += 1;
                                totalVotes = widget.polls.fold(
                                    0,
                                    (sum, poll) =>
                                        sum! + (poll.voters?.length ?? 0));
                              });

                              voteRepository.updatePoll(widget.vote.uid,
                                  widget.polls[value].uid, widget.polls[value]);
                            }
                          });
                        },
                      ),
                      // Add trailing of a button of that shows View More Info
                      trailing: TextButton(
                        onPressed: () {
                          context.push(
                              '/profile_page/${widget.polls[index].optionId}');
                        },
                        child: const Text('View Profile'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
