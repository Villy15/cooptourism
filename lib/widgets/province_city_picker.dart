import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProvinceCityPicker extends StatefulWidget {
  final Function setProvince;
  final Function setCity;

  const ProvinceCityPicker({
    super.key,
    required this.setProvince,
    required this.setCity,
  });

  @override
  ProvinceCityPickerState createState() => ProvinceCityPickerState();
}

class ProvinceCityPickerState extends State<ProvinceCityPicker> {
  String? selectedProvince;
  String? selectedCity;
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

          setState(() {
            provinces = initProvinces;
          });
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

          setState(() {
            cities = cityNames;
          });
        } else {
          // Handle the case when the API returns an empty list
          debugPrint('No cities data found for province $province');
          // You may want to update your UI accordingly
        }
      } else {
        // Handle the case when the server returns a non-200 status code
        debugPrint(
            'Failed to load cities data for province $province: ${response.statusCode}');
        // You may want to show an error message to the user
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      debugPrint('Error fetching cities data for province $province: $e');
      // You may want to show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          // width: 150,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(30.0), // Create a circular shape
            border: Border.all(color: Colors.grey, width: 1.5), // Add a border
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DropdownButton<String>(
              alignment: Alignment.center,
              value: selectedProvince,
              hint: const Text('Province'),
              onChanged: (newValue) {
                setState(() {
                  selectedProvince = newValue;
                  cities.clear();
                  selectedCity = null;
                  widget.setProvince(selectedProvince);
                  fetchCities(selectedProvince!);
                });
              },
              items: provinces.map<DropdownMenuItem<String>>(
                  (Map<String, dynamic> province) {
                return DropdownMenuItem<String>(
                  value: province["code"],
                  child: Text(province["name"]),
                );
              }).toList(),
              iconSize: 30.0,
              isExpanded: true,
              underline: Container(
                height: 0,
              ),
            ),
          ),
        ),
        Container(
          // width: 150,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(30.0), // Create a circular shape
            border: Border.all(color: Colors.grey, width: 1.5), // Add a border
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DropdownButton<String>(
              alignment: Alignment.center,
              value: selectedCity,
              hint: const Text('City'),
              onChanged: (newValue) {
                setState(() {
                  selectedCity = newValue;
                  widget.setCity(selectedCity);
                });
              },
              items: cities.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              iconSize: 30.0,
              isExpanded: true,
              underline: Container(
                height: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
