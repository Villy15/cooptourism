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
        const SizedBox(height: 25),
        const Divider(
          color: Color(0xff68707E),
          thickness: 2,
        ),

      ],
    );
  }
}
