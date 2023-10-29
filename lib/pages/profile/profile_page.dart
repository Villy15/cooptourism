// import 'package:cooptourism/animations/slide_transition.dart';
// import 'dart:ui';

import 'package:cooptourism/data/models/user.dart';
// import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
// import 'package:cooptourism/widgets/display_featured.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
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
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Performance',
    'About',
    'Posts',
    'Coaching',
  ];


  User? user;

  final userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

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
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: listViewFilter(),
              ),

              const SizedBox(height: 15),

              currentUserProfile(user!, _selectedIndex),
              const SizedBox(height: 15),

            ]
          )
        )
      )
  );
}
  ListView listViewFilter() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _titles.length,
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
                  _titles[index],
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

  StreamBuilder<UserModel> currentUserProfile(User user, int selectedIndex) {
    final String uidString = user.uid;
    return StreamBuilder(
        stream: userRepository.getUser(user.uid).asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userData = snapshot.data;
            debugPrint('user uid is ${user.uid}');

            if (selectedIndex == 0) { // Perforrmance
              return Column(
                children: [
                  profile(context, userData!, uidString),
                  const SizedBox(height: 15),
                  performanceSection(context, userData, uidString)
                ],
              );
            }
            else if (selectedIndex == 1) { // About
              return Column(
                children: [
                  profile(context, userData!, uidString),
                  const SizedBox(height: 15),
                  aboutSection(context, userData, uidString)
                ],
              );
            }

            else if (selectedIndex == 2) { // Posts
              return Column(
                children: [
                  profile(context, userData!, uidString),
                  const SizedBox(height: 15),
                  
                ],
              );
            }
            
            else if (selectedIndex == 3) {
              return Column(
                children: [
                  profile(context, userData!, uidString),
                  const SizedBox(height: 15),
                  coachingSection(context, userData, uidString)
                ],
              );
            }
            

            return profile(context, userData!, uidString);
            

          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        });
  }



  Container profile(BuildContext context, UserModel user, String userUID) {
    Color borderColor = Theme.of(context).colorScheme.secondary; 

    debugPrint(user.memberType);

    switch (user.memberType) {
      case 'Bronze' 
        : borderColor = const Color(0xffCD7F32);
        break;
      case 'Gold'
        : borderColor = const Color(0xffFFD700);
        break;

      case 'Silver'
        : borderColor = const Color(0xffC0C0C0);
        break;

      case 'Platinum'
        : borderColor = const Color(0xffA0B2c6);
        break;

      case 'Diamond'
        : borderColor = const Color(0xffB9F2FF);
        break;

      default : Theme.of(context).colorScheme.secondary;
      
    }
    return Container(
      height: 290,
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
                    border: Border.all(
                      color: borderColor,
                      width: 3.5
                    )
                  ),
                  child: user.profilePicture != null && user.profilePicture!.isNotEmpty ? DisplayProfilePicture(
                    storageRef: FirebaseStorage.instance.ref(), 
                    coopId: userUID, 
                    data: user.profilePicture,
                    height: 70, 
                    width:70  
                  ) : Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.secondary),
                  
                ),
              ),

               const SizedBox(height: 7),
               Padding(
                 padding: const EdgeInsets.only(top: 8.0),
                 child: Text(
                  '${user.firstName} ${user.lastName}', 
                  style: TextStyle(
                    fontSize: 22, 
                    color: Theme.of(context).colorScheme.secondary, 
                    fontWeight: FontWeight.bold
                    )
                  ),
               ),
              
              const SizedBox(height: 15),
              rowData(Icons.calendar_month, 'Joined: ', user.dateJoined),
              const SizedBox(height: 5),
              rowData(Icons.cases_outlined, 'Role: ', user.role),
              const SizedBox(height: 5),
              rowData(Icons.location_on_outlined, 'Location: ', user.location),

              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Icon(
                          Icons.message,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ),
                    ),
                  )
                ],
              )
            ],
          )
    );
  }

  Row rowData(IconData icon, String description, String? userData) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 8.0),
                    child: Icon(
                      icon,
                      color: Theme.of(context).colorScheme.secondary
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15, 
                      color: Theme.of(context).colorScheme.secondary, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Text(
                    userData!.isNotEmpty ? userData : 'Unavailable info.',
                    style: TextStyle(
                      fontSize: 15, 
                      color: Theme.of(context).colorScheme.secondary, 
                    )
                  )
                ],
              );
  }

  Column performanceSection(BuildContext context, UserModel user, String userUID) {
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
          child: Text(
            'Performance',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
            )
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
            childAspectRatio: 1
          ),
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
                              Text(
                                profileTiles[index],
                                style: TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary
                                )
                              ),
                              const SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: CircularPercentIndicator(
                                  radius: 40,
                                  lineWidth: 10,
                                  percent: 0.85,
                                  progressColor: Theme.of(context).colorScheme.primary,
                                  center: const Text('85%')
                                ),
                              ),
                              const SizedBox(height: 15),
                              

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                  'Current: '
                                  ),
                                  Text(
                                    tempData[index],
                                    style: TextStyle(
                                      fontSize: 20, 
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary
                                    )
                                  )
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                    child: Text('Goal: '),
                                  ),
                                  Text(
                                    '100,000',
                                    style: TextStyle(
                                      fontSize: 20, 
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary
                                    )
                                  )
                                ],
                              ),
                              
                              
                            ],
                          )
                            
                        ],
                      ),
                    ),
            );
          }
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Current Listings',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
            )
          ),
        ),

        
      ],
    );
  }

  Container profileHeading(BuildContext context, UserModel user, String userUID) {
    return Container(
      height: 180,
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        children: [
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {

              }, 
              child: Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xffD89B3E), width: 3.5),
                  borderRadius: const BorderRadius.all(Radius.circular(100.0))),
              child: InkWell(
                onTap: () {
                  
                },
                child: user.profilePicture != null && user.profilePicture!.isNotEmpty ? DisplayProfilePicture(
                  storageRef: FirebaseStorage.instance.ref(), 
                  coopId: userUID, 
                  data: user.profilePicture,
                  height: 70, 
                  width:70  
                ) : Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.secondary)
              )
              
               
            )),
            ),
      ]),
    );
  }


  Column aboutSection(BuildContext context, UserModel user, String userUID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'About',
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${user.bio!.isNotEmpty ? user.bio : 'No bio added yet.'}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.primary
              )
            ),
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
          child: Text(
            'My Skills',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
            )
          ),
        ),
        
        if(user.skills!.isEmpty) ... [
          Text(
            'No skills added yet.',
            style: TextStyle(
              fontSize: 17, 
              color: Theme.of(context).colorScheme.primary
            )
          )
        ]

        else ... [
          SizedBox(
            height: 210,
            child: GridView.count(
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              childAspectRatio: (CircularProgressIndicator.strokeAlignOutside / 2),
              children: List.generate(
                user.skills!.length, (index) => Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 17,
                        color: Theme.of(context).colorScheme.primary
                      ),
                      const SizedBox(width: 3),
                      Text(
                        user.skills![index],
                        style: const TextStyle(fontSize: 16),
                      )
                    ],
                  )
                )
              )
            )
          )
        ],

        const SizedBox(height: 10),

        Divider(
          thickness: 1.5,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),

        const SizedBox(height: 10)
      ]
    );
  }

  Column coachingSection(BuildContext context, UserModel user, String userUID) {

    final List<String> tips = [
      'Honoring commitments and delivering on promises.',
      'Being transparent and honest in your interactions.',
      'Maintaining open and clear communication.',
      'Resolving conflicts and addressing concerns promptly and professionally.'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(
            'Need help in improving your trust rating?',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
            )
          ),
        ),

        const SizedBox(height: 15),

        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).colorScheme.primary
              ),
              children: const <TextSpan> [
                TextSpan(
                  text: 'Q:',
                  style: TextStyle(
                  fontWeight: FontWeight.bold
                  )
                ),
                TextSpan(
                  text: ' What is a trust rating?'
                )
              ]
            ),
            
          ),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
          child: Text(
            "A trust rating is a measure of credibility and reliability that is assigned to individuals or entities based on their past actions, behavior, and reputation.",
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.primary
            )
          ),
        ),


        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).colorScheme.primary
              ),
              children: const <TextSpan> [
                TextSpan(
                  text: 'Q:',
                  style: TextStyle(
                  fontWeight: FontWeight.bold
                  )
                ),
                TextSpan(
                  text: ' Why is a trust rating important?'
                )
              ]
            ),
          ),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
          child: Text(
            "A trust rating is important because it affects how others perceive and interact with you. It can can influence people's willingness to engage in transactions, collaborations or partnerships with you.",
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.primary
            )
          ),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).colorScheme.primary
              ),
              children: const <TextSpan> [
                TextSpan(
                  text: 'Q:',
                  style: TextStyle(
                  fontWeight: FontWeight.bold
                  )
                ),
                TextSpan(
                  text: ' How can I improve my trust rating?'
                )
              ]
            ),
          ),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 12.0),
          child: Text(
            "Improving your trust rating requires consistent effort and positive actions. Some ways to improve your trust rating include:",
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.primary
            )
          ),
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
                    Icon(
                      Icons.circle, 
                      size: 8, 
                      color: Theme.of(context).colorScheme.primary
                      ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        tips[index],
                        style: const TextStyle(
                          fontSize: 13,
                        )
                      ),
                    )
                  ],
                ),
              );
            })
          ),
        ),


        Center(
          child: Text(
            'Need more assistance?',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
            )
          ),
        ),
        
        const SizedBox(height: 10),
        Center(
          child: Container(
            height: 155,
            width: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:16.0, bottom: 12),
                    child: Text(
                      'Connect with a coach!',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      debugPrint('TEST');
                      context.go('/profile_page/coaching_page');
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(24)
                      ),
                      child: Center(
                        child: Text(
                          'Start',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16
                          )
                        )
                      )
                    ),
                  )
                ],
              ),
            )
          ),
        ),

        const SizedBox(height: 70)
      ]
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title, style: TextStyle(fontSize: 28, color: Theme.of(context).colorScheme.primary)),
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
