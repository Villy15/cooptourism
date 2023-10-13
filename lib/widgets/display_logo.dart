import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DisplayLogo extends StatelessWidget {
  const DisplayLogo({
    super.key,
    required this.storageRef,
    required this.coopId,
    required this.data,
  });

  final Reference storageRef;
  final String coopId;
  final String? data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
            height: 90,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}