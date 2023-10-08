import 'dart:convert';

import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/util/animations/slide_transition.dart';
import 'package:cooptourism/widgets/bottom_nav_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';

import 'home_feed/add_post.dart';

// MANAGER

class HomePage extends StatefulWidget {
  final Widget child;
  const HomePage({Key? key, required this.child}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser;
  final UserRepository _userRepository = UserRepository();

  // Current user
  UserModel? _user;

  @override
  void initState() {
    super.initState();

    _userRepository.getUserByUid(user!.uid).then((value) {
      setState(() {
        _user = value;
        debugPrint("User: ${jsonEncode(_user?.toJson())}");
      });
    });
  }

  List<String> _tabsTitleByRole(String role) {
    switch (role) {
      case "Manager":
        return [
          'Home',
          'Dashboard',
          'Members',
          'Reports',
          'Menu',
        ];
      case "Member":
        return [
          'Home',
          'Coops',
          'Market',
          'Profile',
          'Menu',
        ];
      default: // Customer
        return [
          'Home',
          'Coops',
          'Market',
          'Profile',
          'Menu',
        ];
    }
  }

  List<String> _tabsByRole(String role) {
    switch (role) {
      case "Manager":
        return [
          "/",
          "/dashboard_page",
          "/members_page",
          "/reports_page",
          "/menu_page"
        ];
      case "Member":
        return [
          "/",
          "/coops_page",
          "/market_page",
          "/profile_page",
          "/menu_page"
        ];
      default: // Customer
        return [
          "/",
          "/coops_page",
          "/market_page",
          "/profile_page",
          "/menu_page"
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_tabsTitleByRole(_user?.role ?? "Member")[
            _selectedIndex]), //! MAKE THIS DYNAMIC TO ROLE
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
                  context
                      .go(_tabsByRole(_user?.role ?? "Member")[_selectedIndex]);
                });
              },
              role: _user?.role ??
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
