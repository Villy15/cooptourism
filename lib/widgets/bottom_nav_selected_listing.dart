import 'package:cooptourism/providers/selected_listing_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomNavSelectedListing extends ConsumerStatefulWidget {
  final String listingId;
  const BottomNavSelectedListing({super.key, required this.listingId});

  @override
  ConsumerState<BottomNavSelectedListing> createState() => _BottomNavSelectedListingState();
}

class _BottomNavSelectedListingState extends ConsumerState<BottomNavSelectedListing> {

  @override
  Widget build(BuildContext context) {
  int position = ref.watch(selectedListingPageControllerProvider);
  
    return BottomNavigationBar(
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
      currentIndex: position,
      onTap: (value) => _onTap(value, position),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat_bubble_outline_outlined,
            size: 20,
            // color: Colors.white,
          ),
          label: "Messages",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.remove_red_eye_outlined,
            size: 20,
            // color: Colors.white,
          ),
          label: "View Listing",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.create_outlined,
            size: 20,
            // color: Colors.white,
          ),
          label: "Edit Listing",
        ),
      ],
    );
  }

  void _onTap(int newPosition, int oldPosition) {
    debugPrint('this is the new one $newPosition and this is the old one $oldPosition');
    ref.read(selectedListingPageControllerProvider.notifier).setPosition(newPosition);
    switch(newPosition) {
      case 0: if(oldPosition == 0 || oldPosition == 2) {
        context.replace('/market_page/${widget.listingId}/listing_messages');
      }else{
        context.push('/market_page/${widget.listingId}/listing_messages');
      }
      case 1: if((oldPosition == 0 || oldPosition == 2) && newPosition == 1) {
        context.pop();
      }
      case 2: if(oldPosition == 0 || oldPosition == 2) {
        context.replace('/market_page/${widget.listingId}/listing_edit');
      }else{
        context.push('/market_page/${widget.listingId}/listing_edit');
      }
    }
  }
}