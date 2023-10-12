import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final String? author;
  final String? authorId;
  final String? authorType;
  final String? content;
  final List<String>? likes;
  final List<String>? dislikes;
  final List<dynamic>? comments;
  final Timestamp timestamp;
  final List<dynamic>? images;

  const PostCard({
    required Key key,
    this.author,
    this.authorId,
    this.authorType,
    this.content,
    this.likes,
    this.dislikes,
    this.comments,
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
      return '${difference.inHours}h ago';
    } else {
      final formatter = DateFormat.yMd().add_jm();
      return formatter.format(postTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();

    final cooperativeRepository = CooperativesRepository();
    final cooperative = cooperativeRepository.getCooperative(authorId ?? "");
    final userRepository = UserRepository();
    final user = userRepository.getUser(authorId ?? "");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 0,
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: DisplayProfilePicture(
                          storageRef: storageRef,
                          coopId: authorId ?? "",
                          data: cooperative.profilePicture,
                          height: 35.0,
                          width: 35.0,
                        ),
                      );
                    }),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      getTimeDifference(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.more_horiz,
                      color: Theme.of(context).colorScheme.primary, size: 26),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                content!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              child: images != null && images!.isNotEmpty // Check first if images is not null and not empty
                  ? FutureBuilder<String>(
                      future: storageRef
                          .child("$authorId/images/${images?[0]}")
                          .getDownloadURL(),
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
                          height: 225,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.thumb_up_alt_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    likes?.length.toString() ?? '0',
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
                    dislikes?.length.toString() ?? '0',
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
                    comments!.length.toString(),
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
            ),
            // Add a horizontal line
            const Divider(height: 10, thickness: 1),
          ],
        ),
      ),
    );
  }
}
