import 'package:cooptourism/data/repositories/app_config_repository.dart';
import 'package:cooptourism/providers/market_page_provider.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryPicker extends ConsumerStatefulWidget {
  const CategoryPicker({super.key});

  @override
  ConsumerState<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends ConsumerState<CategoryPicker> {

  @override
  Widget build(BuildContext context) {
          final AppConfigRepository appConfigRepository = AppConfigRepository();
    final Future<List<String>> categories =
        appConfigRepository.getTourismCategories();
    return FutureBuilder<List<String>>(
            future: categories, // your Future<List<String>> for types
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // show loader while waiting for data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // snapshot.data now contains your List<String> for types
                return buildDropdownButton("Category", snapshot.data!, ref.watch(marketCategoryProvider),
                    (newValue) {
                  ref.read(marketCategoryProvider.notifier).setCategory(newValue!);
                });
              }
            },
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