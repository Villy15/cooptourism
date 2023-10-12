import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/controller/post_provider.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
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

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String getTimeDifference() {
    final now = Timestamp.now().toDate();
    final postTime = widget.timestamp.toDate();
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

  // bool _liked = false;
  // bool _disliked = false;

  // void _toggleLike() {
  //   setState(() {
  //     _liked = !_liked;
  //     if (_liked) {
  //       _disliked = false;
  //     }
  //   });
  // }

  // void _toggleDislike() {
  //   setState(() {
  //     _disliked = !_disliked;
  //     if (_disliked) {
  //       _liked = false;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();

    final cooperativeRepository = CooperativesRepository();
    final cooperative =
        cooperativeRepository.getCooperative(widget.authorId ?? "");
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
                          coopId: widget.authorId ?? "",
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
                      widget.author!,
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
                widget.content!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              child: widget.images != null &&
                      widget.images!
                          .isNotEmpty // Check first if images is not null and not empty
                  ? FutureBuilder<String>(
                      future: storageRef
                          .child(
                              "${widget.authorId}/images/${widget.images?[0]}")
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
                  LikeDislike(likes: widget.likes, dislikes: widget.dislikes),

                  const Spacer(),
                  Icon(Icons.comment_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    widget.comments!.length.toString(),
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

class LikeDislike extends ConsumerStatefulWidget {
  final List<String>? likes;
  final List<String>? dislikes;

  const LikeDislike({Key? key, this.likes, this.dislikes}) : super(key: key);

  @override
  ConsumerState createState() => LikeDislikeState();
}

class LikeDislikeState extends ConsumerState<LikeDislike> {
  final user = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            widget.likes?.add('${user?.uid}'); // Add us
            ref.read(likesCounter.notifier).increment();
            debugPrint(widget.likes.toString());
          },
          child: Icon(
            Icons.thumb_up_alt_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          ref.watch(likesCounter).toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            widget.dislikes?.add('${user?.uid}'); // Add us
            ref.read(dislikesCounter.notifier).increment();
            debugPrint(widget.likes.toString());
          },
          child: Icon(
            Icons.thumb_down_alt_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          ref.watch(dislikesCounter).toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}