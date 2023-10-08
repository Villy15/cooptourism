import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:flutter/material.dart';

class PostRepository {
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  // Add a post to Firestore
  Future<void> addPost(PostModel post) async {
    try {
      await postsCollection.add(post.toJson());
    } catch (e) {
      debugPrint('Error adding post to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Get all posts from Firestore
  Stream<List<PostModel>> getAllPosts() {
    return postsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
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
}