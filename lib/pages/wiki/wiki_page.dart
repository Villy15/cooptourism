import 'package:cooptourism/data/models/wiki.dart';
import 'package:cooptourism/data/repositories/wiki_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final WikiRepository wikiRepository = WikiRepository();

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

  // Comment out the initState() method to remove manual data input
  // @override
  // void initState() {
  //   super.initState();
  //   wikiRepository.addWikiManually();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Wiki"),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: listViewFilter(),
              ),
              // New Here?

              if (_selectedIndex == 0) ...[
                recommendedSection(context),
                wikiHeading("Popular Reads"),
                streamBuilderWiki()
              ] else if (_selectedIndex == 1) ...[
                wikiHeading("Saved Reads"),
                streamBuilderWiki()
              ] else if (_selectedIndex == 2) ...[
                wikiHeading("All Reads"),
                streamBuilderWiki()
              ],
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<WikiModel>> streamBuilderWiki() {
    return StreamBuilder(
        stream: wikiRepository.getAllWiki(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // show a loader while waiting for data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No data available');
          } else {
            List<WikiModel> wikiList = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: wikiList.length,
              itemBuilder: (context, index) {
                return wikiCard(context, wikiList[index]);
              },
            );
          }
        });
  }

  Padding wikiHeading(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    : Theme.of(context).colorScheme.background,
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['text'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Icon(
                      item['logo'],
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

  Widget wikiCard(BuildContext context, WikiModel wiki) {
    return GestureDetector(
      onTap: () {
        context.go('/wiki_page/${wiki.uid}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // If wiki.image is is null, dont show an image icon, else show the image
            if (wiki.image != "")
              Center(
                child: Icon(
                  Icons.image,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    maxLines: 1,
                    wiki.title ?? 'No title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Add fav icon here
                IconButton(
                  icon: Icon(Icons.favorite_border,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    // Add your favorite logic here.
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              maxLines: 2,
              wiki.description ?? 'No description',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
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
            child: IconButton(
              onPressed: () {
                // showAddPostPage(context);
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
          ),
        )
      ],
    );
  }
}
