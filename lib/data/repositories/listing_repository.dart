import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:flutter/material.dart';

class ListingRepository {
  final CollectionReference listingsCollection =
      FirebaseFirestore.instance.collection('market');

      // Get all Listings from Firestore
  Stream<List<ListingModel>> getAllListings() {
    return listingsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ListingModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Add a Listing to Firestore
  Future<void> addListing(ListingModel listing) async {
    try {
      await listingsCollection.add(listing.toJson());
    } catch (e) {
      debugPrint('Error adding Listing to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Read a Listing from Firestore
  Future<ListingModel> getSpecificListing(String listingId) async {
    try {
      final doc = await listingsCollection.doc(listingId).get();
      return ListingModel.fromJson(listingId, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting Listing from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Update a Listing in Firestore
  Future<void> updateListing(String listingId, ListingModel listing) async {
    try {
      await listingsCollection.doc(listingId).update(listing.toJson());
    } catch (e) {
      debugPrint('Error updating Listing in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete a Listing from Firestore
  Future<void> deleteListing(String listingId) async {
    try {
      await listingsCollection.doc(listingId).delete();
    } catch (e) {
      debugPrint('Error deleting Listing from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }
}