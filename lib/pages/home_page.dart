import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/widgets/bottom_nav_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  final Widget child;
  const HomePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isNavBarVisible = ref.watch(navBarVisibilityProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: widget.child,
      bottomNavigationBar: isNavBarVisible
          ? Container(
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
            )
          : null,
    );
  }
}
