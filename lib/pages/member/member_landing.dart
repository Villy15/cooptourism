import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:cooptourism/pages/tasks/tasks_page.dart';
import 'package:cooptourism/providers/user_provider.dart';
//import 'package:cooptourism/widgets/listing_card.dart';
import 'package:cooptourism/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final PostRepository _postRepository = PostRepository();
final ListingRepository listingRepository = ListingRepository();

class MemberDashboardPage extends ConsumerStatefulWidget {
  const MemberDashboardPage({super.key});

  @override
  ConsumerState<MemberDashboardPage> createState() => _MemberDashboardPageState();
}

class _MemberDashboardPageState extends ConsumerState<MemberDashboardPage> {
  final List<String> _tabTitles = ['Tasks', 'Services', 'Announcements'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);
    
    return Scaffold(
        appBar: _appBar(context, "Home"),
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
                servicesMethod(user!),
              ] else if (_selectedIndex == 2) ...[
                announcementsMethod(),
              ]
            ],
          ),
        ));
  }


StreamBuilder<List<ListingModel>> servicesMethod(UserModel user) {
  return StreamBuilder<List<ListingModel>>(
    stream: listingRepository.getListingsByUID(user.uid!),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      final listings = snapshot.data!;

      if (listings.isEmpty) {
        return const Center(
          child: Text(
            'No listings found for this user.',
            style: TextStyle(fontSize: 20),
          ),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 30.0),
              child: Text('Today', style: TextStyle(fontSize: 20)),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listings.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                    title: const Text(
                      'The Darwin Delight',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    subtitle: const Text(
                      'Nov 12 - 13 | 2 Pax',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {
                      },
                    ),
                  ),
                );
              },
            ),
            const Divider(
              thickness: 2.0,
            ),
          ],
        );
      }
    },
  );
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
        return Stack(
          children: [
            Padding(
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
            ),

            // Only show the notification badge on the "Announcements" tab
          if (_tabTitles[index] == "Announcements" || _tabTitles[index] == "Services")
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '1', // Replace with the actual number of announcements
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
