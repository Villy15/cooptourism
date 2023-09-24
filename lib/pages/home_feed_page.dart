import 'package:flutter/material.dart';

import 'package:cooptourism/widgets/post_card.dart';

class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({Key key = const ValueKey('home_feed_page')}) : super(key: key);

  @override
  State<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  final List<String> _postTitles = [
    'Post 1',
    'Post 2',
    'Post 3',
    'Post 4',
    'Post 5',
  ];

  final List<String> _postContents = [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
    'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
  ];

  final List<String> _tabTitles = [
    'News',
    'Communities',
    'Cooperatives',
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tabTitles.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _postTitles.length,
              itemBuilder: (BuildContext context, int index) {
                return PostCard(
                  key: ValueKey(_postTitles[index]),
                  title: _postTitles[index],
                  content: _postContents[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}