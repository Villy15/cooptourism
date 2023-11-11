import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/providers/auth.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:cooptourism/router/go_router.dart';
import 'package:cooptourism/core/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/core/theme/light_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final UserRepository _userRepository = UserRepository();
  Future<UserModel?>? userFuture;

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    final userAsyncValue = ref.watch(authProvider);
    
    User? user = userAsyncValue.maybeWhen(
      data: (userData) => userData,
      orElse: () => null
    );

    _checkAndUpdateUserData(user);

    return _buildAppBasedOnUser(user, router);
  }

  Widget _buildAppBasedOnUser(User? user, GoRouter router) {
    return FutureBuilder<UserModel?>(
      future: userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildApp(router);
        }
        return _buildApp(router);
      },
    );
  }

  Widget _buildApp(GoRouter router) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }

  // This will determine if we should refetch the user data
  void _checkAndUpdateUserData(User? user) {
    if (user != null) {
      userFuture ??= _initializeUserData(user.uid);
    } else {
      userFuture = null;
    }
  }

  Future<UserModel?> _initializeUserData(String uid) async {
    UserModel? userValue = await _userRepository.getUser(uid);
    ref.read(userModelProvider.notifier).setUser(userValue);
    return userValue;
  }
}
