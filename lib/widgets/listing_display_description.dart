import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:flutter/material.dart';

String addSpaces(String description) {
  List<String> sentences = description.split('. ');
  for (int i = 3; i < sentences.length; i += 4) {
    sentences[i] = '\n\n\n${sentences[i]}';
  }
  return sentences.join('.');
}

Column listingDisplayDescription(ListingModel listing, BuildContext context) {
  String descriptionWithSpaces = addSpaces(listing.description!);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DisplayText(
          text: descriptionWithSpaces,
          lines: 5,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          showModalBottomSheet(
            // show indicator drag
            isScrollControlled: true,
            enableDrag: true,
            showDragHandle: true,
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.sizeOf(context).height * 0.7,
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DisplayText(
                        text: 'About this Space',
                        lines: 1,
                        style: Theme.of(context).textTheme.titleLarge!,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        descriptionWithSpaces,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelLarge?.fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Text('Show More'),
      ),
    ],
  );
}
