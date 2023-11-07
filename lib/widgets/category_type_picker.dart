import 'package:cooptourism/data/repositories/app_config_repository.dart';
import 'package:flutter/material.dart';

class CategoryTypePicker extends StatefulWidget {
  final Function setCategory;
  final Function setType;

  const CategoryTypePicker({
    super.key,
    required this.setCategory,
    required this.setType,
  });

  @override
  CategoryTypePickerState createState() => CategoryTypePickerState();
}

class CategoryTypePickerState extends State<CategoryTypePicker> {
  String? selectedCategory;
  String? selectedType;
  // List<String> categories = [];
  // List<String> types = [];

  @override
  Widget build(BuildContext context) {
    final AppConfigRepository appConfigRepository = AppConfigRepository();
    final Future<List<String>> categories = appConfigRepository.getTourismCategories();
    final Future<List<String>> types = appConfigRepository.getTourismTypes();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FutureBuilder<List<String>>(
          future: categories, // your Future<List<String>> for categories
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // show loader while waiting for data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // snapshot.data now contains your List<String> for categories
              return buildDropdownButton("Categories", snapshot.data!, selectedCategory,
                  (newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              });
            }
          },
        ),
        const SizedBox(width: 0), // To give some space between the dropdowns
        FutureBuilder<List<String>>(
          future: types, // your Future<List<String>> for types
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // show loader while waiting for data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // snapshot.data now contains your List<String> for types
              return buildDropdownButton("Types", snapshot.data!, selectedType,
                  (newValue) {
                setState(() {
                  selectedType = newValue;
                });
              });
            }
          },
        ),
      ],
    );
  }
  Widget buildDropdownButton(String title, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
  return Container(
    // width: 150,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0), // Create a circular shape
      border: Border.all(color: Colors.grey, width: 1.5), // Add a border
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton<String>(
        alignment: Alignment.center,
        value: selectedValue,
        hint: Text(title),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
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
  );
}

}
