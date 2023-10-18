import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:cooptourism/data/models/comment.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/data/repositories/comment_repository.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:cooptourism/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCommentsPage extends ConsumerStatefulWidget {
  final String postId;
  const PostCommentsPage({super.key, required this.postId});

  @override
  ConsumerState<PostCommentsPage> createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends ConsumerState<PostCommentsPage> {
  final PostRepository postRepository = PostRepository();
  final CommentRepository commentRepository = CommentRepository();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = false;
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  }

  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Future<PostModel> post = postRepository.getPost(widget.postId);
    final Stream<List<CommentModel>> comments =
        commentRepository.getAllPostComments(widget.postId);
    return WillPopScope(
      onWillPop: () async {
        ref.read(navBarVisibilityProvider.notifier).state = true;
        ref.read(appBarVisibilityProvider.notifier).state = true;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Comments"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              ref.read(navBarVisibilityProvider.notifier).state = true;
              ref.read(appBarVisibilityProvider.notifier).state = true;
              Navigator.of(context).pop(); // to go back
            },
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
        body: FutureBuilder<PostModel>(
          future: post,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final post = snapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  PostCard(
                    postModel: post
                  ),
                  StreamBuilder<List<CommentModel>>(
                    stream: comments,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final comments = snapshot.data!;
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        separatorBuilder: (context, index) =>
                            Divider(color: Colors.grey[300]),
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.userId!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(comment.content!, style: const TextStyle(fontSize: 16)),
                                      const Row(
                                        children: [
                                          // Icon(Icons.thumb_up, size: 16, color: Colors.grey[600]),
                                          // Text(" Like", style: TextStyle(color: Colors.grey[600])),
                                          // const SizedBox(width: 8),
                                          // Icon(Icons.message, size: 16, color: Colors.grey[600]),
                                          // Text(" Reply", style: TextStyle(color: Colors.grey[600])),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final user = ref.watch(userModelProvider);

    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Add a comment...',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                if (_commentController.text.isNotEmpty) {
                  commentRepository.addComment(
                    widget.postId,
                    CommentModel(
                      content: _commentController.text,
                      userId: "${user?.firstName} ${user?.lastName}",
                      timestamp: DateTime.now(),
                    ),
                  );
                  _commentController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}