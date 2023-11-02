import 'package:cooptourism/core/theme/dark_theme.dart';
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
      body: SingleChildScrollView (
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            deliveryAddress(),
            const Divider(thickness: 1),
            productListing(),
            const Divider(),
            deliveryNotes(),
            const Divider(thickness: 1),
            paymentOptions(),
            const Divider(thickness: 1),
      
           
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Place Order'),
              ),
            )
          ],
        ),
      )
    );
  }

  Column deliveryNotes() {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text('Delivery Notes',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    fillColor: primaryColor.withOpacity(0.1),
                    hintText: 'Type your message here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  Padding paymentOptions() {
    return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.payment),
            title: Text('Payment Option', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Paymaya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primaryColor)),
                SizedBox(width: 8),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        );
  }

  Container productListing() {
    return Container(
          color: Colors.grey.shade200,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                    child: Text('Timothy Mendoza | ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor)),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Text('Iwahori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primaryColor)),
                  ),
                ],
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  imageProduct(),
                  
                  imageDesc()
                ],
              )
              
            ],
          ),
        );
  }

  Padding deliveryAddress() {
    return const Padding(
          padding: EdgeInsets.all(16.0),
          child: ListTile(
            // Leading of a map icon
            leading: Icon(Icons.pin_drop_outlined),
            contentPadding: EdgeInsets.zero,
            title: Text('Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Adrian Villanueva | 0917 777 8888', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                Text('4A Makapuno Residences Pasig City', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              ],
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        );
  }

  Column imageDesc() {
    return const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                        child: Text('Large Eggs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primaryColor)),
                      ),


                      Row(
                        // Space between
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                            child: Text('Php10.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primaryColor)),
                          ),

                           Padding(
                            padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                            child: Text('x24', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primaryColor)),
                          ),
                        ],
                      ),
                    ],

                  );
  }

  Padding imageProduct() {
    return Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                    child: Container(
                      // Add temp image
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                  
                      child: Center(
                        child: Icon(Icons.image_outlined, color: Colors.grey.shade400),
                      ),
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