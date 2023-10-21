// import 'package:cooptourism/animations/slide_transition.dart';
// import 'dart:ui';

import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/widgets/display_featured.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cooptourism/widgets/gnav_home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    'Home',
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
            print('user uid is ' + user.uid);

            if (selectedIndex == 0) {
              return Column(
                children: [
                  profileHeading(context, userData!, uidString),
                  const SizedBox(height: 30),
                  homeSection(context, userData, uidString),
                ],
              );
            }
            else if (selectedIndex == 1) {
              return Column(
                children: [
                  profileHeading(context, userData!, uidString),
                  const SizedBox(height: 30),
                  aboutSection(context, userData, uidString)
                ],
              );
            }

            else if (selectedIndex == 2) {
              return Column(
                children: [
                  profileHeading(context, userData!, uidString),
                  const SizedBox(height: 30)
                ],
              );
            }
            

            return profileHeading(context, userData!, uidString);
            

          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        });
  }



  Container profileHeading(BuildContext context, UserModel user, String userUID) {
    return Container(
      height: 130,
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        children: [
        Padding(
            padding: const EdgeInsets.only(
                top: 35.0, right: 10.0, bottom: 35.0, left: 10.0),
            child: InkWell(
              onTap: () {

              }, 
              child: Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xffD89B3E), width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(100.0))),
              child: InkWell(
                onTap: () {
                  
                },
                child: user.profilePicture != null && user.profilePicture!.isNotEmpty ? DisplayProfilePicture(
                  storageRef: FirebaseStorage.instance.ref(), 
                  coopId: userUID, 
                  data: user.profilePicture,
                  height: 50, 
                  width: 50 
                ) : Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.secondary)
              )
              
               
            )),
            ),
            
        Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              right: 35.0,
            ),
            child: Column(children: [
              Text('${user.firstName} ${user.lastName}' ,
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
                              child: Text('${user.userTrust}',
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500)))
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 1.0, right: 3.0),
                              child: Text('${user.userRating}',
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
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

  Column homeSection(BuildContext context, UserModel user, String userUID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Featured',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
            )
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: user.featuredImgs!.length,
            padding: const EdgeInsets.only(
              left: 15, 
              right: 15
            ),
            separatorBuilder: (context, index) => SizedBox(
              width: 5,
              height: 0.5,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                ),
              )
            ),
            itemBuilder:(((context, index) {
              return InkWell(
                  onTap: () {

                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary, 
                        width: 2
                      )
                    ),
                    child: DisplayFeatured(
                      storageRef: FirebaseStorage.instance.ref(), 
                      userID: userUID, 
                      data: user.featuredImgs?[index], 
                      height: 150, 
                      width: 200
                    ),
                  )

                );
              })
            ) 
          )
        ),

        const SizedBox(height: 15),

        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'My Services',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
            )
          ),
        ),

        const SizedBox(height: 15),

        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'My Listings',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
            )
          ),
        ),

      ]
    );
  }

  Column aboutSection(BuildContext context, UserModel user, String userUID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.location ?? 'No location added yet.', 
              style: TextStyle(
                fontSize: 20, 
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600
              )
            ),
            const Text(' | '),
            Text('Joined ${user.dateJoined!.isNotEmpty ? user.dateJoined : 'No date added yet.'}', 
              style: TextStyle(
                fontSize: 20, 
                color: Theme.of(context).colorScheme.primary,
              )
            ),
            
          ],
        ),
        const SizedBox(height: 5),
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
        const SizedBox(height: 10),
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
            height: 190,
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
