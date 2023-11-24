import 'package:cooptourism/data/models/listing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedTransportationPage extends ConsumerStatefulWidget {
  final ListingModel listing;
  const SelectedTransportationPage({super.key, required this.listing});

  @override
  ConsumerState<SelectedTransportationPage> createState() =>
      _SelectedTransportationPageState();
}

class _SelectedTransportationPageState
    extends ConsumerState<SelectedTransportationPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
