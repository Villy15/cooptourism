import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:flutter/material.dart';

class UserRepository {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Get all users from Firestore
  Stream<List<UserModel>> getAllUsers() {
    return usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Add a user to Firestore
  Future<void> addUser(UserModel user) async {
    try {
      await usersCollection.add(user.toJson());
    } catch (e) {
      debugPrint('Error adding user to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  Future<List<UserModel>> getUsersByRole(String role) async {
    return usersCollection
        .where('role', isEqualTo: role)
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read a user from Firestore
  Future<UserModel> getUser(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).get();
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting user from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Update a user in Firestore
  Future<void> updateUser(String userId, UserModel user) async {
    try {
      await usersCollection.doc(userId).update(user.toJson());
    } catch (e) {
      debugPrint('Error updating user in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete a user from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await usersCollection.doc(userId).delete();
    } catch (e) {
      debugPrint('Error deleting user from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }
}
