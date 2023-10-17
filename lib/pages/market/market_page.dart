import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/widgets/listing_card.dart';
import 'package:flutter/material.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final List<String> _tabTitles = ['Shop', 'Sell', 'Cooperatives'];
  int _selectedIndex = 0;

  late ListingRepository _listingRepository = ListingRepository();
  late Stream<List<ListingModel>> _listings;

  @override
  void initState() {
    super.initState();
    _listingRepository = ListingRepository();
    _listings = _listingRepository.getAllListings();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            // listFilter(),
            const SizedBox(height: 10),
            searchFilter(context),
            Expanded(
              child: StreamBuilder<List<ListingModel>>(
                stream: _listings,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final listings = snapshot.data!;

                  return gridViewListings(listings);
                },
              ),
            )
          ],
        );
  }

  GridView gridViewListings(List<ListingModel> listings) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        mainAxisExtent: 300,
      ),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final listing = listings[index];
        return ListingCard(
          listingModel: ListingModel(
            id: listing.id,
            owner: listing.owner,
            title: listing.title,
            description: listing.description,
            rating: listing.rating,
            amenities: listing.amenities,
            price: listing.price,
            type: listing.type,
            postDate: listing.postDate,
            images: listing.images,
            visits: listing.visits,
          ),
        );
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
}
