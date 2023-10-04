import 'package:flutter/material.dart';

<<<<<<< HEAD
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
>>>>>>> aa0f2ad8ccee94aa1a139f45d6e541f024019a52

// import 'package:go_router/go_router.dart';

class BottomNavHomeWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  final String role;

  const BottomNavHomeWidget({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
    required this.role,
  }) : super(key: key);

  @override
  State<BottomNavHomeWidget> createState() => _BottomNavHomeWidgetState();
}

class _BottomNavHomeWidgetState extends State<BottomNavHomeWidget> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    // Changes the bottom navigation bar items based on the user's role
    List<BottomNavigationBarItem> items;
    if (widget.role == 'Manager') {
      items = _getManagerItems();
    } else if (widget.role == 'Member') {
      items = _getMemberItems();
    } else if (widget.role == 'Customer') {
      items = _getCustomerItems();
    } else {
      items = _getMemberItems();
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      iconSize: 30,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      // unselectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      selectedItemColor: Theme.of(context).colorScheme.primary,
      selectedLabelStyle:
          TextStyle(color: Theme.of(context).colorScheme.primary),
      unselectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedLabelStyle:
          TextStyle(color: Theme.of(context).colorScheme.primary),
      backgroundColor: Theme.of(context).colorScheme.background,
      // selectedFontSize: 12,
      items: items,
      currentIndex: widget.selectedIndex,
      onTap: widget.onTabChange,
    );
  }

  List<BottomNavigationBarItem> _getManagerItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        activeIcon: Icon(Icons.dashboard_rounded),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people_outline_rounded),
        activeIcon: Icon(Icons.people_rounded),
        label: 'Members',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart_outlined),
        activeIcon: Icon(Icons.bar_chart_rounded),
        label: 'Reports',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_rounded),
        activeIcon: Icon(Icons.menu_open_rounded),
        label: 'Menu',
      ),
    ];
  }

  List<BottomNavigationBarItem> _getMemberItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.groups_outlined),
        activeIcon: Icon(Icons.groups),
        label: 'Coops',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.store_mall_directory_outlined),
        activeIcon: Icon(Icons.store_mall_directory_rounded),
        label: 'Market',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline_rounded),
        activeIcon: Icon(Icons.person_rounded),
        label: 'Profile',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_rounded),
        activeIcon: Icon(Icons.menu_open_rounded),
        label: 'Menu',
      ),
    ];
  }

  List<BottomNavigationBarItem> _getCustomerItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.store_mall_directory_outlined),
        activeIcon: Icon(Icons.store_mall_directory_rounded),
        label: 'Marketplace',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance_wallet_outlined),
        activeIcon: Icon(Icons.account_balance_wallet_rounded),
        label: 'Wallet',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.event_outlined),
        activeIcon: Icon(Icons.event_rounded),
        label: 'Events',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications_outlined),
        activeIcon: Icon(Icons.notifications_rounded),
        label: 'Notifications',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline_rounded),
        activeIcon: Icon(Icons.person_rounded),
        label: 'Profile',
      ),
    ];
  }
}
