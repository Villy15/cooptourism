import 'package:flutter_riverpod/flutter_riverpod.dart';

final likesCounter = StateNotifierProvider<LikesCounter, int>((ref) => LikesCounter());

class LikesCounter extends StateNotifier<int> {
  LikesCounter() : super(0);

  void increment() {
    state++;
  }
}

final dislikesCounter = StateNotifierProvider<DislikesCounter, int>((ref) => DislikesCounter());

class DislikesCounter extends StateNotifier<int> {
  DislikesCounter() : super(0);

  void increment() {
    state++;
  }
}