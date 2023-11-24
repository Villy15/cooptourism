import 'package:flutter/material.dart';

class ListingManagerRailMenu extends StatefulWidget {
  final int railIndex;
  final Function onDestinationSelected;
  final String listingId;
  const ListingManagerRailMenu({
    super.key,
    required this.railIndex,
    required this.onDestinationSelected,
    required this.listingId,
  });

  @override
  State<ListingManagerRailMenu> createState() => _ListingManagerRailMenuState();
}

class _ListingManagerRailMenuState extends State<ListingManagerRailMenu> {
  bool railVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
              ),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      railVisibility = !railVisibility;
                    });
                  },
                  icon: const Icon(Icons.settings_accessibility_rounded)),
            ),
            if (railVisibility == true)
              Container(
                height: MediaQuery.sizeOf(context).height,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                child: NavigationRail(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minWidth: 56,
                  selectedIndex: widget.railIndex,
                  groupAlignment: 0,
                  unselectedIconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.background),
                  onDestinationSelected: (int index) {
                    widget.onDestinationSelected(index);
                  },
                  labelType: NavigationRailLabelType.none,
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.remove_red_eye_rounded),
                      selectedIcon: Icon(Icons.remove_red_eye_rounded),
                      label: Text('View'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.message_rounded),
                      selectedIcon: Icon(Icons.message_rounded),
                      label: Text('Chat'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.edit_outlined),
                      selectedIcon: Icon(Icons.edit_outlined),
                      label: Text('Edit'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.task),
                      selectedIcon: Icon(Icons.task),
                      label: Text('Tasks'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
