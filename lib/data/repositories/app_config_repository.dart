import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppConfigRepository {
  final CollectionReference appConfigCollection =
      FirebaseFirestore.instance.collection('app_config');

  // Get tourism categories
  Future<List<String>> getTourismCategories() async {
    try {
      final doc = await appConfigCollection.doc("tourism_services").get();
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      
      return List<String>.from(data["tourismCategories"]);
    } catch (e) {
      debugPrint('Error getting cooperative from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }
  // Get tourism types
  Future<List<String>> getTourismTypes() async {
    try {
      final doc = await appConfigCollection.doc("tourism_services").get();
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return List<String>.from(data["tourismTypes"]);
    } catch (e) {
      debugPrint('Error getting cooperative from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAmenities() async {
    try {
      final doc = await appConfigCollection.doc("tourism_services").get();
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Map<String, dynamic>.from(data["amenities"]);
    } catch (e) {
      debugPrint('Error getting cooperative from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

}
