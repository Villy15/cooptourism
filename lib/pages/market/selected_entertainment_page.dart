import 'package:cooptourism/data/models/listing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedEntertainmentPage extends ConsumerStatefulWidget {
  final ListingModel listing;
  const SelectedEntertainmentPage({super.key, required this.listing});

  @override
  ConsumerState<SelectedEntertainmentPage> createState() =>
      _SelectedEntertainmentPageState();
}

class _SelectedEntertainmentPageState
    extends ConsumerState<SelectedEntertainmentPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
