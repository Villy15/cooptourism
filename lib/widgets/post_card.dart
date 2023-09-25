import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final String author;
  final String content;
  final int likes;
  final int dislikes;
  final List<dynamic> comments;
  final Timestamp timestamp;

  const PostCard({
    required Key key,
    required this.author,
    required this.content,
    required this.likes,
    required this.dislikes,
    required this.comments,
    required this.timestamp,
  }) : super(key: key);

  String getTimeDifference() {
    final now = Timestamp.now().toDate();
    final postTime = timestamp.toDate();
    final difference = now.difference(postTime);

    if (difference.inMinutes < 60) {
      return '| ${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '| ${difference.inHours}h ago'; 
    } else {
      final formatter = DateFormat.yMd().add_jm();
      return  "| ${formatter.format(postTime)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, color: Theme.of(context).colorScheme.primary, size: 40),
                const SizedBox(width: 8),
                Text(
                  author,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  getTimeDifference(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Icon(Icons.more_horiz, color: Theme.of(context).colorScheme.primary, size: 26),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Placeholder(
              fallbackHeight: 200,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.thumb_up_alt_outlined, color: Theme.of(context).colorScheme.primary),
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
                Icon(Icons.thumb_down_alt_outlined, color: Theme.of(context).colorScheme.primary),
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
                Icon(Icons.comment_outlined, color: Theme.of(context).colorScheme.primary),
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
                Icon(Icons.share_outlined, color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}