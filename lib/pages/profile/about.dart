import 'package:firebase_auth/firebase_auth.dart';
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
      children: [
        Text(widget.userData['bio'] ?? 'User Bio'),
      ],
    );
  }
}
