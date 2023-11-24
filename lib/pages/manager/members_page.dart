import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
// import 'package:cooptourism/providers/user_provider.dart';
import 'package:cooptourism/widgets/display_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final CooperativesRepository cooperativesRepository = CooperativesRepository();

final UserRepository userRepository = UserRepository();

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
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
      appBar: MembersAppBar(
        title: 'Members',
        onTabChange: (controller) {
          _setTabController(controller);
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          FutureBuilder(
            future: userRepository.getAllUsersFuture(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error loading data');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }

              final members = snapshot.data!;

              // Sort members by name
              members.sort(
                  (a, b) => (a.firstName ?? '').compareTo(b.firstName ?? ''));

              final tabIndex = _tabController?.index ?? 0;

              // Filter members by cooperativePositions where positionType is Member
              final filteredMembers = members.where((member) {
                if (tabIndex == 0) {
                  return member.cooperativePositions!.any((position) =>
                      position.positionType == 'Member' &&
                      position.cooperativeid == 'sslvO5tgDoCHGBO82kxq');
                } else if (tabIndex == 1) {
                  return member.cooperativePositions!.any((position) =>
                      position.positionType == 'Manager' &&
                      position.cooperativeid == 'sslvO5tgDoCHGBO82kxq');
                } else {
                  return member.cooperativePositions!.any((position) =>
                      position.positionType == 'Board' &&
                      position.cooperativeid == 'sslvO5tgDoCHGBO82kxq');
                }
              }).toList();

              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredMembers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0.0),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () => context.go(
                              '/members_page/${filteredMembers[index].uid}',
                            ),
                            leading: DisplayImage(
                              path:
                                  'users/${filteredMembers[index].email}/${filteredMembers[index].profilePicture}',
                              width: 50,
                              height: 50,
                              radius: BorderRadius.circular(30),
                            ),
                            title: Text(
                              '${filteredMembers[index].firstName} ${filteredMembers[index].lastName}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              '${filteredMembers[index].cooperativePositions!.firstWhere((position) => position.cooperativeid == 'sslvO5tgDoCHGBO82kxq').position}'
                              ' ${filteredMembers[index].cooperativePositions!.firstWhere((position) => position.cooperativeid == 'sslvO5tgDoCHGBO82kxq').positionType == 'Board' ? '' : filteredMembers[index].cooperativePositions!.firstWhere((position) => position.cooperativeid == 'sslvO5tgDoCHGBO82kxq').positionType}',
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MembersAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final Function(TabController) onTabChange;
  const MembersAppBar({
    super.key,
    required this.title,
    required this.onTabChange,
  });

  @override
  ConsumerState<MembersAppBar> createState() => _MembersAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 75);
}

class _MembersAppBarState extends ConsumerState<MembersAppBar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
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
    List<Widget> tabs = [
      const SizedBox(
        child: Tab(
          icon: Icon(Icons.person),
          child: Flexible(child: Text('Members')),
        ),
      ),
      const SizedBox(
        child: Tab(
          icon: Icon(Icons.manage_accounts),
          child: Flexible(child: Text('Management')),
        ),
      ),
      const SizedBox(
        child: Tab(
          icon: Icon(Icons.group),
          child: Flexible(child: Text('Board of Directors')),
        ),
      ),
    ];

    return AppBar(
      bottom: TabBar(
        labelStyle: const TextStyle(fontSize: 13.0),
        indicatorSize: TabBarIndicatorSize.tab,
        controller: tabController,
        tabs: tabs,
        labelPadding: EdgeInsets.zero,
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      toolbarHeight: 70,
      title: Text(widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
    );
  }
}
