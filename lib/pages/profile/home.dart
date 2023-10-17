// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/widgets/display_featured.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ProfileHome extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String userUID;
  const ProfileHome({Key? key, required this.userData, required this.userUID}) : super(key: key);

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  final List<String> _recommended = [
    // test for UI purposes only
    'Take Action to improve your trust!',
    'Need help fixing your trust?',
    'Keep your account secure!',
  ];

  final List<String> _recommendedTxt = [
    'Engage with the community to improve your trust score!',
    'Always be respectful and kind to others!',
    'Keep your account secure by changing your password regularly!',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        featuredSection(context, widget.userData, widget.userUID),
        const SizedBox(height: 30),
        recommendedSection(context)
      ],
    );
  }

  Column featuredSection(BuildContext context, Map<String, dynamic> userData, String userID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text('Featured',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 15),
         SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: userData['featured'].length,
              padding: const EdgeInsets.only(left: 15, right: 15),
              separatorBuilder: (context, index) => SizedBox(
                width: 5,
                height: 0.5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                  ),
                )
                ),
              itemBuilder: ((context, index) {
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
                      userID: userID, 
                      data: userData['featured'][index], 
                      height: 150, 
                      width: 200
                    ),
                  )

                );
              }),
            )
          ),
          const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
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
              )
            ),
          ),
          
         
      ],
    );
  }

  Column recommendedSection(BuildContext context) {
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
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Recommended Action:'),
                        content: Text(_recommendedTxt[index]),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _recommended[index],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (index == 0)
                        const Icon(
                          Icons.tag_faces_rounded,
                          color: Colors.white,
                        )
                      else if (index == 1)
                        const Icon(
                          Icons.handshake,
                          color: Colors.white,
                        )
                      else if (index == 2)
                        const Icon(
                          Icons.privacy_tip,
                          color: Colors.white,
                        )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
