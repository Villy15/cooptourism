import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cooptourism/controller/post_provider.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final String? uid;
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
    this.uid,
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
                  LikeDislike(uid: widget.uid, likes: widget.likes, dislikes: widget.dislikes),

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
  final String? uid;
  final List<String>? likes;
  final List<String>? dislikes;

  const LikeDislike({Key? key, this.uid, this.likes, this.dislikes}) : super(key: key);

  @override
  ConsumerState createState() => LikeDislikeState();
}

class LikeDislikeState extends ConsumerState<LikeDislike> {
  final user = FirebaseAuth.instance.currentUser;  
  PostRepository postRepository = PostRepository();
  bool isLiked = false;
  bool isDisliked = false;

  // function when pressing like, dislike, or comment
  void onPressLike () {
    // if isLiked 
    if (isLiked) {
      postRepository.unlikePost(widget.uid, user!.uid);

      setState(() {
        isLiked = false; // Update the isLiked variable
      });
    } else {
      postRepository.likePost(widget.uid, user!.uid);

      setState(() {
        isLiked = true; // Update the isLiked variable
      });
    }
  }

  void onPressDislike () {
    // if isLiked 
    if (isDisliked) {
      postRepository.undislikePost(widget.uid, user!.uid);

      setState(() {
        isDisliked = false; // Update the isLiked variable
      });
    } else {
      postRepository.dislikePost(widget.uid, user!.uid);

      setState(() {
        isDisliked = true; // Update the isLiked variable
      });
    }

  }

  @override
  void initState() {
    super.initState();
    // Check if the user has liked the post when the widget is first built
    if (widget.likes != null && user != null) {
      isLiked = widget.likes!.contains(user!.uid);
    }

    if (widget.dislikes != null && user != null) {
      isDisliked = widget.dislikes!.contains(user!.uid);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onPressLike,
          child: Icon(
            Icons.thumb_up_alt_outlined,
            color: isLiked ? Colors.blue : Theme.of(context).colorScheme.primary, // Change the color
          ),
        ),
        const SizedBox(width: 8),
        Text(
          widget.likes?.length.toString() ?? '0',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onPressDislike,
          child: Icon(
            Icons.thumb_down_alt_outlined,
            color: isDisliked ? Colors.red : Theme.of(context).colorScheme.primary, // Change the color
          ),
        ),
        const SizedBox(width: 8),
        Text(
          widget.dislikes?.length.toString() ?? '0',
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