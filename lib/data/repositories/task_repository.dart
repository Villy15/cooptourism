import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/task.dart';
import 'package:flutter/material.dart';

class TaskRepository {
  final CollectionReference tasksColleciton =
      FirebaseFirestore.instance.collection('tasks');

  // Get all Tasks from Firestore
  Stream<List<TaskModel>> getAllTasks() {
    return tasksColleciton.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Add a Task to Firestore
  Future<void> addTask(TaskModel task) async {
    try {
      await tasksColleciton.add(task.toMap());
    } catch (e) {
      debugPrint('Error adding Task to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Read a Task from Firestore
  Future<TaskModel> getSpecificTask(String taskId) async {
    try {
      final doc = await tasksColleciton.doc(taskId).get();
      return TaskModel.fromMap(taskId, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting Task from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  Stream<TaskModel?> streamSpecificTask(String taskId) {
    return tasksColleciton.doc(taskId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return TaskModel.fromMap(
            taskId, snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Update a Task in Firestore
  Future<void> updateTask(String? taskId, TaskModel task) async {
    try {
      await tasksColleciton.doc(taskId).update(task.toMap());
    } catch (e) {
      debugPrint('Error updating Task in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete a Task from Firestore
  Future<void> deleteTask(String taskId) async {
    try {
      await tasksColleciton.doc(taskId).delete();
    } catch (e) {
      debugPrint('Error deleting Task from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Add manually
  Future<void> addTaskManually() async {
    try {
      await tasksColleciton.add(
        TaskModel(
          title: 'Palawan Island Adventure Preparations',
          description:
              'Tasks associated with the Palawan Island Adventure. Ensure all tasks are completed for a successful event.',
          progress: 0.0,
          toDoList: [
            ToDoItem(title: 'Coordinate with participants', isChecked: false),
            ToDoItem(title: 'Arrange transportation to El Nido, Palawan', isChecked: false),
            ToDoItem(title: 'Reserve accommodations in El Nido', isChecked: false),
            ToDoItem(title: 'Plan the itinerary for hidden lagoon exploration', isChecked: false),
            ToDoItem(title: 'Arrange snorkeling gear for participants', isChecked: false),
            ToDoItem(title: 'Prepare hiking trail maps', isChecked: false),
            ToDoItem(title: 'Gather emergency contact details of participants', isChecked: false),
            ToDoItem(title: 'Ensure all participants are aware of the safety protocols', isChecked: false),
            ToDoItem(title: 'Collect contributions for event expenses', isChecked: false),
            ToDoItem(title: 'Prepare a backup plan in case of unforeseen events', isChecked: false),
          ],
          type: 'Event',
          referenceId: 'jHMdC3KQOk5Ah8kgS0YL' // This seems to be the ID of the event in the Firestore database.
        ).toMap()
      );
    } catch (e) {
      debugPrint('Error adding Task to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete all
  Future<void> deleteAllTasks() async {
    try {
      await tasksColleciton.get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch (e) {
      debugPrint('Error deleting Task from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  
}
