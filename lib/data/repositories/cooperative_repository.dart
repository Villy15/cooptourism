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
  Future<List<String>> getCooperativeNames(List<String> coopIds) async {
    List<String> cooperativeNames = [];
    try {
      for (var coopId in coopIds) {
        final querySnapshot = await cooperativesCollection
            .where(FieldPath.documentId, isEqualTo: coopId)
            .get();

        for (var doc in querySnapshot.docs) {
          var data = doc.data()
              as Map<String, dynamic>; // Cast to Map<String, dynamic>

          // Check if 'data' contains the 'name' key
          if (data.containsKey('name')) {
            cooperativeNames
                .add(data['name'].toString()); // Add the name to the list
          }
        }
      }
      return cooperativeNames;
    } catch (e) {
      debugPrint('Error getting cooperative names from Firestore: $e');
      rethrow;
    }
  }

  // Get members subcollection of a cooperative from Firestore as Future and get their UIDs
  Future<List<String>> getCooperativeMembers(String coopId) async {
    try {
      final doc =
          await cooperativesCollection.doc(coopId).collection('members').get();
      return doc.docs.map((doc) => doc.id).toList();
    } catch (e) {
      debugPrint('Error getting cooperative members from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  Future<List<String>> getCooperativeMembersNames(String coopId) async {
    try {
      final doc = await cooperativesCollection
          .doc(coopId)
          .collection('members')
          .get()
          .then((value) => value.docs.map((e) => e.data()));
      return doc.map((doc) => doc.values.toString()).toList();
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
