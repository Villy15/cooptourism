import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({
    super.key,
    required this.id,
    required this.data,
    required this.height,
    required this.width,
  });

  final String id;
  final List<dynamic>? data;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: FutureBuilder<String>(
        future: storageRef
            .child("$id/images/$data")
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