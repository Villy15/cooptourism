import 'package:flutter/material.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final List<String> _tabTitles = ['Members', 'Features'];
  int _selectedIndex = 0;
  
  final List<String> _members = [
    'John Doe',
    'Jane Doe',
    'John Smith',
    'Jane Smith',
    'John Doe',
    'John Doe',
    'Jane Doe',
    'John Smith',
    'Jane Smith',
    'John Doe',
    'John Doe',
    'Jane Doe',
    'John Smith',
    'Jane Smith',
    'John Doe',
    'John Doe',
    'Jane Doe',
    'John Smith',
    'Jane Smith',
    'John Doe',
    'John Doe',
    'Jane Doe',
    'John Smith',
    'Jane Smith',
    'John Doe',
    'John Doe',
    'Jane Doe',
    'John Smith',
    'Jane Smith',
    'John Doe',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView (
      child: Column (
        children: [
          SizedBox(
            height: 40,
            child: listViewFilter(),
          ),
    
          const SizedBox(height: 10),
          searchFilter(context),
    
          ListView.builder (
            shrinkWrap: true,
            itemCount: _members.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
  
                  ),
                title: Text(
                  _members[index],
                    style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
                  ),
              );
            },
          )
          
        ],
      ),
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
}
