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

  // @override
  // Widget build(BuildContext context) {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(50.0),
  //     // Add background color
      
  //     child: FutureBuilder<String>(
  //       future: storageRef
  //           .child("$coopId/images/$data")
  //           .getDownloadURL(), // Await here
  //       builder: (context, urlSnapshot) {
  //         if (urlSnapshot.connectionState ==
  //             ConnectionState.waiting) {
  //           return const CircularProgressIndicator();
  //         }

  //         if (urlSnapshot.hasError) {
  //           return Text('Error: ${urlSnapshot.error}');
  //         }

  //         final imageUrl = urlSnapshot.data;


  //         return Image.network(
  //           // Add background color of white
  //           imageUrl!,
  //           height: height,
  //           width: width,
  //           fit: BoxFit.cover,
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // Set your background color here
      ),
      child: ClipOval( // Using ClipOval to ensure a circular shape
        child: FutureBuilder<String>(
          future: storageRef.child("$coopId/images/$data").getDownloadURL(),
          builder: (context, urlSnapshot) {
            if (urlSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (urlSnapshot.hasError) {
              return const Icon(Icons.error, color: Colors.red); // Display an error icon in case of error
            }

            final imageUrl = urlSnapshot.data;
            return imageUrl != null
              ? Image.network(
                  imageUrl,
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.broken_image); // Display an icon when the image URL is null
          },
        ),
      ),
    );
  }
}