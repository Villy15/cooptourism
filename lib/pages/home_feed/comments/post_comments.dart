import 'package:cooptourism/data/models/comment.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/data/repositories/comment_repository.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:flutter/material.dart';

class PostCommentsPage extends StatefulWidget {
  final String postId;
  const PostCommentsPage({super.key, required this.postId});

  @override
  State<PostCommentsPage> createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends State<PostCommentsPage> {
  final PostRepository postRepository = PostRepository();
  final CommentRepository commentRepository = CommentRepository();

  @override
  Widget build(BuildContext context) {
    final Future<PostModel> post = postRepository.getPost(widget.postId);
    final Stream<List<CommentModel>> comments =
        commentRepository.getAllPostComments(widget.postId);

    return FutureBuilder<PostModel>(
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
              ListTile(
                title: Text(post.author!),
                subtitle: Text(post.content!),
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
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return ListTile(
                        title: Text(comment.userId!),
                        subtitle: Text(comment.content!),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
