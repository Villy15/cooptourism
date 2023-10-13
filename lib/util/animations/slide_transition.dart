import 'package:flutter/material.dart';

class SlideTransitionAnimation extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const SlideTransitionAnimation({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}