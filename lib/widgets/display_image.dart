import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({
    super.key,
    required this.path,
    required this.height,
    required this.width,
    required this.radius,
  });

  final String? path;
  final double? height;
  final double? width;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();
    // debugPrint("$path this is the image");
    return ClipRRect(
      borderRadius: radius!,
      child: FutureBuilder<String>(
        future: storageRef
            .child(path!)
            .getDownloadURL(), // Await here
        builder: (context, urlSnapshot) {;
          if (urlSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (urlSnapshot.hasError) {
            debugPrint('Error fetching image URL: ${urlSnapshot.error}');


            return const Icon(Icons.error); // Or some other widget to indicate an error
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