import 'package:cooptourism/data/repositories/app_config_repository.dart';
import 'package:cooptourism/widgets/display_text.dart';
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
    final Future<List<String>> categories =
        appConfigRepository.getTourismCategories();
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
              return buildDropdownButton(
                  "Category", snapshot.data!, selectedCategory, (newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              });
            }
          },
        ),
        const SizedBox(height: 5), // To give some space between the dropdowns
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
              return buildDropdownButton("Type", snapshot.data!, selectedType,
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

  Widget buildDropdownButton(String title, List<String> items,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Container(
      width: MediaQuery.sizeOf(context).width / 1.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Create a circular shape
        border: Border.all(color: Colors.grey, width: 1.5), // Add a border
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButton<String>(
          menuMaxHeight: 300,
          alignment: Alignment.center,
          value: selectedValue,
          hint: Text(title),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
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
          underline: Container(
            height: 0,
          ),
        ),
      ),
    );
  }
}
