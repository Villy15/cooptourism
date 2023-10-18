import 'package:cooptourism/controller/home_page_controller.dart';
import 'package:cooptourism/controller/user_provider.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/widgets/bottom_nav_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  final Widget child;
  final String appTitle;
  const HomePage({Key? key, required this.child, required this.appTitle})
      : super(key: key);

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final UserRepository _userRepository = UserRepository();

  // Current user
  // UserModel? _user;

  @override
  void initState() {
    super.initState();

    _userRepository.getUser(user!.uid).then((value) {
      setState(() {
        ref.read(userModelProvider.notifier).setUser(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final isAppBarVisible = ref.watch(appBarVisibilityProvider);
    final isNavBarVisible = ref.watch(navBarVisibilityProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      // appBar: isAppBarVisible ? AppBar(
      //   title: Text(widget.appTitle),
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         Icons.logout,
      //         color: Theme.of(context).colorScheme.primary,
      //       ),
      //       onPressed: signOut,
      //     ),
      //   ],
      // ) : null,
      body: widget.child,
      bottomNavigationBar: isNavBarVisible ? Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
            child: BottomNavHomeWidget(),
          ),
        ),
      ) : null,
    );
  }

  void signOut() async {
    if (mounted) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
