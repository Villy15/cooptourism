import 'package:cooptourism/providers/market_page_provider.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListingProvinceCityPicker extends ConsumerStatefulWidget {
  const ListingProvinceCityPicker({super.key});

  @override
  ConsumerState<ListingProvinceCityPicker> createState() =>
      _ListingProvinceCityPickerState();
}

class _ListingProvinceCityPickerState
    extends ConsumerState<ListingProvinceCityPicker> {
  List<Map<String, dynamic>> provinces = [];
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    fetchProvinces();
  }

  fetchProvinces() async {
    try {
      final response = await http
          .get(Uri.parse('https://psgc.gitlab.io/api/provinces.json'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          List<Map<String, dynamic>> initProvinces = [];
          for (var e in data) {
            initProvinces.add({"code": e["code"], "name": e["name"]});
          }

          initProvinces.sort(
              (a, b) => (a['name'] as String).compareTo(b['name'] as String));

          ref
              .read(marketProvincesProvider.notifier)
              .setProvinces(initProvinces);
        } else {
          // Handle the case when the API returns an empty list
          debugPrint('No provinces data found');
          // You may want to update your UI accordingly
        }
      } else {
        // Handle the case when the server returns a non-200 status code
        debugPrint('Failed to load provinces data: ${response.statusCode}');
        // You may want to show an error message to the user
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      debugPrint('Error fetching provinces data: $e');
      // You may want to show an error message to the user
    }
  }

  fetchCities(String province) async {
    try {
      final response = await http.get(Uri.parse(
          'https://psgc.gitlab.io/api/provinces/$province/cities.json'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          List<String> cityNames = [];
          for (var e in data) {
            cityNames.add(e['name']);
          }
          ref.read(marketAddListingProvider.notifier).setAddListing(ref
              .watch(marketAddListingProvider)!
              .copyWith(city: cityNames[0]));
          ref.read(marketCitiesProvider.notifier).setCities(cityNames);
        } else {
          // Handle the case when the API returns an empty list
          debugPrint('No cities data found for province $province');
          ref.read(marketCitiesProvider.notifier).setCities([""]);
          ref.read(marketAddListingProvider.notifier).setAddListing(
              ref.watch(marketAddListingProvider)!.copyWith(city: ""));
          // You may want to update your UI accordingly
        }
      } else {
        // Handle the case when the server returns a non-200 status code
        debugPrint(
            'Failed to load cities data for province $province: ${response.statusCode}');
        ref.read(marketCitiesProvider.notifier).setCities([""]);
        ref.read(marketAddListingProvider.notifier).setAddListing(
            ref.watch(marketAddListingProvider)!.copyWith(city: ""));

        // You may want to show an error message to the user
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      debugPrint('Error fetching cities data for province $province: $e');
      ref.read(marketCitiesProvider.notifier).setCities([""]);
      ref.read(marketAddListingProvider.notifier).setAddListing(
          ref.watch(marketAddListingProvider)!.copyWith(city: ""));
      // You may want to show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), // Create a circular shape
            border: Border.all(color: Colors.grey, width: 1), // Add a border
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Province",
                border: InputBorder.none,
              ),
              menuMaxHeight: 300,
              alignment: Alignment.center,
              value: ref.watch(marketProvinceProvider),
              onChanged: (newValue) {
                List<Map<String, dynamic>> provinces =
                    ref.watch(marketProvincesProvider);
                ref
                    .read(marketProvinceProvider.notifier)
                    .setProvince(newValue!);
                ref.read(marketAddListingProvider.notifier).setAddListing(
                      ref.watch(marketAddListingProvider)!.copyWith(
                            province: provinces[provinces.indexWhere(
                                    (element) => element["code"] == newValue)]
                                ["name"],
                          ),
                    );
                fetchCities(newValue);
              },
              items: ref
                  .watch(marketProvincesProvider)
                  .map<DropdownMenuItem<String>>(
                      (Map<String, dynamic> province) {
                return DropdownMenuItem<String>(
                  alignment: Alignment.center,
                  value: province["code"],
                  child: DisplayText(
                    text: province["name"],
                    lines: 1,
                    style: Theme.of(context).textTheme.headlineSmall!,
                  ),
                );
              }).toList(),
              iconSize: 30.0,
              isExpanded: true,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), // Create a circular shape
            border: Border.all(color: Colors.grey, width: 1), // Add a border
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "City",
                border: InputBorder.none,
              ),
              menuMaxHeight: 300,
              alignment: Alignment.center,
              value: ref.watch(marketAddListingProvider)!.city,
              onChanged: (newValue) {
                ref.read(marketAddListingProvider.notifier).setAddListing(ref
                    .watch(marketAddListingProvider)!
                    .copyWith(city: newValue));
              },
              items: ref
                  .watch(marketCitiesProvider)
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  alignment: Alignment.center,
                  value: value,
                  child: DisplayText(
                    text: value,
                    lines: 1,
                    style: Theme.of(context).textTheme.headlineSmall!,
                  ),
                );
              }).toList(),
              iconSize: 30.0,
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }
}
