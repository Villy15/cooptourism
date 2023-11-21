import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeadingBackButton extends StatelessWidget {
  const LeadingBackButton({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            ref.read(navBarVisibilityProvider.notifier).state = true;
            ref.read(appBarVisibilityProvider.notifier).state = true;
            Navigator.of(context).pop(); // to go back
          },
        ),
      ),
    );
  }
}
