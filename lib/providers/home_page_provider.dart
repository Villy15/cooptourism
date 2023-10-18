import 'package:flutter_riverpod/flutter_riverpod.dart';

final homePageControllerProvider = StateNotifierProvider<HomePageController, int>((ref) {
  return HomePageController(0);
});


class HomePageController extends StateNotifier<int> {
  HomePageController(super.state);

  void setPosition (int value ){
    state = value;
  }
}

final appBarVisibilityProvider = StateProvider<bool>((ref) => true);
final navBarVisibilityProvider = StateProvider<bool>((ref) => true);