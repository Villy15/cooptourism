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
  List<Map<String, dynamic>> events = [
    {
      'title': 'Palawan Island Adventure',
      'startDate': DateTime.now().add(const Duration(days: 2)).millisecondsSinceEpoch,
      'endDate': DateTime.now().add(const Duration(days: 5)).millisecondsSinceEpoch,
      'description': 'Join us for a 3-day adventure in the heart of Palawan. Explore the hidden lagoons, snorkel in crystal-clear waters, and enjoy the tranquility of this paradise.',
      'location': 'El Nido, Palawan',
      'tags': ['adventure', 'nature', 'beach', 'hiking'],
      'image': ['https://picsum.photos/200/300?random=1', 'https://picsum.photos/200/300?random=2', 'https://picsum.photos/200/300?random=3']
    },
    {
      'title': 'Historical Walk in Intramuros',
      'startDate': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
      'endDate': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
      'description': 'Take a step back in time and discover the rich history of the Philippines with our guided walk in Intramuros, the Walled City of Manila.',
      'location': 'Intramuros, Manila',
      'image': ['https://picsum.photos/200/300?random=1', 'https://picsum.photos/200/300?random=2', 'https://picsum.photos/200/300?random=3']
    },
    {
      'title': 'Mount Apo Trekking Experience',
      'startDate': DateTime.now().add(const Duration(days: 10)).millisecondsSinceEpoch,
      'endDate': DateTime.now().add(const Duration(days: 13)).millisecondsSinceEpoch,
      'description': 'Challenge yourself with a trek to the highest peak in the Philippines. Witness diverse flora and fauna, enjoy the scenic views, and immerse yourself in the beauty of nature.',
      'location': 'Mount Apo, Mindanao',
      'tags': ['adventure', 'nature', 'hiking'],
    }
  ];

  for (var event in events) {
    try {
      await eventsCollection.add(event);
    } catch (e) {
      debugPrint('Error adding event to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
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