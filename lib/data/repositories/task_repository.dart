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
      await tasksColleciton.add(TaskModel(
              title: 'Event Contribution1',
              description:
                  'The following tasks are required to be accomplished by gold level members within this cooperative',
              progress: 0.0,
              toDoList: [
                ToDoItem(title: 'Contributess to event', isChecked: false),
                ToDoItem(title: 'Bring food and tables', isChecked: false),
                ToDoItem(title: 'Prepare medicines etc.', isChecked: false),
              ]).toMap());
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
