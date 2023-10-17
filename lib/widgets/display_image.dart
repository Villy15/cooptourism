import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({
    super.key,
    required this.path,
    required this.height,
    required this.width,
  });

  final String path;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();
    // debugPrint("$path this is the image");
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: FutureBuilder<String>(
        future: storageRef
            .child(path)
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