import 'package:flutter/material.dart';

class WikiPage extends StatefulWidget {
  const WikiPage({super.key});

  @override
  State<WikiPage> createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  final List<String> _tabTitles = ['Featured', 'Saved', 'All'];
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _recommended = [
    {'logo': Icons.policy, 'text': 'Standard Policies in our co-op'},
    {
      'logo': Icons.settings_accessibility,
      'text': 'How to use our co-op services'
    },
    {'logo': Icons.analytics, 'text': 'How to use your analytics'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: listViewFilter(),
        ),
        // New Here?
        recommendedSection(context),

        // The Fertilizer UI starts here

        // Text popular reads and align it from the start
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Popular Reads',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.image,
                  size: 80,
                  color: Theme.of(context)
                      .colorScheme
                      .primary), // Placeholder for the image.
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded (
                    child: Text(
                      'Fertilizer Types and their Effectiveness',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // Add fav icon here
                  IconButton(
                    icon: Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary),
                    onPressed: () {
                      // Add your favorite logic here.
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Different types of fertilizers exhibit varying levels of effectiveness in promoting plant growth and improving soil fertility. Organic fertilizers, derived from natural sources such as compost, manure...',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ListView listViewFilter() {
    return ListView.builder(
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
    );
  }

  Column recommendedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text('New here?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _recommended.length,
            padding: const EdgeInsets.only(left: 15, right: 15),
            separatorBuilder: ((context, index) => const SizedBox(width: 15)),
            itemBuilder: (context, index) {
              final item = _recommended[index]; // Get the current item

              return Container(
                width: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['text'],
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Icon(
                      item['logo'],
                      color: Colors.white,
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
