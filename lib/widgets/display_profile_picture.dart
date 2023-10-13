import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DisplayProfilePicture extends StatelessWidget {
  const DisplayProfilePicture({
    super.key,
    required this.storageRef,
    required this.coopId,
    required this.data,
    required this.height,
    required this.width,
  });

  final Reference storageRef;
  final String coopId;
  final String? data;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: FutureBuilder<String>(
        future: storageRef
            .child("$coopId/images/$data")
            .getDownloadURL(), // Await here
        builder: (context, urlSnapshot) {
          if (urlSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (urlSnapshot.hasError) {
            return Text('Error: ${urlSnapshot.error}');
          }

          final imageUrl = urlSnapshot.data;

          return Image.network(
            imageUrl!,
            height: height,
            width: width,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}