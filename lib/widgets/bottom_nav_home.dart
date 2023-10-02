import 'package:flutter/material.dart';

class BottomNavHomeWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const BottomNavHomeWidget({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      iconSize: 30,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      // unselectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      selectedItemColor:  Theme.of(context).colorScheme.primary,
      selectedLabelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
      unselectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedLabelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
      backgroundColor: Theme.of(context).colorScheme.background,
      // selectedFontSize: 12,
      items: const <BottomNavigationBarItem>[
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
      ],
      currentIndex: selectedIndex,
      onTap: onTabChange,
    );
  }
}