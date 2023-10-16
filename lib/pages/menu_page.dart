import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<String> _tabTitles = ['View Profile', 'Switch Profile'];
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _gridItems = [
    {'logo': Icons.business_outlined, 'name': 'Cooperatives', 'route': '/coops_page'},
    {'logo': Icons.shopping_bag_outlined, 'name': 'Marketplace', 'route': '/market_page' },
    // {'logo': Icons.event_outlined, 'name': 'Events', 'route': '/events_page'},
    // {'logo': Icons.inbox_outlined, 'name': 'Inbox', 'route': '/inbox_page'},
    // {'logo': Icons.book_outlined, 'name': 'Wiki', 'route': '/wiki_page'},
    // {'logo': Icons.build_outlined, 'name': 'Services', 'route': '/services_page'},
    // {'logo': Icons.bookmark_outline_outlined, 'name': 'Saved', 'route': '/saved_page'},
    // {'logo': Icons.help_outline_outlined, 'name': 'Need Help?', 'route': '/help_page'},
    // {'logo': Icons.settings_outlined, 'name': 'Settings', 'route': '/settings_page'},
    {'logo': Icons.account_balance_wallet_outlined, 'name': 'Wallet', 'route': '/wallet_page' },
    {'logo': Icons.account_balance_wallet_outlined, 'name': 'Reports', 'route': '/reports_page' },
    {'logo': Icons.people_alt_outlined, 'name': 'Members', 'route': '/members_page' },
    {'logo': Icons.inbox_outlined, 'name': 'Inbox', 'route': '/inbox_page' },
    // {'logo': Icons.content_paste_search_outlined, 'name': 'Services', 'route': '/service_page' },
    // {'logo': Icons.people_outlined, 'name': 'People', 'route': '/people'},
    // {'logo': Icons.group_outlined, 'name': 'Communities', 'route': '/communities' },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            listFilter(),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  'Shortcuts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: gridSquares(context),
              ),
            )
          ],
        ));
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

  GridView gridSquares(BuildContext context) {
    Color color = Theme.of(context).colorScheme.secondary;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 0,
        mainAxisExtent: 100,
      ),
      itemCount: _gridItems.length,
      itemBuilder: (_, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell (
            onTap: () {
              setState(() {
                color = Theme.of(context).colorScheme.primary;
              });

              context.go(_gridItems[index]['route']);
            },
            child: Ink (
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    width: 1.5,
                    style: BorderStyle.solid,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(_gridItems[index]['logo'],
                        size: 42, color: Theme.of(context).colorScheme.primary),
                    Text(
                      _gridItems[index]['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
