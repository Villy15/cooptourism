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
  Offset position = const Offset(0, 125);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: position.dy,
          right: position.dx,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                position = Offset(position.dx, position.dy + details.delta.dy);
              });
            },
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height / 1.5,
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
                      height: MediaQuery.sizeOf(context).height / 1.5,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20))),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: NavigationRail(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          minWidth: 56,
                          selectedIndex: widget.railIndex,
                          groupAlignment: 0,
                          unselectedIconTheme: IconThemeData(
                              color: Theme.of(context).colorScheme.background),
                          onDestinationSelected: (int index) {
                            widget.onDestinationSelected(index);
                          },
                          labelType: NavigationRailLabelType.all,
                          destinations: <NavigationRailDestination>[
                            NavigationRailDestination(
                              icon: const Icon(Icons.remove_red_eye_rounded),
                              selectedIcon:
                                  const Icon(Icons.remove_red_eye_rounded),
                              label: Text(
                                'View',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background),
                              ),
                            ),
                            NavigationRailDestination(
                              icon: const Icon(Icons.message_rounded),
                              selectedIcon: const Icon(Icons.message_rounded),
                              label: Text('Chat',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background)),
                            ),
                            NavigationRailDestination(
                              icon: const Icon(Icons.edit_outlined),
                              selectedIcon: const Icon(Icons.edit_outlined),
                              label: Text('Edit',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background)),
                            ),
                            NavigationRailDestination(
                              icon: const Icon(Icons.task),
                              selectedIcon: const Icon(Icons.task),
                              label: Text('Tasks',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background)),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
