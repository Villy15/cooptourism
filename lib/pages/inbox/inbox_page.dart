import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/widgets/display_image.dart';
// import 'package:cooptourism/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:cooptourism/widgets/user_item.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InboxPage extends ConsumerStatefulWidget {
  const InboxPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InboxPageState();
}

class _InboxPageState extends ConsumerState<InboxPage> {
  final userRepository = UserRepository();
  User? user;

  final List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _fetchMembers();

    Future.delayed(Duration.zero, () {
      _updateNavBarAndAppBarVisibility(true);
    });
  }

  // get all users with the role of Member from firestore
  Future<void> _fetchMembers() async {
    final members = await userRepository.getUsersByRole('Member');

    setState(() {
      _users.addAll(members.where((member) => member.uid != user?.uid));
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        _updateNavBarAndAppBarVisibility(true);
        return true;
      },
      child: Scaffold(
          appBar: InboxAppBar(
            title: 'Inbox',
            onTabChange: (controller) {},
          ),
          body: SingleChildScrollView(
            child: ListView.separated(
              itemCount: _users.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              // display user full name
              itemBuilder: (context, index) {
                return ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(24)),
                      child: DisplayImage(
                        path:
                            'users/${_users[index].email}/${_users[index].profilePicture}',
                        width: 50,
                        height: 50,
                        radius: BorderRadius.circular(30),
                      ),
                    ),
                    title: Text(
                      '${_users[index].firstName} ${_users[index].lastName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      context.go('/inbox_page/${_users[index].uid!}');
                    });
              },
            ),
          )),
    );
  }

  // Widget _appBar(BuildContext context, String title) {
  //   List<Widget> tabs = [
  //     const SizedBox(
  //       child: Tab(
  //         icon: Icon(Icons.person),
  //         child: Flexible(child: Text('Individual')),
  //       ),
  //     ),
  //     const SizedBox(
  //       child: Tab(
  //         icon: Icon(Icons.group),
  //         child: Flexible(child: Text('Groups')),
  //       ),
  //     ),
  //   ];

  //   return DefaultTabController(
  //     length: tabs.length,
  //     child: AppBar(
  //       bottom: TabBar(
  //         tabs: tabs,
  //       ),
  //       toolbarHeight: 70,
  //       title: Text(title,
  //           style: TextStyle(color: Theme.of(context).colorScheme.primary)),
  //       iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
  //       leading: IconButton(
  //           icon: const Icon(Icons.arrow_back),
  //           color: Theme.of(context).colorScheme.primary,
  //           onPressed: () {
  //             GoRouter.of(context).go('/menu_page');
  //             _updateNavBarAndAppBarVisibility(true);
  //           }),
  //       actions: [
  //         Padding(
  //           padding: const EdgeInsets.only(right: 16.0),
  //           child: CircleAvatar(
  //             child: IconButton(
  //               onPressed: () {
  //                 // showAddPostPage(context);
  //               },
  //               icon: const Icon(
  //                 Icons.message,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _updateNavBarAndAppBarVisibility(bool isVisible) {
    ref.read(navBarVisibilityProvider.notifier).state = isVisible;
    ref.read(appBarVisibilityProvider.notifier).state = isVisible;
  }
}

class InboxAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final Function(TabController) onTabChange;
  const InboxAppBar({
    super.key,
    required this.title,
    required this.onTabChange,
  });

  @override
  ConsumerState<InboxAppBar> createState() => _InboxAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 75);
}

class _InboxAppBarState extends ConsumerState<InboxAppBar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      widget.onTabChange(tabController);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userModelProvider);

    List<Widget> tabs = [
      const SizedBox(
        child: Tab(
          icon: Icon(Icons.person),
          child: Flexible(child: Text('Individuals')),
        ),
      ),
      const SizedBox(
        child: Tab(
          icon: Icon(Icons.group),
          child: Flexible(child: Text('Groups')),
        ),
      ),
    ];

    // void updateNavBarAndAppBarVisibility(bool isVisible) {
    //   ref.read(navBarVisibilityProvider.notifier).state = isVisible;
    //   ref.read(appBarVisibilityProvider.notifier).state = isVisible;
    // }

    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: AppBar(
        // Style the icons
        bottom: TabBar(
          controller: tabController,
          tabs: tabs,
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        toolbarHeight: 70,
        title: Text(widget.title,
            style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   color: Theme.of(context).colorScheme.primary,
        //   onPressed: () {
        //     // GoRouter.of(context).go('/menu_page');
        //     // updateNavBarAndAppBarVisibility(true);
        //   },
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: IconButton(
                onPressed: () {
                  // showAddPostPage(context);
                },
                icon: const Icon(
                  Icons.message,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
