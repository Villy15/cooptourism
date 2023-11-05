import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/itineraries.dart';
import 'package:flutter/material.dart';

class ItineraryRepository {
  final CollectionReference itneraryCollection =
      FirebaseFirestore.instance.collection('itineraries');

  // Get all itnerary
  Stream<List<ItineraryModel>> getAllItinerary() {
    return itneraryCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItineraryModel.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Filter budget
  Stream<List<ItineraryModel>> filterBudget(RangeValues budget) {
    return itneraryCollection
        // Apply the lower bound of the budget filter
        .where('budget', isGreaterThanOrEqualTo: budget.start)
        // Apply the upper bound of the budget filter
        .where('budget', isLessThanOrEqualTo: budget.end)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItineraryModel.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Filter city future
  Future<List<ItineraryModel>> filterCityFuture(String city) async {
    final snapshot =
        await itneraryCollection.where('city', isEqualTo: city).get();

    debugPrint(snapshot.docs.toString());
    return snapshot.docs.map((doc) {
      return ItineraryModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // get all itnerary future
  Future<List<ItineraryModel>> getAllItineraryFuture() async {
    final snapshot = await itneraryCollection.get();
    return snapshot.docs.map((doc) {
      return ItineraryModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Add an itnerary
  Future<void> addItinerary(ItineraryModel itnerary) async {
    try {
      await itneraryCollection.add(itnerary.toMap());
    } catch (e) {
      debugPrint('Error adding itnerary to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Read an itnerary
  Future<ItineraryModel> getSpecificItinerary(String itneraryId) async {
    try {
      final doc = await itneraryCollection.doc(itneraryId).get();
      return ItineraryModel.fromMap(
          itneraryId, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting itnerary from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Update an itnerary
  Future<void> updateItinerary(
      String? itneraryId, ItineraryModel itnerary) async {
    try {
      await itneraryCollection.doc(itneraryId).update(itnerary.toMap());
    } catch (e) {
      debugPrint('Error updating itnerary in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete an itnerary
  Future<void> deleteItinerary(String itneraryId) async {
    try {
      await itneraryCollection.doc(itneraryId).delete();
    } catch (e) {
      debugPrint('Error deleting itnerary in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Add manually
  Future<void> addItineraryManually() async {
    List<Map<String, dynamic>> itineraries = [
      {
        'city': 'Mariveles',
        'province': 'Bataan',
        'images': [
          'Laki-Beach-Mariveles-1024x768.jpg',
        ],
        'days': 5,
        'name': 'Mariveles Historical and Adventure Tour',
        'description':
            'Take a journey through history and nature in Mariveles, Bataan. Visit the Mount Samat National Shrine, walk along the Death March markers, and explore the stunning coves known as Five Fingers.',
        'budget': 20000,
        'tags': ['history', 'adventure', 'nature'],
      },
      {
        'city': 'Mariveles',
        'province': 'Bataan',
        'images': [
          'Camaya_waterfalls-3.jpg',
        ],
        'days': 3,
        'name': 'Mariveles Nature and Wildlife Experience',
        'description':
            'Connect with the serene beauty of Mariveles. Enjoy the view of Sisiman Bay, contribute to the conservation of Pawikan sea turtles, and refresh at the local waterfalls.',
        'budget': 12000,
        'tags': ['wildlife', 'conservation', 'scenic'],
      },
      {
        'city': 'Mariveles',
        'province': 'Bataan',
        'images': [
          '1mi3i12000c5pfn4n1A6E_W_400_0_R5_Q90.jpg',
        ],
        'days': 4,
        'name': 'Mariveles Coastal Retreat and History Tour',
        'description':
            'Relax on the pristine beaches of Camaya Coast, explore various hiking trails, and immerse yourself in the rich World War II history of Bataan at the local museum.',
        'budget': 15000,
        'tags': ['beach', 'hiking', 'history'],
      },
    ];

    try {
      for (var itinerary in itineraries) {
        await itneraryCollection.add(itinerary);
      }
    } catch (e) {
      debugPrint('Error adding itinerary to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete all
  Future<void> deleteAllItinerary() async {
    try {
      final allItineraries = await itneraryCollection.get();
      for (var itinerary in allItineraries.docs) {
        await itinerary.reference.delete();
      }
    } catch (e) {
      debugPrint('Error deleting itinerary from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Add

  Future<void> manualAdd(
      String itineraryId, List<DaySchedModel> daySchedules) async {
    try {
      // Get a reference to the document for the specified itinerary
    } catch (e) {
      debugPrint('Error adding schedule to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Add schedule
  Future<void> addSchedule(
      String itineraryId, DaySchedModel daySchedule) async {
    try {
      // Get a reference to the document for the specified itinerary
      final itineraryDoc = itneraryCollection.doc(itineraryId);

      // Get a reference to the collection of schedules for the specified itinerary
      final scheduleCollection = itineraryDoc.collection('schedules');

      // Add the schedule to the collection
      await scheduleCollection.add(daySchedule.toMap());
      debugPrint("Added schedule");
    } catch (e) {
      debugPrint('Error adding schedule to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Read schedule in stream
  Stream<List<DaySchedModel>> getScheduleStream(String itineraryId) {
    try {
      // Get a reference to the document for the specified itinerary
      final itineraryDoc = itneraryCollection.doc(itineraryId);

      // Get a reference to the collection of schedules for the specified itinerary
      final scheduleCollection = itineraryDoc.collection('schedules');

      // Get the snapshots for the collection
      return scheduleCollection.snapshots().map((snapshot) {
        // Convert each snapshot to a schedule
        return snapshot.docs.map((doc) {
          // Create a DaySchedModel from the document data
          var daySched = DaySchedModel.fromMap(doc.data());

          // Sort the activities of the day schedule by datetime
          daySched.activities.sort((a, b) => a.datetime.compareTo(b.datetime));

          return daySched;
        }).toList();
      });
    } catch (e) {
      debugPrint('Error getting schedule from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Add activity
  Future<bool> updateActivity(
    String? itineraryId,
    ActivityModel newActivity,
    int i,
  ) async {
    try {
      // Get a reference to the document for the specified itinerary
      final itineraryDoc = itneraryCollection.doc(itineraryId);

      // Get a reference to the collection of schedules for the specified itinerary
      final scheduleCollection = itineraryDoc.collection('schedules');

      // Get the snapshots for the collection
      final snapshot = await scheduleCollection.get();

      // Find which document has the same day number as the activity
      final dayDoc =
          snapshot.docs.firstWhere((doc) => doc.data()['dayNumber'] == i);

      // Update the activities array of the document by adding the new activity
      await dayDoc.reference.update({
        'activities': FieldValue.arrayUnion([newActivity.toMap()])
      });

      debugPrint("Added activity");
      return true;
    } catch (e) {
      debugPrint('Error adding schedule to Firestore: $e');
      // You might want to handle errors more gracefully here
      return false;
    }
  }
}
