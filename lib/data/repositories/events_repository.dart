import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/events.dart';
import 'package:flutter/material.dart';

class EventsRepository {
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  // Get all events
  Stream<List<EventsModel>> getAllEvents() {
    return eventsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventsModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Add an event
  Future<void> addEvent(EventsModel event) async {
    try {
      await eventsCollection.add(event.toMap());
    } catch (e) {
      debugPrint('Error adding event to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Read an event
  Future<EventsModel> getSpecificEvent(String eventId) async {
    try {
      final doc = await eventsCollection.doc(eventId).get();
      return EventsModel.fromMap(eventId, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting event from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Update an event
  Future<void> updateEvent(String? eventId, EventsModel event) async {
    try {
      await eventsCollection.doc(eventId).update(event.toMap());
    } catch (e) {
      debugPrint('Error updating event in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      await eventsCollection.doc(eventId).delete();
    } catch (e) {
      debugPrint('Error deleting event from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Add manually
  Future<void> addEventManually() async {
    try {
      await eventsCollection.add({
        'title': 'Event 1',
        'startDate': DateTime.now().millisecondsSinceEpoch,
        'endDate': DateTime.now().millisecondsSinceEpoch,
        'description': 'Description 1',
        'location': 'Location 1',
        'image': 'https://picsum.photos/200/300'
      });
      await eventsCollection.add({
        'title': 'Event 2',
        'startDate': DateTime.now().millisecondsSinceEpoch,
        'endDate': DateTime.now().millisecondsSinceEpoch,
        'description': 'Description 2',
        'location': 'Location 2',
        'image': 'https://picsum.photos/200/300'
      });
      await eventsCollection.add({
        'title': 'Event 3',
        'startDate': DateTime.now().millisecondsSinceEpoch,
        'endDate': DateTime.now().millisecondsSinceEpoch,
        'description': 'Description 3',
        'location': 'Location 3',
        'image': 'https://picsum.photos/200/300'
      });
    } catch (e) {
      debugPrint('Error adding event to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete all events
  Future<void> deleteAllEvents() async {
    try {
      final events = await eventsCollection.get();
      for (final event in events.docs) {
        await event.reference.delete();
      }
    } catch (e) {
      debugPrint('Error deleting all events from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }
}