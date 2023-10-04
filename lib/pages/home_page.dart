import 'package:cooptourism/animations/slide_transition.dart';
import 'package:cooptourism/widgets/bottom_nav_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

import 'home_feed_page.dart';
import 'coops_page.dart';
import 'market_page.dart';
import 'menu_page.dart';
import 'profile_page.dart';

import 'add_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

  final List<Widget> _tabs = const [
    HomeFeedPage(),
    CoopsPage(),
    MarketPage(),
    ProfilePage(),
    MenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
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
      body: _tabs[_selectedIndex],
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
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
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
