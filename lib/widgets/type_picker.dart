import 'package:cooptourism/data/repositories/app_config_repository.dart';
import 'package:cooptourism/providers/market_page_provider.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypePicker extends ConsumerStatefulWidget {
  const TypePicker({
    super.key,
  });

  @override
  ConsumerState<TypePicker> createState() => _TypePickerState();
}

class _TypePickerState extends ConsumerState<TypePicker> {
  String? selectedCategory;
  String? selectedType;

  @override
  Widget build(BuildContext context) {
    final AppConfigRepository appConfigRepository = AppConfigRepository();
    final Future<List<String>> types = appConfigRepository.getTourismTypes();

    return 
        FutureBuilder<List<String>>(
          future: types, // your Future<List<String>> for categories
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // show loader while waiting for data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // snapshot.data now contains your List<String> for categories
              return buildDropdownButton(
                  snapshot.data!, ref.watch(marketTypeProvider),
                  (newValue) {
                ref
                    .read(marketTypeProvider.notifier)
                    .setType(newValue!);
              });
            }
          },
        );
  }

  Widget buildDropdownButton(List<String> items,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Container(
      // width: MediaQuery.sizeOf(context).width / 1.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Create a circular shape
        border: Border.all(color: Colors.grey, width: 1), // Add a border
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "Type",
            border: InputBorder.none,
          ),
          menuMaxHeight: 300,
          alignment: Alignment.center,
          value: selectedValue,
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
        ),
      ),
    );
  }
}
