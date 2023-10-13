import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/review.dart';
import 'package:flutter/material.dart';

class ReviewRepository {  

  final CollectionReference reviewsCollection = FirebaseFirestore.instance
      .collection('market');

  // Get all Reviews from Firestore
  Stream<List<ReviewModel>> getAllListingReviews(String id) {
    return reviewsCollection.doc(id).collection('reviews').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ReviewModel.fromJson(doc.id, doc.data());
      }).toList();
    });
  }
}
