import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/message.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:flutter/material.dart';

class UserRepository {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Get all users from Firestore
  Stream<List<UserModel>> getAllUsers() {
    return usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // get users with role of Coach
  Stream<List<UserModel>> getAllCoaches() {
    return usersCollection
        .where('role', isEqualTo: 'Coach')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
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
        final data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id; //
        return UserModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<List<String>> getUserUIDByRole(String role) async {
    return usersCollection
        .where('role', isEqualTo: role)
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.id;
      }).toList();
    });
  }

  // Read a user from Firestore
  Future<UserModel> getUser(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).get();
      return UserModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('the string user ID is still: $userId');
      debugPrint('Error getting user from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Get the first name and last name of the user from Firestore
  Future<String> getUserName(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).get();
      final data = doc.data() as Map<String, dynamic>;
      return data['first_name'] + " " + data['last_name'];
    } catch (e) {
      debugPrint('Error getting user from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Get user streamr
  Stream<UserModel> getUserStream(String userId) {
    return usersCollection.doc(userId).snapshots().map((snapshot) {
      return UserModel.fromJson(snapshot.id, snapshot.data() as Map<String, dynamic>);
    });
  }
  

  // get users by user role, return a UserModel with its uid
  Future<List<UserModel>> getAllUsersByRole(String role) async {
    try {
      final querySnapshot =
          await usersCollection.where('role', isEqualTo: role).get();
      final users = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id; // include uid in the retrieved data
        return UserModel.fromJson("", data);
      }).toList();
      return users;
    } catch (e) {
      debugPrint('Error getting users from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  Future<String> getUserUIDByNames(String firstName, String lastName) async {
    try {
      // debugPrint(
      //     "$firstName is the first name, while $lastName is the last name");
      final querySnapshot = await usersCollection
          .where('first_name', isEqualTo: firstName)
          .where('last_name', isEqualTo: lastName)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = querySnapshot.docs.first;
        debugPrint(docSnapshot.toString());
        return docSnapshot.id;
      } else {
        // Handle the error appropriately
        throw Exception('No user found with the specified first and last name');
      }
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

  // get messages from firestore
  Stream<List<MessageModel>> getAllMessages(
      String senderId, String receiverId) {
    return usersCollection
        .doc(senderId)
        .collection('coaching_messages')
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

  // Add a message to Firestore
  Future<void> addMessage(MessageModel message, String userId) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('coaching_messages')
          .add(message.toMap());
    } catch (e) {
      debugPrint('Error adding Listing to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // add manually
  Future<void> addMessageManually() async {
    List<Map<String, dynamic>> events = [
      {
        'senderId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'receiverId': 'Vy4YiXQBhuNZu3sHeSel',
        'content': 'Hello! I am interested in coaching!',
        'timeStamp': DateTime.now(),
      },
      {
        'senderId': 'Vy4YiXQBhuNZu3sHeSel',
        'receiverId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'content': 'Oh yes. I am available.',
        'timeStamp': DateTime.now(),
      }
    ];

    for (var event in events) {
      try {
        await usersCollection
            .doc('ewBh7JJqkpe0XwYRMiAsRwuw0in1')
            .collection('coaching_messages')
            .add(event);
      } catch (e) {
        debugPrint('Error adding event to Firestore: $e');
        // You might want to handle errors more gracefully here
      }
    }
  }
}
