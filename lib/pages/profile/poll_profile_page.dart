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
import 'package:percent_indicator/circular_percent_indicator.dart';

// import 'package:cooptourism/theme/dark_theme.dart';
// import 'package:cooptourism/theme/light_theme.dart';

class PollProfilePage extends StatefulWidget {
  final String profileId;
  const PollProfilePage({Key? key, required this.profileId}) : super(key: key);

  @override
  State<PollProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<PollProfilePage> {
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
        stream: userRepository.getUser(widget.profileId).asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userData = snapshot.data;
            debugPrint('user uid is ${user.uid}');

            if (selectedIndex == 0) {
              return Column(
                children: [
                  profile(context, userData!, uidString),
                  const SizedBox(height: 15),
                ],
              );
            }
            else if (selectedIndex == 1) {
              return Column(
                children: [
                  profile(context, userData!, uidString),
                  const SizedBox(height: 15),
                  aboutSection(context, userData, uidString)
                ],
              );
            }

            else if (selectedIndex == 2) {
              return Column(
                children: [
                  profile(context, userData!, uidString),
                  const SizedBox(height: 15),
                  
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
