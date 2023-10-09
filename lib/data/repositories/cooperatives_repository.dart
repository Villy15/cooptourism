import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:flutter/material.dart';

class CooperativesRepository {
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  // Get all posts from Firestore
  Stream<List<CooperativesModel>> getAllPosts() {
    return postsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CooperativesModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Add a post to Firestore
  Future<void> addPost(CooperativesModel post) async {
    try {
      await postsCollection.add(post.toJson());
    } catch (e) {
      debugPrint('Error adding post to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Read a post from Firestore
  Future<CooperativesModel> getPost(String postId) async {
    try {
      final doc = await postsCollection.doc(postId).get();
      return CooperativesModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting post from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Update a post in Firestore
  Future<void> updatePost(String postId, CooperativesModel post) async {
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
