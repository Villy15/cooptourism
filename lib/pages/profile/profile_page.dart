// import 'package:cooptourism/animations/slide_transition.dart';
// import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/coop_application.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/coopjoin_repository.dart';
// import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/widgets/display_image.dart';
// import 'package:cooptourism/providers/user_provider.dart';
// import 'package:cooptourism/widgets/display_featured.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:cooptourism/widgets/post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cooptourism/widgets/gnav_home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// import 'package:cooptourism/theme/dark_theme.dart';
// import 'package:cooptourism/theme/light_theme.dart';

class ProfilePage extends StatefulWidget {
  final String profileId;
  const ProfilePage({super.key, required this.profileId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;
  String userUID = "";

  final List<String> _titlesMember = [
    'About',
    'Posts',
  ];

  final List<String> _titlesManager = ['Application Forms', 'About', 'Posts'];

  final List<String> _titlesCustomer = [
    // temporary for now
    'Enroll Cooperative',
    'Register as a Member'
  ];

  // final List<String> _coachingFocus = [
  //   'Tour Accommodation',
  //   'Driving Skills',
  //   'Tour Guide',
  //   'Credit Loans',
  // ];

  // final List<String> _titlesCoach = [
  //   'Performance Review',
  //   'About',
  //   'Posts',
  //   'Coaching Sessions'
  // ];

  // final List<String> _titlesNoCooperativeRole = [
  //   'Get Started',
  // ];

  User? user;

  final userRepository = UserRepository();
  final cooperativeRepository = CooperativesRepository();
  final joinCooperativeRepository = JoinCooperativeRepository();

  @override
  void initState() {
    super.initState();
    // postRepository.addDummyPost();
    userUID = widget.profileId.replaceAll(RegExp(r'}+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context, "Profiles"),
        body: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: SingleChildScrollView(
                child: currentUserProfile(userUID, _selectedIndex))));
  }

  ListView listViewFilter(UserModel user) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      // add other title members here,
      itemCount: user.role == 'Member'
          ? _titlesMember.length
          : user.role == 'Manager'
              ? _titlesManager.length
              : user.role == 'Customer'
                  ? _titlesCustomer.length
                  : _titlesCustomer.length,
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
                  user.role == 'Member'
                      ? _titlesMember[index]
                      : user.role == 'Manager'
                          ? _titlesManager[index]
                          : user.role == 'Customer'
                              ? _titlesCustomer[index]
                              : _titlesCustomer[index],
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

  Column currentUserProfile(String profileId, int selectedIndex) {
    return Column(
      children: [
        StreamBuilder(
            stream: userRepository.getUser(profileId).asStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var userData = snapshot.data;
                // USER ROLE: MEMBER
                if (selectedIndex == 0 && userData?.role == 'Member') {
                  // ABOUT
                  return Column(
                    children: [
                      profile(context, userData!, profileId),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 40,
                        child: listViewFilter(userData),
                      ),
                      const SizedBox(height: 15),
                      aboutSection(context, userData, profileId)
                    ],
                  );
                } else if (selectedIndex == 1 && userData?.role == 'Member') {
                  // POSTS
                  return Column(
                    children: [
                      profile(context, userData!, profileId),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 40,
                        child: listViewFilter(userData),
                      ),
                      const SizedBox(height: 15),
                      postSection(context, profileId)
                      
                    ],
                  );
                } else if (selectedIndex == 2 && userData?.role == 'Member') {
                  // Posts
                  return Column(
                    children: [
                      profile(context, userData!, profileId),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 40,
                        child: listViewFilter(userData),
                      ),
                      const SizedBox(height: 15),
                      
                    ],
                  );
                } 
                // USER ROLE: MANAGER
                else if (selectedIndex == 0 && userData?.role == 'Manager') {
                  return Column(children: [
                    profile(context, userData!, profileId),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 40,
                      child: listViewFilter(userData),
                    ),
                    const SizedBox(height: 15),
                    appFormSection(context, userData, profileId)
                  ]);
                } else if (selectedIndex == 1 && userData?.role == 'Manager') {
                  return Column(
                    children: [
                      profile(context, userData!, profileId),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 40,
                        child: listViewFilter(userData),
                      ),
                      const SizedBox(height: 15),
                      aboutSection(context, userData, profileId)
                    ],
                  );
                } else if (selectedIndex == 2 && userData?.role == 'Manager') {
                  return Column(
                    children: [
                      profile(context, userData!, profileId),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 40,
                        child: listViewFilter(userData),
                      ),
                      const SizedBox(height: 15),
                    ],
                  );
                } else if (selectedIndex == 0 && userData?.role == 'Customer') {
                  return Column(
                    children: [
                      profile(context, userData!, profileId),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 40,
                        child: listViewFilter(userData),
                      ),
                      const SizedBox(height: 15),
                      enrollCoop(context, userData, profileId)
                    ],
                  );
                } else if (selectedIndex == 1 && userData?.role == 'Customer') {
                  return Column(
                    children: [
                      profile(context, userData!, profileId),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 40,
                        child: listViewFilter(userData),
                      ),
                      const SizedBox(height: 15),
                      registerAsMemberSection(context, userData, profileId)
                    ],
                  );
                }

                return profile(context, userData!, profileId);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ],
    );
  }

  Column enrollCoop(BuildContext context, UserModel user, String userUID) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text('Do you wish to enroll your cooperative?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          )),
      const SizedBox(height: 7),
      Text('Manage your cooperative with ease through the app!',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.3,
          )),

      const SizedBox(height: 15),

      Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 8.0),
        child: RichText(
          text: TextSpan(
              style: TextStyle(
                  fontSize: 17.0, color: Theme.of(context).colorScheme.primary),
              children: const <TextSpan>[
                TextSpan(
                    text: 'Q:', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        ' How will this be of help in my cooperative and our current operations?')
              ]),
        ),
      ),

      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 12.0),
        child: Text(
            "The app will help you manage your cooperative operations by providing you with a platform to post your listings, manage your members, and communicate with your members.",
            style: TextStyle(
                fontSize: 15, color: Theme.of(context).colorScheme.primary)),
      ),

      const SizedBox(height: 15),

      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: RichText(
          text: TextSpan(
              style: TextStyle(
                  fontSize: 17.0, color: Theme.of(context).colorScheme.primary),
              children: const <TextSpan>[
                TextSpan(
                    text: 'Q:', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        ' How do I then enroll my cooperative in the application?')
              ]),
        ),
      ),

      const SizedBox(height: 10),

      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 12.0),
        child: Text(
            "First, you will need to create a profile for yourself. Once you have created your profile, you will be able to enroll your cooperative. To complete your profile, press the 'Edit Profile' button and fill out the form.",
            style: TextStyle(
                fontSize: 15, color: Theme.of(context).colorScheme.primary)),
      ),

      const SizedBox(height: 35),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 12.0),
        child: Text(
            "To enroll your cooperative, click the 'Enroll Now' button below and fill out the form. Once you have submitted the form, you are given access to the features of the app that will help you manage your cooperative operations.",
            style: TextStyle(
                fontSize: 15, color: Theme.of(context).colorScheme.primary)),
      ),

      const SizedBox(height: 25),
      // add a container that acts as a clickable button to direct the user in the enrollment page

      StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.profileId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> userData =
                  snapshot.data!.data() as Map<String, dynamic>;
              String firstName = userData['first_name'];
              bool canNavigate = firstName != 'Customer';

              return InkWell(
                onTap: canNavigate
                    ? () {
                        GoRouter.of(context)
                            .go('/profile_page/$userUID/enroll_cooperative');
                      }
                    : () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text('Edit Profile Required.',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold)),
                                  content: Text(
                                      'Please give your personal details first before enrolling your cooperative.',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                  actions: <Widget>[
                                    TextButton(
                                        child: Text('OK',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                  ]);
                            });
                      },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text('Enroll Now!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),

      const SizedBox(height: 85)
    ]);
  }

  Column registerAsMemberSection(
      BuildContext context, UserModel user, String userUID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Do you wish to become a cooperative member?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 7),
        Text('Be sure to submit the documents needed prior to joining!',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 15,
            )),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: RichText(
            text: TextSpan(
                style: TextStyle(
                    fontSize: 17.0,
                    color: Theme.of(context).colorScheme.primary),
                children: const <TextSpan>[
                  TextSpan(
                      text: 'Q:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          ' How do I join as a cooperative member of a cooperative?')
                ]),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
          child: Text(
              "Press the 'Coops' icon on the bottom navigation bar. You will be directed to the list of cooperatives that are currently enrolled in the application. Select the cooperative you wish to join and press the 'Join' button.",
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).colorScheme.primary)),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: RichText(
            text: TextSpan(
                style: TextStyle(
                    fontSize: 17.0,
                    color: Theme.of(context).colorScheme.primary),
                children: const <TextSpan>[
                  TextSpan(
                      text: 'Q:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          ' What are the documents needed before joining a cooperative?')
                ]),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
          child: Text(
              "It will vary depending on the cooperative you wish to join. Please contact the cooperative you wish to join for more information.",
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).colorScheme.primary)),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
          child: Text(
              "Do note that you are not restricted to joining only one cooperative. You can join as many cooperatives as you wish. Also, prior to joining, we wish that you would complete your profile first. This will help the cooperative you wish to join to know more about you.",
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).colorScheme.primary)),
        ),
        const SizedBox(height: 65),
      ],
    );
  }

  Container profile(BuildContext context, UserModel user, String userUID) {
    Color borderColor = Theme.of(context).colorScheme.secondary;

    debugPrint("${widget.profileId} werhwerhweoh");

    switch (user.memberType) {
      case 'Bronze':
        borderColor = const Color(0xffCD7F32);
        break;
      case 'Gold':
        borderColor = const Color(0xffFFD700);
        break;

      case 'Silver':
        borderColor = const Color(0xffC0C0C0);
        break;

      case 'Platinum':
        borderColor = const Color(0xffA0B2c6);
        break;

      case 'Diamond':
        borderColor = const Color(0xffB9F2FF);
        break;

      default:
        Theme.of(context).colorScheme.secondary;
    }
    return Container(
        height: 250,
        width: 400,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: borderColor, width: 3.5)),
                child: user.profilePicture != null &&
                        user.profilePicture!.isNotEmpty
                    ? DisplayImage(
                        path: '$userUID/images/${user.profilePicture}',
                        height: 70,
                        width: 70,
                        radius: BorderRadius.circular(60))
                    : Icon(Icons.person,
                        size: 50,
                        color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            rowData(Icons.calendar_month, 'Joined: ', user.dateJoined),
            const SizedBox(height: 5),
            rowData(Icons.cases_outlined, 'Role: ', user.role),
            const SizedBox(height: 5),
            rowData(Icons.location_on_outlined, 'Location: ', user.location),
          ],
        ));
  }

  Row rowData(IconData icon, String description, String? userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 8.0),
          child: Icon(
            icon,
          ),
        ),
        Text(description,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        Text(userData!.isNotEmpty ? userData : 'Unavailable info.',
            style: const TextStyle(
              fontSize: 15,
            ))
      ],
    );
  }

  Column performanceSection(
      BuildContext context, UserModel user, String userUID) {
    final List<String> profileTiles = [
      'Monthly Sales',
      'Annual Profit',
      'Total Sales',
      'Trust Rating'
    ];
    final List<String> tempData = [
      user.monthlySales!,
      user.annualProfit!,
      user.totalSales!,
      user.userRating!
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            'Performance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        GridView.builder(
            shrinkWrap: true,
            itemCount: profileTiles.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 300,
                childAspectRatio: 1),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primary, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(profileTiles[index],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CircularPercentIndicator(
                                radius: 40,
                                lineWidth: 10,
                                percent: 0.85,
                                progressColor:
                                    Theme.of(context).colorScheme.primary,
                                center: const Text('85%')),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Current: '),
                              Text(tempData[index],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Text('Goal: '),
                              ),
                              Text('100,000',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text('Current Listings',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary)),
        ),
      ],
    );
  }

  Container profileHeading(
      BuildContext context, UserModel user, String userUID) {
    return Container(
      height: 180,
      color: Theme.of(context).colorScheme.primary,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
              onTap: () {},
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xffD89B3E), width: 3.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100.0))),
                  child: InkWell(
                      onTap: () {},
                      child: user.profilePicture != null &&
                              user.profilePicture!.isNotEmpty
                          ? DisplayProfilePicture(
                              storageRef: FirebaseStorage.instance.ref(),
                              coopId: userUID,
                              data: user.profilePicture,
                              height: 70,
                              width: 70)
                          : Icon(Icons.person,
                              size: 50,
                              color:
                                  Theme.of(context).colorScheme.secondary)))),
        ),
      ]),
    );
  }

  Column aboutSection(BuildContext context, UserModel user, String userUID) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Center(
        child: Text('About',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text('${user.bio!.isNotEmpty ? user.bio : 'No bio added yet.'}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                  )),
        ),
      ),
      const SizedBox(height: 5),
      Divider(
        thickness: 1.5,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      const SizedBox(height: 15),
      const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Text('My Skills',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
      if (user.skills!.isEmpty) ...[
        const Text('No skills added yet.',
            style: TextStyle(
              fontSize: 17,
            ))
      ] else ...[
        SizedBox(
            height: 210,
            child: GridView.count(
                crossAxisCount: 2,
                scrollDirection: Axis.horizontal,
                childAspectRatio:
                    (CircularProgressIndicator.strokeAlignOutside / 2),
                children: List.generate(
                    user.skills!.length,
                    (index) => Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Icon(Icons.circle,
                                size: 17,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 3),
                            Text(
                              user.skills![index],
                              style: const TextStyle(fontSize: 16),
                            )
                          ],
                        )))))
      ],
      const SizedBox(height: 10),
      Divider(
        thickness: 1.5,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      const SizedBox(height: 100)
    ]);
  }


  Column postSection(BuildContext context, String userUID) {
    return Column(
      children: [
        StreamBuilder(
          stream: postRepository.getSpecificPosts(userUID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final posts = snapshot.data!;
              return ListView.builder(
                  itemCount: posts.length,
                  shrinkWrap: true,
                  physics:const  NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: ((context, index) {
                    final post = posts[index];
                    return PostCard(postModel: post);
                  }));
            }

            if (snapshot.hasError) {
              return const Text("Error");
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
      ],
    );
  }

  Column appFormSection(BuildContext context, UserModel user, String userUID) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          'Pending Forms',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
      ),
      const SizedBox(height: 15),
      pendingAppForms()
    ]);
  }

  FutureBuilder<String?> pendingAppForms() {
  return FutureBuilder<String?>(
    future: cooperativeRepository.isCooperativeManager(userUID),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.data != null) {
          String coopId = snapshot.data!;
          return StreamBuilder<List<CooperativeAppFormModel>>(
            stream: joinCooperativeRepository.getAllPendingCoopApplicationsByCoopId(coopId),
            builder: (context, snapshot) {
              final coopApplications = snapshot.data!;
              if (coopApplications.isEmpty) {
                return Column(
                  children: [
                    Center(
                        child: Text(
                      'No pending forms at the moment.',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary),
                    )),
                    const SizedBox(height: 15),
                  ],
                );
              }

              
              coopApplications.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
              return ListView.separated(
                  itemCount: coopApplications.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: ((context, index) {
                    final coopApplication = coopApplications[index];
                    return InkWell(
                      onTap: () {
                        GoRouter.of(context).go(
                            '/profile_page/${widget.profileId}/verify_form/${coopApplication.uid}');
                      },
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Column(children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 2)),
                                    child: Icon(
                                      Icons.file_copy_outlined,
                                      color: Theme.of(context).colorScheme.primary,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${coopApplication.firstName} ${coopApplication.lastName}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                    Text('${coopApplication.coopName}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary))
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Icon(Icons.pending_actions,
                                      size: 24,
                                      color: Theme.of(context).colorScheme.primary),
                                ),
                              ],
                            ),
                          ])),
                    );
                  }));
                },
              );
        } else {
          return 
              Text(
                'There are no pending application forms at the moment.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16
                )
          );
        }
      } else {
        return const CircularProgressIndicator();
      }
    },
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
          child: StreamBuilder<UserModel>(
            stream: userRepository.getUser(userUID).asStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserModel user = snapshot.data!;
                return CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      if (user.emailStatus == 'Not Verified') {
                        GoRouter.of(context)
                            .go('/profile_page/$userUID/email_verification');
                      } else {
                        GoRouter.of(context)
                            .go('/profile_page/$userUID/edit_profile');
                      }
                    },
                    icon: const Icon(Icons.edit),
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ],
    );
  }
}
