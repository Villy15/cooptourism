import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/providers/market_page_provider.dart';
import 'package:cooptourism/widgets/budget_slider.dart';
import 'package:cooptourism/widgets/category_picker.dart';
import 'package:cooptourism/widgets/type_picker.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:cooptourism/widgets/listing_card.dart';
import 'package:cooptourism/widgets/listing_province_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MarketPage extends ConsumerStatefulWidget {
  const MarketPage({super.key});

  @override
  ConsumerState<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends ConsumerState<MarketPage> {
  final List<String> _tabTitles = ['Services']; //];
  // final List<String> _type = ['Service']; //, 'Product'];
  // final String _province = "";
  // final String _city = "";
  // final String _category = "";
  // final String _tourismType = "";
  int _selectedIndex = 0;
  // final num _currentStart = 10000.0;
  // final num _currentEnd = 20000.0;
  bool isFilterVisible = false;
  // late ListingRepository _listingRepository = ListingRepository();
  // late Stream<List<ListingModel>> _listings;

  @override
  Widget build(BuildContext context) {
    final ListingRepository listingRepository = ListingRepository();
    // final Stream<List<ListingModel>> listings =
    //     listingRepository.getListingsByType(_type[_selectedIndex]);
    final Stream<List<ListingModel>> listings =
        listingRepository.getAllListings();
    return Scaffold(
        appBar: _appBar(context, "Market"),
        body: Column(
          children: [
            if (isFilterVisible) listingFilter(context),
            // listFilter(),
            // const SizedBox(height: 10),
            // searchFilter(context),
            Expanded(
              child: StreamBuilder<List<ListingModel>>(
                stream: listings,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}  ');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final listings = snapshot.data!;

                  return gridViewListings(listings);
                },
              ),
            ),
          ],
        ));
  }

  SizedBox listingFilter(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 1.5,
      child: Column(
        children: [
          DisplayText(
            text: "Filter",
            lines: 1,
            style: Theme.of(context).textTheme.headlineLarge!,
          ),
          const SizedBox(height: 15),
          const ListingProvinceCityPicker(),
          const SizedBox(height: 5),
          const CategoryPicker(),
          const SizedBox(height: 5),
          const TypePicker(),
          const SizedBox(height: 5),
          const BudgetSlider(),
        ],
      ),
    );
  }

  GridView gridViewListings(List<ListingModel> listings) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        mainAxisExtent: 315,
      ),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final listing = listings[index];

        return ListingCard(listingModel: listing);
      },
    );
  }

  Row searchFilter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.filter_list),
            label: const Text('Filter'),
          ),
        ),
      ],
    );
  }

  SizedBox listFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _tabTitles.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 10.0),
                  child: Text(
                    _tabTitles[index],
                    style: TextStyle(
                      color: _selectedIndex == index
                          ? Theme.of(context).colorScheme.background
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: _selectedIndex == index
                          ? FontWeight.bold
                          : FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            // backgroundColor: Colors.grey[800],
            child: IconButton(
              onPressed: () {
                setState(() {
                  isFilterVisible = !isFilterVisible;
                });
              },
              icon: const Icon(
                Icons.filter_alt_rounded,
                // color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            // backgroundColor: Colors.grey[800],
            child: IconButton(
              onPressed: () {
                ref.invalidate(marketProvinceProvider);
                ref.invalidate(marketCitiesProvider);
                context.push('/market_page/add_listing');
              },
              icon: const Icon(
                Icons.add,
                // color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
