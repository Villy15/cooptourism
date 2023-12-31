import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:flutter/material.dart';

class CooperativesRepository {
  final CollectionReference cooperativesCollection =
      FirebaseFirestore.instance.collection('cooperatives');

  // Get cooperative from Firestore
  Future<CooperativesModel> getCooperative(String coopId) async {
    try {
      final doc = await cooperativesCollection.doc(coopId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> managersDynamic = data['managers'];
        List<DocumentReference> managers =
            managersDynamic.map((item) => item as DocumentReference).toList();
        data['managers'] =
            managers; // Replace the 'managers' field with the converted list
        return CooperativesModel.fromJson(doc.id, data);
      } else {
        debugPrint('Document does not exist on the database');
        throw Exception('Document does not exist on the database');
      }
    } catch (e) {
      debugPrint('Error getting cooperative from Firestore: $e');
      rethrow;
    }
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

  // Get members subcollection of a cooperative from Firestore as Future and get their UIDs
  Future<List<UserModel>> getCooperativeMembers2(String coopId) async {
    try {
      final doc =
          await cooperativesCollection.doc(coopId).collection('members').get();

      List<UserModel> members = [];

      for (var doc in doc.docs) {
        var data = doc.data();
        members.add(UserModel.fromJson(doc.id, data));
      }

      return members;
    } catch (e) {
      debugPrint('Error getting cooperative members from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // get a specific member from the members subcollection of a cooperative from Firestore
  Future<DocumentSnapshot> getCooperativeMember(
      String coopId, String memberId) async {
    try {
      return await cooperativesCollection
          .doc(coopId)
          .collection('members')
          .doc(memberId)
          .get();
    } catch (e) {
      debugPrint('Error getting cooperative member from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // verify if current user profile is a manager of a cooperative
  // from the field managers (list of strings) of a cooperative from Firestore
  Future<String?> isCooperativeManager(String uid) async {
    try {
      final querySnapshot = await cooperativesCollection.get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['managers'] != null) {
          List<dynamic> managersDynamic = data['managers'];
          List<String> managers = [];
          for (var ref in managersDynamic) {
            DocumentSnapshot managerDoc = await ref.get();
            managers.add(managerDoc.id);
          }
          debugPrint(managersDynamic.toString());
          if (managers.contains(uid)) {
            debugPrint('user exists!!!!!');
            return doc.id; // return the cooperative ID
          }
        }
      }
      return null; // return null if the user is not a manager in any cooperative
    } catch (e) {
      debugPrint('Error getting cooperatives from Firestore: $e');
      rethrow;
    }
  }

  // add a member to the members subcollection of a cooperative from Firestore
  Future<void> addCooperativeMember(
      String coopId, String memberId, UserModel user) async {
    try {
      await cooperativesCollection
          .doc(coopId)
          .collection('members')
          .doc(memberId)
          .set({
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
        'role': user.role,
      });
    } catch (e) {
      debugPrint('Error adding cooperative member to Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  Future<List<String>> getCooperativeMembersNames(String coopId) async {
    try {
      final querySnapshot =
          await cooperativesCollection.doc(coopId).collection('members').get();

      List<String> memberNames = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        String fullName = "${data['last_name']} ${data['first_name']}";
        memberNames.add(fullName);
      }

      return memberNames;
    } catch (e) {
      debugPrint('Error getting cooperative members from Firestore: $e');
      rethrow;
    }
  }

  Future<List<Map<String, String>>> getCooperativeMembersNamesUid(
      String coopId) async {
    try {
      final querySnapshot =
          await cooperativesCollection.doc(coopId).collection('members').get();

      List<Map<String, String>> members = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        String fullName = "${data['last_name']} ${data['first_name']}";
        members.add({'id': doc.id, 'name': fullName});
      }

      return members;
    } catch (e) {
      debugPrint('Error getting cooperative members from Firestore: $e');
      rethrow;
    }
  }

  // Add cooperative
  Future<DocumentReference> addCooperative(
      CooperativesModel cooperative) async {
    try {
      return await cooperativesCollection.add(cooperative.toJson());
    } catch (e) {
      debugPrint('Error adding cooperative to Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
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
        return CooperativesModel.fromJson(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
