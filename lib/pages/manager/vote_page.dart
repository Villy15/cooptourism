import 'package:cooptourism/data/models/manager_dashboard.dart/votes.dart';
import 'package:cooptourism/data/repositories/manager_dashboard/votes_repository.dart';
import 'package:cooptourism/pages/manager/dashboard/add_vote_page.dart';
import 'package:cooptourism/pages/manager/selected_vote_page.dart';
import 'package:cooptourism/providers/user_provider.dart';
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
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // Other initializations...
  }

  void _setTabController(TabController controller) {
    setState(() {
      _tabController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoteAppBar(
        title: 'Votes',
        onTabChange: (controller) {
          _setTabController(controller);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<VoteModel>>(
              stream: voteRepository.getAllVotes(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: SizedBox.shrink());
                }

                final votes = snapshot.data!;

                // sort votes by name
                votes.sort((a, b) => a.title.compareTo(b.title));

                final tabIndex = _tabController?.index ?? 0;

                debugPrint('tabIndex: $tabIndex');

                // Filter the votes based on the current tab index
                final filteredVotes = votes.where((vote) {
                  if (tabIndex == 0) {
                    return vote.category == 'board';
                  } else {
                    return vote.category == 'management';
                  }
                }).toList();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredVotes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.ballot),
                      title: Text(filteredVotes[index].title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      // Format the date to show to Show Jul 15, 2023

                      subtitle: Text(
                          "Due: ${DateFormat('MMM d, y').format(filteredVotes[index].date)}",
                          style: const TextStyle(fontSize: 16)),
                      // Add a trailing button that says Vote
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SelectedVotePage(vote: filteredVotes[index]),
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
}

class VoteAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function(TabController) onTabChange;
  const VoteAppBar({
    super.key,
    required this.title,
    required this.onTabChange,
  });

  @override
  ConsumerState<VoteAppBar> createState() => _VoteAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 75);
}

class _VoteAppBarState extends ConsumerState<VoteAppBar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        widget.onTabChange(tabController);
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);

    List<Widget> tabs = [
      const SizedBox(
        child: Tab(
          icon: Icon(Icons.group),
          child: Flexible(child: Text('Board of Directors')),
        ),
      ),
      const SizedBox(
        child: Tab(
          icon: Icon(Icons.manage_accounts),
          child: Flexible(child: Text('Management')),
        ),
      ),
    ];

    return AppBar(
      bottom: TabBar(
        controller: tabController,
        tabs: tabs,
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      toolbarHeight: 70,
      title: Text(widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: user?.role == 'Manager'
              ? CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddVotePage()));
                    },
                    icon: const Icon(Icons.add),
                  ),
                )
              : Container(),
        ),
        Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: IconButton(
                onPressed: () {
                  // Show modal with info about the page
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Member Entitled to Vote'),
                        content: const Text(
                          'Any member who meets the following conditions is a member entitled to vote:\n'
                          'a. Paid the membership fee and the value of the minimum shares required for membership;\n'
                          'b. Not delinquent in the payment of his share capital subscriptions and other accounts or obligations;\n'
                          'c. Not violated any provision of this By-laws, the terms and conditions of the subscription agreement; and the decisions, guidelines, rules and regulations promulgated by the Board of Directors and the general assembly;\n'
                          'd. Completed the continuing education program prescribed by the Board of Directors; and\n'
                          'e. Participated in the affairs of the Cooperative and patronized its businesses in accordance with cooperative’s policies and guidelines.\n'
                          'Failure of the member to meet any of the above qualifications shall mean loss of right to vote as declared by the Board of Directors.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.info),
              ),
            )),
      ],
    );
  }
}
