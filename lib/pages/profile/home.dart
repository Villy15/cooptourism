// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ProfileHome extends StatefulWidget {
  final Map<String, dynamic> userData;
  const ProfileHome({Key? key, required this.userData}) : super(key: key);

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

  // _firestore is used to cover the recommended section
  // q: should i use query for StreamBuilder to get the article's title?
  // a: yes, you should use query for StreamBuilder to get the article's title
  // q: Can you help me code it?
  // a: Sure, I'll help you code it.
  // q: is it like this? StreamBuilder<QueryDocumentSnapshot>()?
  // a: yes, it's like that.
  // q: What do i put in the parenthesis?
  // a: You should put the query in the parenthesis.
  // q: What is the  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        featuredSection(context, widget.userData),
        const SizedBox(height: 30),
        recommendedSection()
      ],
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
                // q: What is the best course of action for me to make this container touch responsive? Like it shows a page when I tap on it to show more info.
                // a: Wrap the container in a GestureDetector and use the onTap property to navigate to a new page.
                // q: Is it better to make a new page or a new widget?
                // a: It depends on the complexity of the page. If it's a simple page, then a widget is fine. If it's a complex page, then a new page is better.
                // q: what kind of widget should i use to display the recommended section?
                // a: use a ListView.separated with scrollDirection: Axis.horizontal

                // q: Can you help me code it?
                // a: Sure, I'll help you code it.

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
}
