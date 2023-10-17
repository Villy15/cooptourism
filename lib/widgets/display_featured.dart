import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DisplayFeatured extends StatelessWidget {
  const DisplayFeatured({
    super.key,
    required this.storageRef,
    required this.userID,
    required this.data,
    required this.height,
    required this.width
    });

    final Reference storageRef;
    final String  userID;
    final String? data;
    final double height;
    final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: FutureBuilder<String>(
        future: storageRef
            .child('$userID/images/$data')
            .getDownloadURL(),
        builder:(context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } 

          if (snapshot.hasError) {
            return const Text('Error');
          }

          final imageUrl = snapshot.data;

          return Image.network(
            imageUrl!,
            height: height,
            width: width,
          );
        },
      )
    );
  }
}