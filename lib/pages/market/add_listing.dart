import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddListing extends ConsumerStatefulWidget {
  const AddListing({super.key});

  @override
  ConsumerState<AddListing> createState() => _AddListingState();
}

enum ListingType { service, product }

class _AddListingState extends ConsumerState<AddListing> {
  ListingType type = ListingType.service;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = true;
      ref.read(navBarVisibilityProvider.notifier).state = false;
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
              const TextField(
                decoration: InputDecoration(label: Text("Title")),
              ),
              const TextField(
                decoration: InputDecoration(label: Text("Description")),
              ),
              ListTile(
                title: const Text("Service"),
                leading: Radio<ListingType>(
                  value: ListingType.service,
                  groupValue: type,
                  onChanged: (value) {
                    setState(() {
                      type = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text("Product"),
                leading: Radio<ListingType>(
                  value: ListingType.product,
                  groupValue: type,
                  onChanged: (value) {
                    setState(() {
                      type = value!;
                    });
                  },
                ),
              ),
              const TextField(
                decoration: InputDecoration(label: Text("Price")),
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 15.0),
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text("Submit Listing"),
                ),
              )
            ],
          ),
        ));
  }
}
