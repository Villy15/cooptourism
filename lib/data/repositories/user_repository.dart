import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:flutter/material.dart';

class UserRepository {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Add a user to Firestore
  Future<void> addUserToFirestore(UserModel user) async {
    try {
      await usersCollection.doc(user.uid).set({
        'email': user.email,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'status': user.status,
        'user_accomplishment': user.userAccomplishment,
        'user_rating': user.userRating,
        'user_trust': user.userTrust,
        'role': user.role
      });
    } catch (e) {
      debugPrint('Error adding user to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Get a user from Firestore by UID
  Future<UserModel?> getUserByUid(String uid) async {
    try {
      final DocumentSnapshot userSnapshot = await usersCollection.doc(uid).get();
      if (userSnapshot.exists) {
        return UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getting user from Firestore: $e');
      return null;
    }
  }

  // Update a user in Firestore
  Future<void> updateUserInFirestore(UserModel user) async {
    try {
      // await usersCollection.doc(user.uid).update(user.toJson());
    } catch (e) {
      debugPrint('Error updating user in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete a user from Firestore by UID
  Future<void> deleteUserFromFirestore(String uid) async {
    try {
      await usersCollection.doc(uid).delete();
    } catch (e) {
      debugPrint('Error deleting user from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }
}