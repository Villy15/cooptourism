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
        return ListingModel.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get Listing by type from Firestore
  Stream<List<ListingModel>> getListingsByType(String type) {
    return listingsCollection
        .where('type', isEqualTo: type)
        .orderBy('postDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ListingModel.fromMap(
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
      return ListingModel.fromMap(
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
      await listingsCollection.doc(listingId).update(listing.toMap());
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

  //Get all messages for specific receiver and sender 1 is to 1 relationship
  Stream<List<MessageModel>> getSingleSourceMessages(
      String listingId, String senderId, String receiverId, String docId) {
    return listingsCollection
        .doc(listingId)
        .collection('messages')
        .where(Filter.and(
            Filter.or(Filter('senderId', isEqualTo: senderId),
                Filter('senderId', isEqualTo: receiverId)),
            Filter.or(Filter('receiverId', isEqualTo: senderId),
                Filter('receiverId', isEqualTo: receiverId))))
        .orderBy('timeStamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  //Get all messages for specific receiver and sender 1 is to many relationship
  // applies for listing owners since they need an inbox for people who message
  Stream<List<MessageModel>> getReceivedFromMessages(
      String listingId, String docId) {
    return listingsCollection
        .doc(listingId)
        .collection('messages')
        .doc(docId)
        .collection('chat')
        .orderBy('timeStamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  //Get all messages received for a specific listing.
  Stream<List<MessageModel>> getAllReceivedFrom(String listingId) {
    return listingsCollection
        .doc(listingId)
        .collection('messages')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Add a Message to Firestore
  Future<void> addMessage(
      MessageModel message, String listingId, String docId) async {
    final exists = await listingsCollection
        .doc(listingId)
        .collection('messages')
        .doc(docId)
        .collection('chat')
        .where(Filter.and(
          Filter.or(Filter('senderId', isEqualTo: message.senderId),
              Filter('senderId', isEqualTo: message.receiverId)),
          Filter.or(
            Filter('receiverId', isEqualTo: message.senderId),
            Filter('receiverId', isEqualTo: message.receiverId),
          ),
        ))
        .count()
        .get();
      try {
        listingsCollection
            .doc(listingId)
            .collection('messages')
            .doc(docId)
            .collection('chat')
            .add(message.toMap());
      } catch (e) {
        debugPrint('Error adding Listing to Firestore: $e');
        // You might want to handle errors more gracefully here
      }
  }
}
