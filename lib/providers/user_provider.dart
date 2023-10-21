import 'package:cooptourism/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userModelProvider = StateNotifierProvider<UserModelNotifier, UserModel?>((ref) => UserModelNotifier());

class UserModelNotifier extends StateNotifier<UserModel?> {
  UserModelNotifier() : super(null);

  void setUser(UserModel user) {
    state = user;
  }
}
