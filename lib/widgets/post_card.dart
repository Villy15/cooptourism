import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String title;
  final String content;

  const PostCard({required Key key, required this.title, required this.content}) : super(key: key);

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
                  'Name',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '| 1m',
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
            const Placeholder(
              fallbackHeight: 200,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.thumb_up_alt_outlined, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '60',
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
                  '2',
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
                  '5',
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