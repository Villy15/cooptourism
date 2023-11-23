import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoopProvinceCityPicker extends StatefulWidget {
  final Function(String?, String?) onSelectionChanged;

  const CoopProvinceCityPicker({Key? key, required this.onSelectionChanged})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CoopProvinceCityPickerState createState() => _CoopProvinceCityPickerState();
}

class _CoopProvinceCityPickerState extends State<CoopProvinceCityPicker> {
  List<Map<String, dynamic>> provinces = [];
  List<String> cities = [];
  String? selectedProvince;
  String? selectedCity;

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

          // Update the state with the sorted list of provinces
          setState(() {
            provinces = initProvinces;
          });
        }
      }
    } catch (e) {
      // Handle error
      debugPrint('Failed to fetch provinces: $e');
    }
  }

  fetchCities(String? provinceCode) async {
    try {
      final response = await http.get(Uri.parse(
          'https://psgc.gitlab.io/api/provinces/$provinceCode/cities.json'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          List<Map<String, dynamic>> initCities = [];
          for (var e in data) {
            initCities.add({"code": e["code"], "name": e["name"]});
          }

          // Update the state with the list of cities
          setState(() {
            cities = initCities.map((e) => e['name'] as String).toList();
          });
        }
      }
    } catch (e) {
      // Handle error
      debugPrint('Failed to fetch cities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color.fromARGB(255, 105, 86, 86)),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Province",
              border: InputBorder.none,
            ),
            menuMaxHeight: 300,
            alignment: Alignment.center,
            value: provinces.isNotEmpty ? provinces[0]['name'] : null,
            items: provinces
                .map<DropdownMenuItem<String>>((Map<String, dynamic> province) {
              return DropdownMenuItem<String>(
                value: province['name'],
                child: Text(province['name']),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                String? provinceCode = provinces.firstWhere(
                    (province) => province['name'] == value)['code'];
                fetchCities(provinceCode);

                setState(() {
                  selectedProvince = value;
                });

                // Notify the parent widget about the selection
                widget.onSelectionChanged(
                    value, cities.isNotEmpty ? cities[0] : null);
              }
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "City",
              border: InputBorder.none,
            ),
            menuMaxHeight: 300,
            alignment: Alignment.center,
            value: cities.isNotEmpty ? cities[0] : null,
            items: cities.map<DropdownMenuItem<String>>((String city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                widget.onSelectionChanged(selectedProvince, value);
                setState(() {
                  cities = [value];
                });
              }
            },
          ),
        )
      ],
    );
  }
}
