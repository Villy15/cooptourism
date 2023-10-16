import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/comment.dart';
import 'package:flutter/material.dart';

class CommentRepository {
  final CollectionReference reviewsCollection =
      FirebaseFirestore.instance.collection('posts');

  // Get all Reviews from Firestore
  Stream<List<CommentModel>> getAllPostComments(String id) {
    return reviewsCollection
        .doc(id)
        .collection('comments')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CommentModel.fromJson(doc.id, doc.data());
      }).toList();
    });
  }

  // create addComment
  Future<void> addComment(String id, CommentModel comment) async {
    try {
      await reviewsCollection
          .doc(id)
          .collection('comments')
          .add(comment.toJson());
    } catch (e) {
      debugPrint('Error adding comment to Firestore: $e');
    }
  }
}
