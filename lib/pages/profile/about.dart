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
        userSkills(context, widget.userData),
        const Divider(
          color: Color(0xff68707E),
          thickness: 2,
        ),
      ],
    );

   
  }

  Column userSkills(BuildContext context, Map<String, dynamic> userData) {
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
          SizedBox(
            height: 270, // specify a height
            child: GridView.count(
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              children: List.generate(
                userData['skills'].length,
                (index) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: Theme.of(context).colorScheme.primary,
                        ), // add an icon
                      const SizedBox(width: 5), // add some spacing
                      Text(
                        userData['skills'][index],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );
  }


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
