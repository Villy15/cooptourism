import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/locations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class LocationRepository {
  final CollectionReference locationCollection =
      FirebaseFirestore.instance.collection('locations');

  // Get all location
  Stream<List<LocationModel>> getAllLocation() {
    return locationCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return LocationModel.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // get all location future
  Future<List<LocationModel>> getAllLocationFuture() async {
    final snapshot = await locationCollection.get();
    return snapshot.docs.map((doc) {
      return LocationModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Add an location
  Future<void> addLocation(LocationModel location) async {
    try {
      await locationCollection.add(location.toMap());
    } catch (e) {
      debugPrint('Error adding location to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Read an location
  Future<LocationModel> getSpecificLocation(String locationId) async {
    try {
      final doc = await locationCollection.doc(locationId).get();
      return LocationModel.fromMap(
          locationId, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting location from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Update an location
  Future<void> updateLocation(
      String? locationId, LocationModel location) async {
    try {
      await locationCollection.doc(locationId).update(location.toMap());
    } catch (e) {
      debugPrint('Error updating location in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete an location
  Future<void> deleteLocation(String locationId) async {
    try {
      await locationCollection.doc(locationId).delete();
    } catch (e) {
      debugPrint('Error deleting location from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Add manually
  Future<void> addLocationManually() async {
    List<Map<String, dynamic>> locations = [
      {
        'city': 'Puerta Princesa',
        'province': 'Palawan',
        'images': ['1i65k2224o5fogpsw6DA2.jpg']
      },
      {'city': 'Loay', 'province': 'Bohol', 'images': []},
      {'city': 'Mariveles', 'province': 'Bataan', 'images': []}
    ];

    try {
      for (var location in locations) {
        await locationCollection.add(location);
      }
    } catch (e) {
      debugPrint('Error adding location to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete all
  Future<void> deleteAllLocation() async {
    try {
      final allLocations = await locationCollection.get();
      for (var location in allLocations.docs) {
        await location.reference.delete();
      }
    } catch (e) {
      debugPrint('Error deleting location from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  Future<List<String>> getEventImageUrls(List<String> imagePaths) async {
    final storageRef = FirebaseStorage.instance.ref();
    List<String> imageUrls = [];

    for (String imagePath in imagePaths) {
      String fullPath = 'locations/images//$imagePath';
      String downloadUrl = await storageRef.child(fullPath).getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }
}
