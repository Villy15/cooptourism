import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<String> _tabTitles = ['Goals', 'Members'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
      children: [
        // Lists Filter
        SizedBox(
          height: 40,
          child: listViewFilter(),
        ),

        // Sales Dashboard
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20.0),
            ),
            // Circular border
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child:
                  Text('Sales', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),

        // Sales Dashboard
        SizedBox (
          height: 400,
          child: GridView.count (
            crossAxisCount: 2,
            children: [
              Container(
                height: 200,
                width: 155,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                // Circular border
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child:
                      Text('Sales', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
        
              Container(
                height: 200,
                width: 155,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                // Circular border
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child:
                      Text('Sales', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),

              Container(
                height: 200,
                width: 155,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                // Circular border
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child:
                      Text('Sales', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),

              Container(
                height: 200,
                width: 155,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                // Circular border
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child:
                      Text('Sales', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),

      ],
    ));
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
}
