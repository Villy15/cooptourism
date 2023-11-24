import 'package:cooptourism/data/models/listing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedFoodServicePage extends ConsumerStatefulWidget {
  final ListingModel listing;
  const SelectedFoodServicePage({super.key, required this.listing});

  @override
  ConsumerState<SelectedFoodServicePage> createState() =>
      _SelectedFoodServicePageState();
}

class _SelectedFoodServicePageState
    extends ConsumerState<SelectedFoodServicePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
