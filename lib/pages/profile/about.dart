import 'package:flutter/material.dart';

class ProfileAbout extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfileAbout({Key? key, required this.userData}) : super(key: key);

  @override
  State<ProfileAbout> createState() => _ProfileAboutState();
}

class _ProfileAboutState extends State<ProfileAbout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        userDetails(context, widget.userData),
        const SizedBox(height: 25),
        const Divider(
          color: Color(0xff68707E),
          thickness: 2,
        ),
        const SizedBox(height: 15),
        userSkills()
      ],
    );

   
  }

  Column userSkills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              'My Skills',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            height: 150,
            color: Colors.red,
            child: GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 2,
              children: [
                Text('hello')
              ],
            )
          )
        ],
      );
  }


  // q: how do i display a certain amount of skills then scroll to see more?
  // a: use a gridview.count with scrollDirection: Axis.horizontal


  Column userDetails(context,Map<String, dynamic> userData ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(widget.userData['location'] ?? 'Location',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const Text(' | '),
          Text(widget.userData['date_joined'] ?? 'Date Joined')
        ]),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.userData['bio'] ?? 'User Bio',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
              )),
        ),
      ],
    );
  }
}
