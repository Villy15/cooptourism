import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedListingPageControllerProvider = StateNotifierProvider<SelectedListingPageController, int>((ref) {
  return SelectedListingPageController(1);
});


class SelectedListingPageController extends StateNotifier<int> {
  SelectedListingPageController(super.state);

  void setPosition (int value ){
    state = value;
  }
}