// import 'dart:convert';

import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:cooptourism/pages/home_feed/add_post.dart';
import 'package:cooptourism/core/util/animations/slide_transition.dart';
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

    // Comment out the following line to add a dummy post
    // _postRepository.addDummyPost();
    // _postRepository.deletePost('A40I177oe5IkKMPv9seU');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder<List<PostModel>>(
        stream: _posts,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final posts = snapshot.data!;

          debugPrint("Posts: $posts.toString()");

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _posts = _postRepository.getAllPosts();
              });
            },
            child: CustomScrollView(
              slivers: <Widget>[
                sliverAppBar(context),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return PostCard(postModel: posts[index]);
                    },
                    childCount: posts.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  SliverAppBar sliverAppBar(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 70,
      floating: false,
      pinned: false, // This keeps the app bar visible at the top
      title: Text(
        "lakbay",
        style: TextStyle(
            fontSize: 28,
            color: Colors.orange.shade700,
            fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                showAddPostPage(context);
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  ListView listViewPosts(List<PostModel> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        return PostCard(postModel: post);
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

  void showAddPostPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const AddPostPage();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransitionAnimation(
            animation: animation,
            child: child,
          );
        },
      ),
    );
  }
}
