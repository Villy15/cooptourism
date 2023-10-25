import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/models/message.dart';
import 'package:flutter/material.dart';

class ListingRepository {
  final CollectionReference listingsCollection =
      FirebaseFirestore.instance.collection('market');

  // Get all Listings from Firestore
  Stream<List<ListingModel>> getAllListings() {
    return listingsCollection
        .orderBy('postDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ListingModel.fromJson(
            doc.id, doc.data() as Map<String, dynamic>);
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
      return ListingModel.fromJson(
          listingId, doc.data() as Map<String, dynamic>);
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

  Stream<List<MessageModel>> getAllMessages(
      String listingId, String senderId, String receiverId) {
    return listingsCollection
        .doc(listingId)
        .collection('messages')
        .where(Filter.or(Filter('senderId', isEqualTo: senderId),
            Filter('senderId', isEqualTo: receiverId)))
        .where(Filter.or(Filter('receiverId', isEqualTo: senderId),
            Filter('receiverId', isEqualTo: receiverId)))
        .orderBy('timeStamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Add a Message to Firestore
  Future<void> addMessage(MessageModel message, String listingId) async {
    try {
      await listingsCollection
          .doc(listingId)
          .collection('messages')
          .add(message.toMap());
    } catch (e) {
      debugPrint('Error adding Listing to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

// Add manually
  Future<void> addMessageManually() async {
    List<Map<String, dynamic>> events = [
      {
        'senderId': 'G5nugbNv6hh1fcbuLc1Uwf785ls1',
        'receiverId': 'sslvO5tgDoCHGBO82kxq',
        'content': 'also is there any particular of pet not allowed?',
        'timeStamp': DateTime.now(),
      },
      {
        'senderId': 'sslvO5tgDoCHGBO82kxq',
        'receiverId': 'G5nugbNv6hh1fcbuLc1Uwf785ls1',
        'content':
            'We have a few openings during the holidays. Small dogs and cats are allowed.',
        'timeStamp': DateTime.now(),
      },
    ];

    for (var event in events) {
      try {
        await listingsCollection
            .doc('jBg8MlxWLllJPSu8r00o')
            .collection('messages')
            .add(event);
      } catch (e) {
        debugPrint('Error adding event to Firestore: $e');
        // You might want to handle errors more gracefully here
      }
    }
  }
}
