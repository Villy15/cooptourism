import 'package:cooptourism/data/models/listing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listingModelProvider = StateNotifierProvider<ListingModelNotifier, ListingModel?>((ref) => ListingModelNotifier());

class ListingModelNotifier extends StateNotifier<ListingModel?> {
  ListingModelNotifier() : super(null);

  void setListing(ListingModel listing) {
    state = listing;
  }
}
