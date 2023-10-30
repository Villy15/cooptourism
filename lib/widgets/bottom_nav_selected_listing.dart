import 'package:cooptourism/providers/bottom_nav_selected_listing_provider.dart';
import 'package:cooptourism/providers/listing_provider.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomNavSelectedListing extends ConsumerStatefulWidget {
  final String listingId;
  const BottomNavSelectedListing({super.key, required this.listingId});

  @override
  ConsumerState<BottomNavSelectedListing> createState() =>
      _BottomNavSelectedListingState();
}

class _BottomNavSelectedListingState
    extends ConsumerState<BottomNavSelectedListing> {
  @override
  Widget build(BuildContext context) {
    int position = ref.watch(bottomNavSelectedListingControllerProvider);

    return BottomNavigationBar(
      elevation: 0,
      showUnselectedLabels: true,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      showSelectedLabels: true,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      selectedLabelStyle:
          TextStyle(color: Theme.of(context).colorScheme.primary),
      unselectedItemColor: Colors.grey[400],
      unselectedLabelStyle:
          TextStyle(color: Theme.of(context).colorScheme.primary),
      backgroundColor: Theme.of(context).colorScheme.background,
      currentIndex: position,
      onTap: (value) => _onTap(value, position),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat_bubble_outline_outlined,
            size: 22.5,
            // color: Colors.white,
          ),
          label: "Messages",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.remove_red_eye_outlined,
            size: 22.5,
            // color: Colors.white,
          ),
          label: "View Listing",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.create_outlined,
            size: 22.5,
            // color: Colors.white,
          ),
          label: "Edit Listing",
        ),
      ],
    );
  }

  Future<void> _onTap(int newPosition, int oldPosition) async {
    // final role = ref.watch(userModelProvider)!.role;
    final userId = ref.watch(userModelProvider)!.uid;
    ref
        .read(bottomNavSelectedListingControllerProvider.notifier)
        .setPosition(newPosition);
    final listing = ref.watch(listingModelProvider);
    if (context.mounted) {
      switch (newPosition) {
        case 0:
          if (userId == listing!.owner) {
            if (oldPosition == 0 || oldPosition == 2) {
              context.pushReplacement(
                  '/market_page/${widget.listingId}/listing_messages_inbox/');
            } else {
              context.push(
                  '/market_page/${widget.listingId}/listing_messages_inbox/');
            }
          } else {
            if (oldPosition == 0 || oldPosition == 2) {
              context.pushReplacement(
                  '/market_page/${widget.listingId}/listing_messages_inbox/$userId');
            } else {
              context.push(
                  '/market_page/${widget.listingId}/listing_messages_inbox/$userId');
            }
          }
        case 1:
          if ((oldPosition == 0 || oldPosition == 2) && newPosition == 1) {
            context.pop();
          }
        case 2:
          if (oldPosition == 0 || oldPosition == 2) {
            context.pushReplacement(
                '/market_page/${widget.listingId}/listing_edit');
          } else {
            context.push('/market_page/${widget.listingId}/listing_edit');
          }
      }
    }
  }
}
