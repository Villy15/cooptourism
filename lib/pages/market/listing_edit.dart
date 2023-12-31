import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/providers/bottom_nav_selected_listing_provider.dart';
// import 'package:cooptourism/widgets/bottom_nav_selected_listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ListingEdit extends ConsumerStatefulWidget {
  final ListingModel listing;
  const ListingEdit({super.key, required this.listing});

  @override
  ConsumerState<ListingEdit> createState() => _ListingEditState();
}

class _ListingEditState extends ConsumerState<ListingEdit> {
  @override
  Widget build(BuildContext context) {
    ListingRepository listingRepository = ListingRepository();
    TextEditingController titleController =
        TextEditingController(text: widget.listing.title);
    TextEditingController descriptionController =
        TextEditingController(text: widget.listing.description);
    TextEditingController priceController =
        TextEditingController(text: widget.listing.price.toString());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   toolbarHeight: kToolbarHeight,
      //   backgroundColor: Colors.grey[800],
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(label: Text('Title')),
                      maxLines: 1,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(label: Text('Description')),
                      maxLines: null,
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(label: Text('Price')),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          listingRepository.updateListing(
                              widget.listing.id!,
                              widget.listing.copyWith(
                                title: titleController.text,
                                description: descriptionController.text,
                                price: int.parse(priceController.text),
                              ));

                          const snackBar = SnackBar(
                            content: Text('Listing updated successfully!'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          ref
                              .read(bottomNavSelectedListingControllerProvider
                                  .notifier)
                              .setPosition(1);
                          context.pop();
                        },
                        child: const Text("Save Listing"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
