import 'package:flutter/material.dart';
import 'package:cooptourism/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({Key? key}) : super(key: key);

  @override
  HomeFeedPageState createState() => HomeFeedPageState();
}

class HomeFeedPageState extends State<HomeFeedPage> {
  final List<String> _tabTitles = ['News', 'Communities', 'Cooperatives'];
  int _selectedIndex = 0;

  final Stream<QuerySnapshot> _posts = FirebaseFirestore.instance.collection('posts').snapshots();

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
                        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
                        child: Text(
                          _tabTitles[index],
                          style: TextStyle(
                            color: _selectedIndex == index
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).colorScheme.primary,
                            fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.w400,
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _posts,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index].data() as Map<String, dynamic>;

                    return PostCard(
                      key: ValueKey(posts[index].id),
                      author: post['author'] ?? '',
                      content: post['content'] ?? '',
                      likes: post['likes'] ?? 0,
                      dislikes: post['dislikes'] ?? 0,
                      comments: post['comments'] ?? [],
                      timestamp: post['timestamp'] ?? Timestamp.now(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}