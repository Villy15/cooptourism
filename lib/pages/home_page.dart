import 'package:cooptourism/animations/slide_transition.dart';
import 'package:cooptourism/widgets/bottom_nav_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';

import 'home_feed_page.dart';
import 'menu_page.dart';

import 'dashboard_page.dart';
import 'members_page.dart';
import 'reports_page.dart';

import 'add_post.dart';

// MANAGER

class HomePage extends StatefulWidget {
  final Widget child;
  const HomePage({Key? key, required this.child}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<String> _appBarTitles = [
    'Home',
    'Coops',
    'Market',
    'Profile',
    'Menu',
  ];

  final List<String> _tabs = const [
    "/",
    "/coops_page",
    "/market_page",
    "/profile_page",
    "/menu_page",
  ];

  final List<String> _appBarTitlesManager = [
    'Home',
    'Dashboard',
    'Members',
    'Reports',
    'Menu',
  ];

  final List<String> _tabsManager = const [
    "/",
    "/dashboard_page",
    "/members_page",
    "/reports_page",
    "/menu_page",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            _appBarTitlesManager[_selectedIndex]), //! MAKE THIS DYNAMIC TO ROLE
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: signOut,
          ),
        ],
      ),
      body: widget.child, //! MAKE THIS DYNAMIC TO ROLE
      floatingActionButton: shouldShowFloatingActionButton()
          ? FloatingActionButton(
              onPressed: () {
                showAddPostPage(context);
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
            child: BottomNavHomeWidget(
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                  context.go(_tabs[_selectedIndex]);
                });
              },
              role:
                  "Member", // Replace with not hardcoded role // Member, Customer
            ),
          ),
        ),
      ),
    );
  }

  void signOut() async {
    if (mounted) {
      await FirebaseAuth.instance.signOut();
    }
  }

  void showAddPostPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const AddPostPage();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransitionAnimation(
            animation: animation,
            child: child,
          );
        },
      ),
    );
  }

  bool shouldShowFloatingActionButton() {
    return _selectedIndex == 0 || _selectedIndex == 2;
  }
}
