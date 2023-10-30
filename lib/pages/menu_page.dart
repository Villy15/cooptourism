import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    {'logo': Icons.business_outlined, 'name': 'Cooperatives', 'route': '/coops_page'},
    
    {'logo': Icons.event_outlined, 'name': 'Events', 'route': '/events_page'},
    {'logo': Icons.feed_outlined , 'name': 'Feed', 'route': '/' },
    {'logo': Icons.inbox_outlined, 'name': 'Inbox', 'route': '/inbox_page' },
    {'logo': Icons.shopping_bag_outlined, 'name': 'Marketplace', 'route': '/market_page' },
    {'logo': Icons.book_outlined, 'name': 'Wiki', 'route': '/wiki_page'},
    {'logo': Icons.account_balance_wallet_outlined, 'name': 'Wallet', 'route': '/wallet_page' },
    
    {'logo': Icons.account_balance_wallet_outlined, 'name': 'Reports', 'route': '/reports_page' },
    {'logo': Icons.people_alt_outlined, 'name': 'Members', 'route': '/members_page' },
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);
    role = user?.role ?? 'Customer';

    if (role == 'Customer') {
      // _gridItems.removeWhere((element) => element['name'] == 'Cooperatives');
      _gridItems.removeWhere((element) => element['name'] == 'Wallet');
      _gridItems.removeWhere((element) => element['name'] == 'Reports');
      _gridItems.removeWhere((element) => element['name'] == 'Members');
      _gridItems.removeWhere((element) => element['name'] == 'Cooperatives');
      _gridItems.removeWhere((element) => element['name'] == 'Events');
      _gridItems.removeWhere((element) => element['name'] == 'Marketplace');

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
      _gridItems.removeWhere((element) => element['name'] == 'Feed');
    }
    
    return Scaffold(
        appBar: _appBar(context, "Menu"),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView (
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
    final storageRef = FirebaseStorage.instance.ref();

    String imagePath = "${user?.uid}/images/${user?.profilePicture}";

    return GestureDetector(
              onTap: () {
                context.push('/profile_page');
              },
              child: Card(
                margin: const EdgeInsets.all(12.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Create a profile picture circular, dont use network image, just use an icon
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade300,
                        child: FutureBuilder(
                          future: storageRef
                              .child(imagePath)
                              .getDownloadURL(), // Await here
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(snapshot.data.toString()),
                              );
                            } 
                            return const Icon(Icons.person, size: 30, color: Colors.white);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          '${user?.firstName ?? 'Unknown'} ${user?.lastName ?? ''}',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
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
    Color color = Theme.of(context).colorScheme.secondary;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 0,
        mainAxisExtent: 100,
      ),
      itemCount: _gridItems.length,
      itemBuilder: (_, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell (
            onTap: () {
              setState(() {
                color = Theme.of(context).colorScheme.primary;
              });

              context.push(_gridItems[index]['route']);
            },
            child: Ink (
              decoration: BoxDecoration(
                color: color,
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
      title: Text(title, style: TextStyle(fontSize: 28, color: Theme.of(context).colorScheme.primary)),
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

        // Add signout
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: IconButton(
                onPressed: () {
                  signOut();
                },
                icon: const Icon(Icons.logout, color: Colors.white),
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
