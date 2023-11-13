import 'package:cooptourism/data/models/listing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketProvincesProvider = StateNotifierProvider<MarketProvincesProvider, List<Map<String, dynamic>>>((ref) => MarketProvincesProvider());
final marketProvinceProvider = StateNotifierProvider<MarketProvinceProvider, String?>((ref) => MarketProvinceProvider());
final marketAddListingProvider = StateNotifierProvider<MarketAddListingProvider, ListingModel?>((ref) => MarketAddListingProvider());
final marketCitiesProvider = StateNotifierProvider<MarketCitiesProvider, List<String>>((ref) => MarketCitiesProvider());
final marketCityProvider = StateNotifierProvider<MarketCityProvider, String?>((ref) => MarketCityProvider());
final marketCategoryProvider = StateNotifierProvider<MarketCategoryProvider, String?>((ref) => MarketCategoryProvider());
final marketTypeProvider = StateNotifierProvider<MarketTypeProvider, String?>((ref) => MarketTypeProvider());
final marketCurrentStartProvider = StateNotifierProvider<MarketCurrentStartProvider, num?>((ref) => MarketCurrentStartProvider());
final marketCurrentEndProvider = StateNotifierProvider<MarketCurrentEndProvider, num?>((ref) => MarketCurrentEndProvider());

class MarketAddListingProvider extends StateNotifier<ListingModel?> {
  MarketAddListingProvider() : super(ListingModel());

  void setAddListing(ListingModel addListing) {
    state = addListing;
  }
}

class MarketProvincesProvider extends StateNotifier<List<Map<String, dynamic>>> {
  MarketProvincesProvider() : super([]);

  void setProvinces(List<Map<String, dynamic>> provinces) {
    state = provinces;
  }
}
class MarketProvinceProvider extends StateNotifier<String?> {
  MarketProvinceProvider() : super(null);

  void setProvince(String province) {
    state = province;
  }
}
class MarketCitiesProvider extends StateNotifier<List<String>> {
  MarketCitiesProvider() : super([]);

  void setCities(List<String> cities) {
    state = cities;
  }
}

class MarketCityProvider extends StateNotifier<String?> {
  MarketCityProvider() : super(null);

  void setCity(String city) {
    state = city;
  }
}

class MarketCategoryProvider extends StateNotifier<String?> {
  MarketCategoryProvider() : super(null);

  void setCategory(String category) {
    state = category;
  }
}
class MarketTypeProvider extends StateNotifier<String?> {
  MarketTypeProvider() : super(null);

  void setType(String type) {
    state = type;
  }
}

class MarketCurrentStartProvider extends StateNotifier<num?> {
  MarketCurrentStartProvider() : super(null);

  void setCurrentStart(num currentStart) {
    state = currentStart;
  }
}
class MarketCurrentEndProvider extends StateNotifier<num?> {
  MarketCurrentEndProvider() : super(null);

  void setCurrentEnd(num currentEnd) {
    state = currentEnd;
  }
}