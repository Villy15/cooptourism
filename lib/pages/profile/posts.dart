import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/widgets/post_card.dart';
import 'package:flutter/material.dart';

class ProfilePosts extends StatefulWidget {
  final String userUID;
  const ProfilePosts({Key? key, required this.userUID}) : super(key: key);

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('authorId', isEqualTo: widget.userUID)
          .snapshots(),
          
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
      
        final userPosts = snapshot.data!.docs
            .map((doc) => PostModel.fromFirestore(doc))
            // .where((post) => post != null) //
            .cast<PostModel>()
            .toList();
            
        return userPosts.isEmpty
            ? const Center(child: Text("No posts yet"))
            : listViewPosts(userPosts);
      },
    );
  }

  ListView listViewPosts(List<PostModel> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        return PostCard(postModel: post);
      },
    );
  }
}