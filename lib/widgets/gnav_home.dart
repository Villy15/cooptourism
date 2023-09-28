import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class GNavHomeWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const GNavHomeWidget({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GNav(
      tabMargin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      backgroundColor: Theme.of(context).colorScheme.background,
      color: Theme.of(context).colorScheme.primary,
      activeColor: Theme.of(context).colorScheme.primary,
      tabBorderRadius: 50,
      tabActiveBorder: Border.all(
        color: Theme.of(context).colorScheme.primary,
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      gap: 15,
      tabs: const [
        GButton(
          icon: Icons.home_outlined,
          text: 'Home',
        ),
        GButton(
          icon: Icons.groups_outlined,
          text: 'Coops',
        ),
        GButton(
          icon: Icons.store_mall_directory_outlined,
          text: 'Market',
        ),
        GButton(
          icon: Icons.person_outline_sharp,
          text: 'Profile',
        ),
        GButton(
          icon: Icons.settings_accessibility,
          text: 'Menu',
        ),
      ],
      selectedIndex: selectedIndex,
      onTabChange: onTabChange,
    );
  }
}