import 'package:cooptourism/pages/cooperatives/selected_coop_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DisplayLogo extends StatelessWidget {
  const DisplayLogo({
    super.key,
    required this.storageRef,
    required this.widget,
    required this.data,
  });

  final Reference storageRef;
  final SelectedCoopPage widget;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: FutureBuilder<String>(
        future: storageRef
            .child("${widget.coopId}/images/${data['logo']}")
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
            height: 107,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}