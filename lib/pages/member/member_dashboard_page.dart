import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:cooptourism/pages/tasks/tasks_page.dart';
import 'package:cooptourism/widgets/post_card.dart';
import 'package:flutter/material.dart';

final PostRepository _postRepository = PostRepository();

class MemberDashboardPage extends StatefulWidget {
  const MemberDashboardPage({super.key});

  @override
  State<MemberDashboardPage> createState() => _MemberDashboardPageState();
}

class _MemberDashboardPageState extends State<MemberDashboardPage> {
  final List<String> _tabTitles = ['Tasks', 'Announcements'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context, "Dashboard"),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: listViewFilter(),
              ),
              if (_selectedIndex == 0) ...[
                const TasksPage(),
              ] else if (_selectedIndex == 1) ...[
                announcementsMethod(),
              ]
            ],
          ),
        ));
  }

  StreamBuilder<List<dynamic>> announcementsMethod() {
    return StreamBuilder<List<PostModel>>(
      stream: _postRepository.getAllPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final posts = snapshot.data!;

        debugPrint("Posts: $posts.toString()");

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostCard(
              postModel: posts[index],
            );
          },
        );
      },
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                // showAddPostPage(context);
              },
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
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
}
