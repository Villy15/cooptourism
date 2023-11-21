import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/coop_application.dart';

class JoinCooperativeRepository {
  final CollectionReference coopApplicationsCollection =
      FirebaseFirestore.instance.collection('coop_applications');

  // Get all Cooperative Applications from Firestore
  Stream<List<CooperativeAppFormModel>> getAllCoopApplications() {
    return coopApplicationsCollection
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CooperativeAppFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
          });
  }

  // get one cooperative application from Firestore
  Future<DocumentSnapshot> getCoopApplication(String coopAppId) {
    return coopApplicationsCollection
          .doc(coopAppId)
          .get();
  }
  
  // delete cooperative application from Firestore
  Future<void> deleteCoopApplication(String coopAppId) {
    return coopApplicationsCollection
          .doc(coopAppId)
          .delete();
  }
  
  // get all pending cooperative applications from Firestore
  Stream<List<CooperativeAppFormModel>> getAllPendingCoopApplications() {
    return coopApplicationsCollection
          .where('status', isEqualTo: 'Pending')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CooperativeAppFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
          });
  }

  // get all pending cooperative applications based on cooperative id from Firestore
  Stream<List<CooperativeAppFormModel>> getAllPendingCoopApplicationsByCoopId(String coopId) {
    return coopApplicationsCollection
          .where('status', isEqualTo: 'Pending')
          .where('coopId', isEqualTo: coopId)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CooperativeAppFormModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            }).toList();
          });
  }

  // change status to approved for a cooperative application in Firestore
  Future<void> approveCoopApplication(String coopAppId) {
    return coopApplicationsCollection
          .doc(coopAppId)
          .update({'status': 'Approved'});
  }

  // update a cooperative application in Firestore
  Future<void> updateCoopApplication(String coopAppId, CooperativeAppFormModel coopApplication) {
    return coopApplicationsCollection
          .doc(coopAppId)
          .update(coopApplication.toJson());
  }

  // add a new cooperative application to Firestore
  Future<DocumentReference> addCoopApplication(CooperativeAppFormModel coopApplication) {
    return coopApplicationsCollection
          .add(coopApplication.toJson());
  }

  // get a specific cooperative application from Firestore using member uid
  Future<DocumentSnapshot?> getFormUsingMemberUID(String memberUID, String coopId) {
  return coopApplicationsCollection
    .where('userUID', isEqualTo: memberUID)
    .where('coopId', isEqualTo: coopId)
    .get()
    .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first;
      } else {
        return null; // Return a DocumentSnapshot with no data
      }
    });
}
}