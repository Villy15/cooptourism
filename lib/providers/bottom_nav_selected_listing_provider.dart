import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavSelectedListingControllerProvider = StateNotifierProvider<BottomNavSelectedListingController, int>((ref) {
  return BottomNavSelectedListingController(1);
});


class BottomNavSelectedListingController extends StateNotifier<int> {
  BottomNavSelectedListingController(super.state);

  void setPosition (int value ){
    state = value;
  }
}