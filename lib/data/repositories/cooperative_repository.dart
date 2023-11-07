import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:flutter/material.dart';

class CooperativesRepository {
  final CollectionReference cooperativesCollection =
      FirebaseFirestore.instance.collection('cooperatives');

  // Get cooperative from Firestore
  Future<CooperativesModel> getCooperative(String coopId) async {
    try {
      // debugPrint("$coopId = CoopId");
      final doc = await cooperativesCollection.doc(coopId).get();
      return CooperativesModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting cooperative from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
    // get Cooperative data
  }

  // Get members subcollection of a cooperative from Firestore as Future and get their UIDs
  Future<List<String>> getCooperativeMembers(String coopId) async {
    try {
      final doc = await cooperativesCollection
          .doc(coopId)
          .collection('members')
          .get();
      return doc.docs.map((doc) => doc.id).toList();
    } catch (e) {
      debugPrint('Error getting cooperative members from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }
  

  // Add cooperative
  Future<void> addCooperative(CooperativesModel cooperative) async {
    try {
      await cooperativesCollection.add(cooperative.toJson());
    } catch (e) {
      debugPrint('Error adding cooperative to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Update cooperative
  Future<void> updateCooperative(
      String cooperativeId, CooperativesModel cooperative) async {
    try {
      await cooperativesCollection
          .doc(cooperativeId)
          .update(cooperative.toJson());
    } catch (e) {
      debugPrint('Error updating cooperative in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete cooperative
  Future<void> deleteCooperative(String cooperativeId) async {
    try {
      await cooperativesCollection.doc(cooperativeId).delete();
    } catch (e) {
      debugPrint('Error deleting cooperative from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Get all cooperatives from Firestore
  Stream<List<CooperativesModel>> getAllCooperatives() {
    return cooperativesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CooperativesModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
