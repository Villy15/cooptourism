import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/widgets/category_type_picker.dart';
import 'package:cooptourism/widgets/province_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddListing extends ConsumerStatefulWidget {
  const AddListing({super.key});

  @override
  ConsumerState<AddListing> createState() => _AddListingState();
}

class _AddListingState extends ConsumerState<AddListing> {
  String listingType = "Service";
  String _province = "";
  String _city = "";
  String _category = "";
  String _tourismType = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = true;
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  }

  void setProvince(String province) {
    setState(() {
      _province = province;
    });
  }

  void setCity(String city) {
    setState(() {
      _city = city;
    });
  }

  void setCategory(String category) {
    setState(() {
      _category = category;
    });
  }

  void setType(String type) {
    setState(() {
      _tourismType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Listing"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12), // Padding inside the container
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the container
                  borderRadius: BorderRadius.circular(20), // Makes it circular
                  border: Border.all(
                    color: Colors.grey, // Color of the border
                    width: 1, // Width of the border
                  ),
                ),
                child: Form(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Title"),
                      border: InputBorder.none, // Removes underline
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null; // Return null if the entered value is valid
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12), // Padding inside the container
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the container
                  borderRadius: BorderRadius.circular(20), // Makes it circular
                  border: Border.all(
                    color: Colors.grey, // Color of the border
                    width: 1, // Width of the border
                  ),
                ),
                child: Form(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Description"),
                      border: InputBorder.none, // Removes underline
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null; // Return null if the entered value is valid
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CategoryTypePicker(setCategory: setCategory, setType: setType),
              const SizedBox(height: 5),
              ProvinceCityPicker(setProvince: setProvince, setCity: setCity),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12), // Padding inside the container
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the container
                  borderRadius: BorderRadius.circular(20), // Makes it circular
                  border: Border.all(
                    color: Colors.grey, // Color of the border
                    width: 1, // Width of the border
                  ),
                ),
                child: Form(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Price"),
                      border: InputBorder.none, // Removes underline
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null; // Return null if the entered value is valid
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 15.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Submit Listing"),
                ),
              )
            ],
          ),
        ));
  }
}
