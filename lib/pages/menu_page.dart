import 'package:cooptourism/core/theme/theme.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  String? role;

  final List<Map<String, dynamic>> _gridItems = [
    {
      'logo': Icons.business_outlined,
      'name': 'Cooperatives',
      'route': '/coops_page'
    },
    {'logo': Icons.event_outlined, 'name': 'Events', 'route': '/events_page'},
    {'logo': Icons.feed_outlined, 'name': 'Feed', 'route': '/'},
    {'logo': Icons.inbox_outlined, 'name': 'Inbox', 'route': '/inbox_page'},
    {
      'logo': Icons.shopping_bag_outlined,
      'name': 'Marketplace',
      'route': '/market_page'
    },
    {'logo': Icons.book_outlined, 'name': 'Wiki', 'route': '/wiki_page'},
    {
      'logo': Icons.account_balance_wallet_outlined,
      'name': 'Wallet',
      'route': '/wallet_page'
    },
    {
      'logo': Icons.account_balance_wallet_outlined,
      'name': 'Reports',
      'route': '/reports_page'
    },
    {
      'logo': Icons.people_alt_outlined,
      'name': 'Members',
      'route': '/members_page'
    },
    {'logo': Icons.how_to_vote_outlined, 'name': 'Vote', 'route': '/vote_page'},
    {
      // Dashboard
      'logo': Icons.dashboard_outlined,
      'name': 'Dashboard',
      'route': '/member_charts'
    }
  ];

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);
    role = user?.role ?? 'Customer';

    if (role == 'Customer') {
      // _gridItems.removeWhere((element) => element['name'] == 'Cooperatives');
      // _gridItems.removeWhere((element) => element['name'] == 'Wallet');
      _gridItems.removeWhere((element) => element['name'] == 'Reports');
      _gridItems.removeWhere((element) => element['name'] == 'Members');
      _gridItems.removeWhere((element) => element['name'] == 'Cooperatives');
      _gridItems.removeWhere((element) => element['name'] == 'Events');
      _gridItems.removeWhere((element) => element['name'] == 'Marketplace');
      _gridItems.removeWhere((element) => element['name'] == 'Dashboard');
      _gridItems.removeWhere((element) => element['name'] == 'Wiki');
      _gridItems.removeWhere((element) => element['name'] == 'Vote');
      _gridItems.removeWhere((element) => element['name'] == 'Feed');
    } else if (role == 'Member') {
      // _gridItems.removeWhere((element) => element['name'] == 'Cooperatives');
      _gridItems.removeWhere((element) => element['name'] == 'Marketplace');
      _gridItems.removeWhere((element) => element['name'] == 'Reports');
      _gridItems.removeWhere((element) => element['name'] == 'Members');
      _gridItems.removeWhere((element) => element['name'] == 'Wallet');
    } else if (role == 'Manager') {
      _gridItems.removeWhere((element) => element['name'] == 'Cooperatives');
      _gridItems.removeWhere((element) => element['name'] == 'Wallet');
      _gridItems.removeWhere((element) => element['name'] == 'Reports');
      _gridItems.removeWhere((element) => element['name'] == 'Members');
      _gridItems.removeWhere((element) => element['name'] == 'Dashboard');
      // _gridItems.removeWhere((element) => element['name'] == 'Feed');
      _gridItems.removeWhere((element) => element['name'] == 'Events');
    }

    return Scaffold(
        appBar: _appBar(context, "Menu"),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Create a profile card with user.name, user.firstname, user.profilePicture
              profileCard(context, user),

              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Shortcuts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: gridSquares(context),
              ),
            ],
          ),
        ));
  }

  GestureDetector profileCard(BuildContext context, UserModel? user) {
    String imagePath = 'users/${user?.email}/${user?.profilePicture}';

    return GestureDetector(
      onTap: () {
        context.push('/profile_page/${user?.uid}');
      },
      child: Card(
        margin: const EdgeInsets.all(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Create a profile picture circular, dont use network image, just use an icon
              user?.profilePicture != '' && user?.profilePicture != null
                  ? DisplayImage(
                      path: imagePath,
                      height: 50,
                      width: 50,
                      radius: BorderRadius.circular(30),
                    )
                  : DisplayImage(
                      path: 'users/icon-user-default.jpg',
                      height: 50,
                      width: 50,
                      radius: BorderRadius.circular(30),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text(
                      '${user?.firstName ?? 'Unknown'} ${user?.lastName ?? ''}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () => toggleTheme(ref),
                        color: Theme.of(context).colorScheme.primary,
                        icon: Icon(
                            Theme.of(context).brightness == Brightness.light
                                ? Icons.dark_mode_outlined
                                : Icons.dark_mode_rounded)),
                  ],
                ),
              ),
              // ... other user details ...
            ],
          ),
        ),
      ),
    );
  }

  GridView gridSquares(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 0,
        mainAxisExtent: 108,
      ),
      itemCount: _gridItems.length,
      itemBuilder: (_, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: () {
              context.push(_gridItems[index]['route']);
            },
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    width: 1.5,
                    style: BorderStyle.solid,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(_gridItems[index]['logo'],
                        size: 42, color: Theme.of(context).colorScheme.primary),
                    Text(
                      _gridItems[index]['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      actions: [
        // Add signout
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            child: IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.logout,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }

  void signOut() async {
    if (mounted) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
