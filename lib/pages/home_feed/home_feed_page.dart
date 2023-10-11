import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:cooptourism/widgets/post_card.dart';

class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({Key? key}) : super(key: key);

  @override
  HomeFeedPageState createState() => HomeFeedPageState();
}

class HomeFeedPageState extends State<HomeFeedPage> {
  final List<String> _tabTitles = ['News', 'Communities', 'Cooperatives'];
  int _selectedIndex = 0;

  late PostRepository _postRepository = PostRepository();
  late Stream<List<PostModel>> _posts;

  @override
  void initState() {
    super.initState();
    _postRepository = PostRepository();
    _posts = _postRepository.getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(
        //   height: 40,
        //   child: listViewFilter(),
        // ),
        Expanded(
          child: StreamBuilder<List<PostModel>>(
            stream: _posts,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final posts = snapshot.data!;

              return listViewPosts(posts);
            },
          ),
        ),
      ],
    );
  }

  ListView listViewPosts(List<PostModel> posts) {
    debugPrint('Number of posts: ${posts.length}');
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        // debugPrint(posts.length as String?);

        return PostCard(
          key: ValueKey(index),
          author: post.author,
          authorId: post.authorId,
          authorType: post.authorType,
          content: post.content,
          likes: post.likes,
          dislikes: post.dislikes,
          comments: post.comments,
          timestamp: post.timestamp,
          images: post.images,
        );
      },
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
}
