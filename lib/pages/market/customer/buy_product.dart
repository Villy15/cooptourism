import 'package:cooptourism/data/models/listing.dart';
import 'package:flutter/material.dart';

class BuyProductPage extends StatefulWidget {
  final ListingModel listing;
  const BuyProductPage({super.key, required this.listing});

  @override
  State<BuyProductPage> createState() => _ContributeEventPageState();
}

class _ContributeEventPageState extends State<BuyProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Buy Product"),
      body: const Center(
        child: Text('Buy Product'),
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title, style: TextStyle(fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: IconButton(
                onPressed: () {
                  // showAddPostPage(context);
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ),
        ),
      ],
    );
  }
}