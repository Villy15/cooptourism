import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final String author;
  final String? authorId;
  final String? authorType;
  final String content;
  final int likes;
  final int dislikes;
  final List<dynamic> comments;
  final Timestamp timestamp;
  final List<dynamic>? images;

  const PostCard({
    required Key key,
    required this.author,
    this.authorId,
    this.authorType,
    required this.content,
    required this.likes,
    required this.dislikes,
    required this.comments,
    required this.timestamp, 
    this.images,
  }) : super(key: key);

  String getTimeDifference() {
    final now = Timestamp.now().toDate();
    final postTime = timestamp.toDate();
    final difference = now.difference(postTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
<<<<<<< HEAD
      return '${difference.inHours}h ago'; 
    } else {
      final formatter = DateFormat.yMd().add_jm();
      return  formatter.format(postTime);
=======
      return '${difference.inHours}h ago';
    } else {
      final formatter = DateFormat.yMd().add_jm();
      return formatter.format(postTime);
>>>>>>> 073e2a12c593b3d8dc334341e36c0104186fd285
    }
  }

  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();

    final cooperativeRepository = CooperativesRepository();
    final cooperative = cooperativeRepository.getCooperative(authorId ?? "");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FutureBuilder(
                    future: cooperative,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final cooperative = snapshot.data!;
                      return DisplayProfilePicture(
                          storageRef: storageRef,
                          coopId: authorId ?? "",
                          data: cooperative.profilePicture);
                    }),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      getTimeDifference(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.more_horiz,
                    color: Theme.of(context).colorScheme.primary, size: 26),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            ClipRRect(
            child: FutureBuilder<String>(
              future: storageRef
                  .child("$authorId/images/${images?[0]}")
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
          ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.thumb_up_alt_outlined,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  likes.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.thumb_down_alt_outlined,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  dislikes.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Icon(Icons.comment_outlined,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  comments.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Icon(Icons.share_outlined,
                    color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
