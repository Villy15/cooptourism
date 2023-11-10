// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cooptourism/pages/manager/member_profile.dart';
// import 'package:cooptourism/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

final CooperativesRepository cooperativesRepository = CooperativesRepository();

final UserRepository userRepository = UserRepository();

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final List<String> _tabTitles = ['Members', 'Features'];

// Comment out muna for now to remove warnings
  // final List<String> _featuredMember = [
  //   'Bronze',
  //   'Silver',
  //   'Gold',
  //   'Platinum',
  //   'Diamond'
  // ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Members"),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: listViewFilter(),
          ),
          const SizedBox(height: 10),
          searchFilter(context),
          const SizedBox(height: 10),
          FutureBuilder(
            future: cooperativesRepository
                .getCooperativeMembers("sslvO5tgDoCHGBO82kxq"),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error loading data');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                // Return shirnk or no widget
                return const SizedBox.shrink();
              }

              final members = snapshot.data as List<String>;

              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<UserModel>(
                      future: userRepository.getUser(members[index]),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Error loading data');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // return shimmer();
                          return const SizedBox.shrink();
                        }

                        final user = snapshot.data!;

                        // return inkWell(context, user);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 0.0),
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  GoRouter.of(context)
                                      .go('/members_page/${user.uid}');
                                },
                                leading: user.profilePicture == null ||
                                        user.profilePicture!.isEmpty
                                    ? Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade200,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size:
                                              30, // Icon size reduced to look similar to the images
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      )
                                    : DisplayProfilePicture(
                                        storageRef:
                                            FirebaseStorage.instance.ref(),
                                        coopId: user.uid!,
                                        data: user.profilePicture,
                                        height:
                                            60, // Updated to match the default icon size
                                        width:
                                            60, // Updated to match the default icon size
                                      ),
                                title: Text(
                                  '${user.firstName} ${user.lastName}', // Your user's name
                                  style: const TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight
                                          .w500), // Adjust text styling as needed
                                ),
                              ),

                              // Add a divider widget below ListTile
                              const Divider(
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),

          // getMembersGrid(),
        ],
      ),
    );
  }

  // InkWell inkWell(BuildContext context, UserModel user) {
  //   return InkWell(
  //                       onTap: () {
  //                         GoRouter.of(context)
  //                             .go('/members_page/${user.uid}');
  //                       },
  //                       child: Container(
  //                         margin: const EdgeInsets.all(8.0),
  //                         decoration: BoxDecoration(
  //                           color: Theme.of(context).colorScheme.secondary,
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         child: Column(
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.only(top: 24.0),
  //                               child: user.profilePicture == null ||
  //                                       user.profilePicture!.isEmpty
  //                                   ? Container(
  //                                       width: 60,
  //                                       height: 60,
  //                                       decoration: const BoxDecoration(
  //                                           shape: BoxShape.circle,
  //                                           color: Colors.white),
  //                                       child: Icon(Icons.person,
  //                                           size: 50,
  //                                           color: Theme.of(context)
  //                                               .colorScheme
  //                                               .primary),
  //                                     )
  //                                   : DisplayProfilePicture(
  //                                       storageRef:
  //                                           FirebaseStorage.instance.ref(),
  //                                       coopId: user.uid!,
  //                                       data: user.profilePicture,
  //                                       height: 60,
  //                                       width: 60),
  //                             ),
  //                             const SizedBox(height: 15),
  //                             Text(
  //                               '${user.firstName} ${user.lastName}, ${user.uid}',
  //                               style: const TextStyle(
  //                                 fontSize: 19,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  // }

  Shimmer shimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              color: Colors.white,
              height: 8.0,
              width: double.infinity,
            ),
          ],
        ),
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

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                // showAddPostPage(context);
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
