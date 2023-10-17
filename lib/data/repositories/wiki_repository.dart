import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/wiki.dart';
import 'package:flutter/material.dart';

class WikiRepository {
  final CollectionReference wikiCollection =
      FirebaseFirestore.instance.collection('wiki');

   Stream<List<WikiModel>> getAllWiki() {
    return wikiCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return WikiModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Add a Wiki to Firestore
  Future<void> addWiki(WikiModel wiki) async {
    try {
      await wikiCollection.add(wiki.toJson());
    } catch (e) {
      debugPrint('Error adding Wiki to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Read a Wiki from Firestore
  Future<WikiModel> getSpecificWiki(String wikiId) async {
    try {
      final doc = await wikiCollection.doc(wikiId).get();
      return WikiModel.fromJson(wikiId, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting Wiki from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Update a Wiki in Firestore
  Future<void> updateWiki(String wikiId, WikiModel wiki) async {
    try {
      await wikiCollection.doc(wikiId).update(wiki.toJson());
    } catch (e) {
      debugPrint('Error updating Wiki in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete a Wiki from Firestore
  Future<void> deleteWiki(String wikiId) async {
    try {
      await wikiCollection.doc(wikiId).delete();
    } catch (e) {
      debugPrint('Error deleting Wiki from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Add a method to add data manually
  Future<void> addWikiManually() async {
    try {
      await wikiCollection.add({
        'title': 'Tourism Cooperatives Explained',
        'description':
            'Learn how tourism cooperatives offer unique travel experiences while supporting local communities.',
        'image': '',
        // 'date': DateTime.now(),
        // 'author': 'John Doe',
        // 'category': 'How to use',
        // 'tags': ['How to use', 'Co-op services'],
        // 'isFeatured': true,
        // 'isSaved': false,
      });
    } catch (e) {
      debugPrint('Error adding Wiki to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete all wiki from Firestore
  // Future<void> deleteAllWiki() async {
  //   try {
  //     final allWiki = await wikiCollection.get();
  //     for (final doc in allWiki.docs) {
  //       await doc.reference.delete();
  //     }
  //   } catch (e) {
  //     debugPrint('Error deleting all Wiki from Firestore: $e');
  //     // You might want to handle errors more gracefully here
  //   }
  // }
}