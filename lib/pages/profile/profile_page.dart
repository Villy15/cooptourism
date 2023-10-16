// import 'package:cooptourism/animations/slide_transition.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/pages/profile/about.dart';
import 'package:cooptourism/pages/profile/coaching.dart';
import 'package:cooptourism/pages/profile/home.dart';
import 'package:cooptourism/pages/profile/posts.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cooptourism/widgets/gnav_home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:cooptourism/theme/dark_theme.dart';
// import 'package:cooptourism/theme/light_theme.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Home',
    'About',
    'Posts',
    'Coaching',
  ];

  User? user;
  late TabController _tabController;

  final userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    _tabController = TabController(
      length: _titles.length,
      initialIndex: _selectedIndex,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: _firestore
              .collection('users')
              .doc(user?.uid) // temporary document ID for the mean time
              .snapshots(),
          builder: (context, snapshot) {
            if (mounted) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
        }
        var userData = snapshot.data?.data() as Map<String, dynamic>;
        var userUID = snapshot.data?.id;
        final List<Widget> tabs = [
          ProfileHome(userData: userData),
          ProfileAbout(userData: userData),
          ProfilePosts(userUID: userUID!),
          const ProfileCoaching(),
        ];
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _profileHeading(
                      context,
                      userData['first_name'] ?? 'First Name',
                      userData['last_name'] ?? 'Last Name',
                      userData['user_trust']?.toString() ?? '0',
                      userData['user_rating']?.toString() ?? '0',
                      userData['profilePicture']?.toString(),
                      userUID
                    ),
                    const SizedBox(height: 15),
                    tabsView(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: tabs,
          ),
        );
      },
    ),
  );
}

  Widget tabsView() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true, // this makes the tab bar scrollable
          indicatorColor: Colors.transparent,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: _titles.map((title) {
            return Tab(
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: _selectedIndex == _titles.indexOf(title)
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(title,
                      style: TextStyle(
                        color: _selectedIndex == _titles.indexOf(title)
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: _selectedIndex == _titles.indexOf(title)
                            ? FontWeight.bold
                            : FontWeight.w400,
                        fontSize: 16,
                      )),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Container _profileHeading(BuildContext context, String firstName,
      String lastName, String userTrust, String userRating, String? profilePicture, String userUID) {
    return Container(
      height: 130,
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        children: [
        Padding(
            padding: const EdgeInsets.only(
                top: 35.0, right: 10.0, bottom: 35.0, left: 10.0),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xffD89B3E), width: 2.0),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0))),
              child: profilePicture != null && profilePicture.isNotEmpty ? DisplayProfilePicture(
                storageRef: FirebaseStorage.instance.ref(), 
                coopId: userUID, 
                data: profilePicture,
                height: 50, 
                width: 50
              ) : Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.secondary)
            )),
        Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              right: 35.0,
            ),
            child: Column(children: [
              Text('$firstName $lastName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 10),
              Container(
                  height: 30,
                  width: 205,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.stars_sharp,
                                  color: Color(0xff68707E), size: 20)),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 1.0, left: 3.0),
                              child: Text(userTrust,
                                  style: const TextStyle(
                                      color: Color(0xff68707E),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500)))
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 1.0, right: 3.0),
                              child: Text(userRating,
                                  style: const TextStyle(
                                      color: Color(0xff68707E),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500))),
                          const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.add_reaction_rounded,
                                  color: Color(0xff68707E), size: 20))
                        ],
                      )
                    ],
                  ))
            ]))
      ]),
    );
  }
}
