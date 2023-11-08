// import 'package:cooptourism/animations/slide_transition.dart';
// import 'dart:ui';
import 'package:cooptourism/data/models/coaching_form.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/coaching_repository.dart';
// import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
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
    'Performance',
    'About',
    'Posts',
    'Coaching',
  ];

  final List<String> _titlesManager = [
    'Submitted Documents',
    'Arrange Coaching Sessions',
  ];

  final List<String> _titlesCustomer = [];

  User? user;

  final userRepository = UserRepository();
  final coachingRepository = CoachingRepository();

  late UserModel specificUser;

  @override
  void initState() {
    super.initState();
    // postRepository.addDummyPost();
    userUID = widget.profileId.replaceAll(RegExp(r'}+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context, "Profile"),
        backgroundColor: Theme.of(context).colorScheme.background,
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
                    : Theme.of(context).colorScheme.secondary,
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
                  // Perforrmance
                  return Column(
                    children: [
                      profile(context, userData!, profileId),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 40,
                        child: listViewFilter(userData),
                      ),
                      const SizedBox(height: 15),
                      performanceSection(context, userData, profileId)
                    ],
                  );
                } else if (selectedIndex == 1 && userData?.role == 'Member') {
                  // About
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
                      postSection(context, profileId)
                    ],
                  );
                } else if (selectedIndex == 3 && userData?.role == 'Member') {
                  return Column(
                    children: [
                      profile(context, userData!, profileId),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 40,
                        child: listViewFilter(userData),
                      ),
                      const SizedBox(height: 15),
                      coachingSection(context, userData, profileId)
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
                    approvalSection(context, userData, userUID)
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
                      arrangeCoachingSection(context, userData, profileId)
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

  Container profile(BuildContext context, UserModel user, String userUID) {
    Color borderColor = Theme.of(context).colorScheme.secondary;

    debugPrint(user.memberType);

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
        color: Theme.of(context).colorScheme.primary,
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
                    ? DisplayProfilePicture(
                        storageRef: FirebaseStorage.instance.ref(),
                        coopId: userUID,
                        data: user.profilePicture,
                        height: 70,
                        width: 70)
                    : Icon(Icons.person,
                        size: 50,
                        color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('${user.firstName} ${user.lastName}',
                  style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold)),
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
          child: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        ),
        Text(description,
            style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold)),
        Text(userData!.isNotEmpty ? userData : 'Unavailable info.',
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.secondary,
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
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text('Performance',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary)),
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
                  color: Theme.of(context).colorScheme.secondary,
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
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
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
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Text('Goal: '),
                              ),
                              Text('100,000',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))
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
      Center(
        child: Text('About',
            style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold)),
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              '${user.bio!.isNotEmpty ? user.bio : 'No bio added yet.'}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).colorScheme.primary)),
        ),
      ),
      const SizedBox(height: 5),
      Divider(
        thickness: 1.5,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      const SizedBox(height: 15),
      Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Text('My Skills',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
      ),
      if (user.skills!.isEmpty) ...[
        Text('No skills added yet.',
            style: TextStyle(
                fontSize: 17, color: Theme.of(context).colorScheme.primary))
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

  Column coachingSection(BuildContext context, UserModel user, String userUID) {
    final List<String> tips = [
      'Honoring commitments and delivering on promises.',
      'Being transparent and honest in your interactions.',
      'Maintaining open and clear communication.',
      'Resolving conflicts and addressing concerns promptly and professionally.'
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Text('Need help in improving your trust rating?',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
      ),
      const SizedBox(height: 15),
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: RichText(
          text: TextSpan(
              style: TextStyle(
                  fontSize: 18.0, color: Theme.of(context).colorScheme.primary),
              children: const <TextSpan>[
                TextSpan(
                    text: 'Q:', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' What is a trust rating?')
              ]),
        ),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 12.0),
        child: Text(
            "A trust rating is a measure of credibility and reliability that is assigned to individuals or entities based on their past actions, behavior, and reputation.",
            style: TextStyle(
                fontSize: 15, color: Theme.of(context).colorScheme.primary)),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: RichText(
          text: TextSpan(
              style: TextStyle(
                  fontSize: 18.0, color: Theme.of(context).colorScheme.primary),
              children: const <TextSpan>[
                TextSpan(
                    text: 'Q:', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' Why is a trust rating important?')
              ]),
        ),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 12.0),
        child: Text(
            "A trust rating is important because it affects how others perceive and interact with you. It can can influence people's willingness to engage in transactions, collaborations or partnerships with you.",
            style: TextStyle(
                fontSize: 15, color: Theme.of(context).colorScheme.primary)),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: RichText(
          text: TextSpan(
              style: TextStyle(
                  fontSize: 18.0, color: Theme.of(context).colorScheme.primary),
              children: const <TextSpan>[
                TextSpan(
                    text: 'Q:', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' How can I improve my trust rating?')
              ]),
        ),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 12.0),
        child: Text(
            "Improving your trust rating requires consistent effort and positive actions. Some ways to improve your trust rating include:",
            style: TextStyle(
                fontSize: 15, color: Theme.of(context).colorScheme.primary)),
      ),
      const SizedBox(height: 5),
      SizedBox(
        child: ListView.builder(
            itemCount: tips.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Row(
                  children: [
                    Icon(Icons.circle,
                        size: 8, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(tips[index],
                          style: const TextStyle(
                            fontSize: 13,
                          )),
                    )
                  ],
                ),
              );
            })),
      ),
      Center(
        child: Text('Need more assistance?',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
      ),
      const SizedBox(height: 10),
      Center(
        child: Container(
            height: 155,
            width: 250,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 12),
                    child: Text('Apply for coaching!',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final Stream<List<CoachingFormModel>> coachingForms =
                          coachingRepository.getAllCoachingForms();

                      bool hasCoachingForm = false;

                      List<CoachingFormModel> forms = await coachingForms.first;

                      for (var form in forms) {
                        if (form.userUID == userUID &&
                            form.status == 'Pending') {
                          hasCoachingForm = true;
                          break;
                        }
                      }
                      debugPrint("hasCoachingForm: $hasCoachingForm");
                      // show a pop up if user has submitted a coaching form already
                      if (hasCoachingForm) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(
                                    'Coaching Form',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  content: const SingleChildScrollView(
                                      child: ListBody(children: <Widget>[
                                    Text(
                                        'You have already submitted a coaching form. Please wait for the approval of your request.'),
                                  ])),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ]);
                            });
                      } else {
                        // show a pop up if user has not submitted a coaching form yet
                        // ignore: use_build_context_synchronously
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(
                                    'Coaching Form',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  content: const SingleChildScrollView(
                                      child: ListBody(children: <Widget>[
                                    Text(
                                        'Please fill out the form below to apply for coaching.'),
                                  ])),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Apply'),
                                      onPressed: () {
                                        // showAddCoachingFormPage(context);
                                        GoRouter.of(context).go('/profile_page/$userUID/coaching_page');
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ]);
                            });
                      }
                    },
                    child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(24)),
                        child: Center(
                            child: Text('Start',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 16)))),
                  )
                ],
              ),
            )),
      ),
      const SizedBox(height: 70)
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
                  scrollDirection: Axis.vertical,
                  itemBuilder: ((context, index) {
                    final post = posts[index];
                    return PostCard(postModel: post);
                  }));
            }

            if (snapshot.hasError) {
              return const Text("Error");
            } 
            
            else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
      ],
    );
  }

  Column approvalSection(BuildContext context, UserModel user, String userUID) {
    return Column(
      children: [
        // use coachRepository to get coaching forms
        StreamBuilder(
          stream: coachingRepository.getAllCoachingForms(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final coachingForms = snapshot.data!;
              return ListView.separated(
                  itemCount: coachingForms.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: ((context, index) {
                    final coachingForm = coachingForms[index];
                    return InkWell(
                      onTap: () {
                        debugPrint("Tap tap tap!");
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(
                                    'Coaching Form Details',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  content: SingleChildScrollView(
                                      child: ListBody(children: <Widget>[
                                    Text(
                                        'Name: ${coachingForm.firstName} ${coachingForm.lastName}'),
                                    const SizedBox(height: 15),
                                    Text('Concern: ${coachingForm.concern}'),
                                    Text("User's Goal: ${coachingForm.goal}"),
                                    Text('Status: ${coachingForm.status}'),
                                  ])),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Approve'),
                                      onPressed: () {
                                        coachingForm.status = 'Approved';
                                        coachingRepository
                                            .updateCoachingForm(coachingForm);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Decline'),
                                      onPressed: () {
                                        coachingForm.status = 'Declined';
                                        coachingRepository
                                            .updateCoachingForm(coachingForm);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ]);
                            });
                      },
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Column(children: [
                            // display photo and name of user, then display its concern
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
                                      coachingForm.concern == 'Credit Loans'
                                          ? Icons.money
                                          : coachingForm.concern ==
                                                  'Driving Skills'
                                              ? Icons.car_rental
                                              : coachingForm.concern ==
                                                      'Tour Accommodation'
                                                  ? Icons.house
                                                  : Icons.help,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${coachingForm.firstName} ${coachingForm.lastName}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                    Text('${coachingForm.concern}',
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
                                  child: Icon(
                                    coachingForm.status == 'Pending'
                                        ? Icons.pending_actions
                                        : coachingForm.status == 'Approved'
                                            ? Icons.check_circle
                                            : coachingForm.status == 'Declined'
                                                ? Icons.cancel
                                                : Icons.help,
                                    color: coachingForm.status == 'Pending'
                                        ? Theme.of(context).colorScheme.primary
                                        : coachingForm.status == 'Approved'
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : coachingForm.status == 'Declined'
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ])),
                    );
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

  Column arrangeCoachingSection(BuildContext context, UserModel user, String userUID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Arrange the cooperative members here based on their needs!",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
              ),
          ),
        )
      ]
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
              icon: const Icon(Icons.edit, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
