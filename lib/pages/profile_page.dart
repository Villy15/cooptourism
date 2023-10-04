// import 'package:cooptourism/animations/slide_transition.dart';
import 'package:cooptourism/pages/profile/about.dart';
import 'package:cooptourism/pages/profile/coaching.dart';
import 'package:cooptourism/pages/profile/comments.dart';
import 'package:cooptourism/pages/profile/help.dart';
import 'package:cooptourism/pages/profile/home.dart';
import 'package:cooptourism/pages/profile/posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Home',
    'About',
    'Posts',
    'Comments',
    'Coaching',
    'Help'
  ];

  final List<Widget> _tabs = const [
    ProfileHome(),
    ProfileAbout(),
    ProfilePosts(),
    ProfileComments(),
    ProfileCoaching(),
    ProfileHelp(),
  ];

  final List<String> _recommended = [
    // test for UI purposes only
    'Take Action to improve your trust!',
    'Need help fixing your trust?',
    'Keep your account secure!',
  ];
  User? user;
  late TabController _tabController;

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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _profileHeading(
                    context,
                    userData['first_name'] ?? 'First Name',
                    userData['last_name'] ?? 'Last Name',
                    userData['user_trust']?.toString() ?? '0',
                    userData['user_rating']?.toString() ?? '0'),
            
                const SizedBox(height: 15),
                tabsView(),

                // THIS CAUSES THE ERROR
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _tabs,
                  )
                  ),
                const SizedBox(height: 30),
                // TEMPORARY FOR HOME PAGE
                featuredSection(context, userData),
            
                const SizedBox(height: 30),
            
                recommendedSection(),

                const SizedBox(height: 100),
              ],
            );
          }),
    );
  }

  Column featuredSection(BuildContext context, Map<String, dynamic> userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text('Featured',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Container(
              height: 80,
              width: 350,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  const Column(
                    children: [Icon(Icons.star_rounded, color: Colors.white)],
                  ),
                  Text(userData['status'] ?? 'Status',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary)),
                  Text(userData['user_accomplishment'] ?? 'Accomplishment',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary))
                ],
              )),
        )
      ],
    );
  }

  Column recommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text('Recommended for you',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 15),
        SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _recommended.length,
              padding: const EdgeInsets.only(left: 15, right: 15),
              separatorBuilder: ((context, index) => const SizedBox(width: 15)),
              itemBuilder: (context, index) {
                return Container(
                    width: 120,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_recommended[index],
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)),
                        ),
                        if (index == 0)
                          const Icon(Icons.tag_faces_rounded,
                              color: Colors.white)
                        else if (index == 1)
                          const Icon(Icons.handshake, color: Colors.white)
                        else if (index == 2)
                          const Icon(Icons.privacy_tip, color: Colors.white)
                      ],
                    ));
              },
            )),
      ],
    );
  }

  Widget tabsView() {
    return TabBar(
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
    );
  }

  SizedBox _titleHeadings() {
    return SizedBox(
        height: 40,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _titles.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                      onTap: () => setState(() {
                            _selectedIndex = index;
                          }),
                      child: Container(
                          decoration: BoxDecoration(
                              color: _selectedIndex == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28.0, vertical: 10.0),
                              child: Text(_titles[index],
                                  style: TextStyle(
                                    color: _selectedIndex == index
                                        ? Theme.of(context)
                                            .colorScheme
                                            .background
                                        : Theme.of(context).colorScheme.primary,
                                    fontWeight: _selectedIndex == index
                                        ? FontWeight.bold
                                        : FontWeight.w400,
                                    fontSize: 16,
                                  ))))));
            }));
  }

  Container _profileHeading(BuildContext context, String firstName,
      String lastName, String userTrust, String userRating) {
    return Container(
      height: 130,
      color: Theme.of(context).colorScheme.primary,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Padding(
            padding: const EdgeInsets.only(
                top: 35.0, right: 10.0, bottom: 35.0, left: 10.0),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xffD89B3E), width: 2.0),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0))),
              child: const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Icon(Icons.person_2_rounded))),
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
