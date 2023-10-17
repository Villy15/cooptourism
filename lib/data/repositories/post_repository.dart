import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:flutter/material.dart';

class PostRepository {
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  // Get all posts from Firestore
  Stream<List<PostModel>> getAllPosts() {
    return postsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<PostModel>> getSpecificPosts(String authorId) {
    return postsCollection.where("authorId", isEqualTo: authorId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Add a post to Firestore
  Future<void> addPost(PostModel post) async {
    try {
      await postsCollection.add(post.toJson());
    } catch (e) {
      debugPrint('Error adding post to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Read a post from Firestore
  Future<PostModel> getPost(String postId) async {
    try {
      final doc = await postsCollection.doc(postId).get();
      debugPrint('Post from Firestore: ${doc.data()}');
      return PostModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting post from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Update a post in Firestore
  Future<void> updatePost(String postId, PostModel post) async {
    try {
      await postsCollection.doc(postId).update(post.toJson());
    } catch (e) {
      debugPrint('Error updating post in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete a post from Firestore
  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
    } catch (e) {
      debugPrint('Error deleting post from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }


  // LIKES AND DISLIKES

  // Add a user in the likes list of a post
  Future<void> likePost(String? postId, String userId) async {
    try {
      await postsCollection.doc(postId).update({
        'likes': FieldValue.arrayUnion([userId])
      });

      debugPrint('Post liked in Firestore');
    } catch (e) {
      debugPrint('Error liking post in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Remove a user from the likes list of a post
  Future<void> unlikePost(String? postId, String userId) async {
    try {
      await postsCollection.doc(postId).update({
        'likes': FieldValue.arrayRemove([userId])
      });

      debugPrint('Post unliked in Firestore');
    } catch (e) {
      debugPrint('Error unliking post in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Add a user in the dislikes list of a post
  Future<void> dislikePost(String? postId, String userId) async {
    try {
      await postsCollection.doc(postId).update({
        'dislikes': FieldValue.arrayUnion([userId])
      });

      debugPrint('Post disliked in Firestore');
    } catch (e) {
      debugPrint('Error disliking post in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Remove a user from the dislikes list of a post
  Future<void> undislikePost(String? postId, String userId) async {
    try {
      await postsCollection.doc(postId).update({
        'dislikes': FieldValue.arrayRemove([userId])
      });

      debugPrint('Post undisliked in Firestore');
    } catch (e) {
      debugPrint('Error undisliking post in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Add dummy post
  Future<void> addDummyPost() async {
    try {
      await postsCollection.add({
        'author:': 'Iwahori Multipurpose Cooperative',
        'authorId': 'sslvO5tgDoCHGBO82kxq',
        'authorType': 'cooperative',
        'comments': [],
        'content': 'A joyful DAY TODAY! #inthezone',
        'likes': [],
        'dislikes': [],
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      debugPrint('Error adding dummy post to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }
}
