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
        builder: (context, urlSnapshot) {
          debugPrint('this is storage ref $path');
          if (urlSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (urlSnapshot.hasError) {
            debugPrint('Error fetching image URL: ${urlSnapshot.error}');

            debugPrint('Error anthoyn here: ${urlSnapshot.data}');
            return const Icon(Icons.error); // Or some other widget to indicate an error
          }

          final imageUrl = urlSnapshot.data;
          debugPrint("${urlSnapshot.data} this is the image url");

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