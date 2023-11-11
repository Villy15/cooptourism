import 'package:cooptourism/data/models/coaching_form.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoachingRepository {
  final CollectionReference coachingCollection =
      FirebaseFirestore.instance.collection('coaching_concerns');

  // Get all Coaching Forms from Firestore
  Stream<List<CoachingFormModel>> getAllCoachingForms() {
    return coachingCollection
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CoachingFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
          });
  }

  // Get all pending coaching forms from Firestore
  Stream<List<CoachingFormModel>> getAllPendingCoachingForms() {
    return coachingCollection
          .where('status', isEqualTo: 'Pending')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CoachingFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
          });
  }

  // Get all approved coaching forms from Firestore
  Stream<List<CoachingFormModel>> getAllApprovedCoachingForms() {
    return coachingCollection
          .where('status', isEqualTo: 'Approved')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CoachingFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
          });
  }

  // Get all rejected coaching forms from Firestore
  Stream<List<CoachingFormModel>> getAllRejectedCoachingForms() {
    return coachingCollection
          .where('status', isEqualTo: 'Declined')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CoachingFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
          });
  }

  // get all coaching forms with the concern "Tour Accommodation" from Firestore
  Stream<List<CoachingFormModel>> getAllTourAccommodationCoachingForms() {
    return coachingCollection
          .where('coaching_focus', isEqualTo: 'Tour Accommodation')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CoachingFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
          });
  }

  // get coaching forms based on the coaching focus from Firestore
  Stream<List<CoachingFormModel>> getByCoachingFocus(String coachingFocus) {
    return coachingCollection
          .where('coaching_focus', isEqualTo: coachingFocus)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CoachingFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
          });
  }

  // get all coaching forms with the concern "Driving Skills" from Firestore
  Stream<List<CoachingFormModel>> getAllDrivingSkillsCoachingForms() {
    return coachingCollection
          .where('coaching_focus', isEqualTo: 'Driving Skills')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CoachingFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
          });
  }

  // get all coaching forms with the concern "Tour Guide" from Firestore
  Stream<List<CoachingFormModel>> getAllTourGuideCoachingForms() {
    return coachingCollection
          .where('coaching_focus', isEqualTo: 'Tour Guide')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CoachingFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
          });
  }

  // get all coaching forms with the concern "Credit Loans" from Firestore
  Stream<List<CoachingFormModel>> getAllCreditLoansCoachingForms() {
    return coachingCollection
          .where('coaching_focus', isEqualTo: 'Credit Loans')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CoachingFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
          });
  }

  // Add a Coaching Form to Firestore
  Future<void> addCoachingForm(CoachingFormModel coachingForm) async {
    try {
      await coachingCollection.add(coachingForm.toJson());
    } catch (e) {
      debugPrint('Error adding Coaching Form to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Update a Coaching Form in Firestore
  Future<void> updateCoachingForm(CoachingFormModel coachingForm) async {
    try {
      await coachingCollection.doc(coachingForm.uid).update(coachingForm.toJson());
    } catch (e) {
      debugPrint('Error updating Coaching Form in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete a Coaching Form from Firestore
  Future<void> deleteCoachingForm(String uid) async {
    try {
      await coachingCollection.doc(uid).delete();
    } catch (e) {
      debugPrint('Error deleting Coaching Form from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Get a Coaching Form from Firestore
  Future<CoachingFormModel> getCoachingForm(String uid) async {
    return coachingCollection.doc(uid).get().then((doc) {
      return CoachingFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
    });
  }
  
}