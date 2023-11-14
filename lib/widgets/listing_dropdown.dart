import 'package:cooptourism/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListingDropdown extends ConsumerStatefulWidget {
  final String title;
  final dynamic future;
  final String? selectedValue;
  final ValueChanged<String?> onValueChange;
  const ListingDropdown({
    super.key,
    required this.title,
    required this.future,
    required this.selectedValue,
    required this.onValueChange,
  });

  @override
  ConsumerState<ListingDropdown> createState() => _ListingDropdownState();
}

class _ListingDropdownState extends ConsumerState<ListingDropdown> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: widget.future, // your Future<List<String>> for types
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // show loader while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // snapshot.data now contains your List<String> for types
          return buildDropdownButton(
            // snapshot.data!, ref.watch(marketCategoryProvider), (newValue) {
            snapshot.data!,
          );
        }
      },
    );
  }

  Widget buildDropdownButton(List<String> items) {
    return Container(
      // width: MediaQuery.sizeOf(context).width / 1.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Create a circular shape
        border: Border.all(color: Colors.grey, width: 1), // Add a border
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: widget.title,
            border: InputBorder.none,
          ),
          menuMaxHeight: 300,
          alignment: Alignment.center,
          value: widget.selectedValue,
          onChanged: widget.onValueChange,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              alignment: Alignment.centerLeft,
              value: value,
              child: DisplayText(
                text: value,
                lines: 2,
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
