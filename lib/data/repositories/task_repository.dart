import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/core/file_picker.dart';
import 'package:cooptourism/data/models/task.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;

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

  // Get all tasks from firestore that are assigned to a specific user
  Stream<List<TaskModel>> getAllTasksByUser(String userId) {
    return tasksColleciton
        .where('assignedMember', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get all tasks from firestore by referenceId
  Stream<List<TaskModel>> getAllTasksByReferenceId(String? referenceId) {
    return tasksColleciton
        .where('referenceId', isEqualTo: referenceId)
        .snapshots()
        .map((snapshot) {
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

  // Get task by referenceId using Future
  Future<TaskModel?> getTaskByReferenceId(String? referenceId, String userId) async {
    try {
      final doc = await tasksColleciton
          .where('referenceId', isEqualTo: referenceId)
          .where('assignedMember', isEqualTo: userId)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return TaskModel.fromMap(
              snapshot.docs.first.id, snapshot.docs.first.data() as Map<String, dynamic>
          );
        }
        return null;
      });
      return doc;
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

  // Update a Todo in Task in firestore
  Future<void> updateTaskTodo(
      String? taskId, ToDoItem todo) async {
    try {
      await tasksColleciton
          .doc(taskId)
          .update({'toDoList': FieldValue.arrayUnion([todo.toMap()])});
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

  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadFile(String? taskId, String proofPath,
      FilePickerUtility filePickerUtility) async {
    try {
      File? file;

      // Check if a file or an image has been picked
      if (filePickerUtility.pickedFile != null) {
        file = filePickerUtility.pickedFile!;
      } else if (filePickerUtility.image != null) {
        file = filePickerUtility.image!;
      }

      if (file == null) {
        throw Exception('No file selected');
      }

      debugPrint("Original size: ${await file.length()}");

      // Check if the file is an image
      bool isImage = ['.jpg', '.jpeg', '.png', '.gif', '.bmp']
          .contains(path.extension(file.path).toLowerCase());

      if (isImage) {
        // Define a target path for the compressed image
        String targetPath = path.join(path.dirname(file.absolute.path),
            "${path.basenameWithoutExtension(file.absolute.path)}_compressed.jpg");

        // Compress the image using flutter_image_compress
        var result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: 88,
          minWidth: 1200,
          minHeight: 675,
        );

        if (result == null) {
          throw Exception('Failed to compress image');
        }

        file = File(result.path); // Update the file with the compressed one
        debugPrint("Compressed image size: ${await file.length()}");
      }

      // Proceed to upload the file (compressed image or original file)
      Reference ref = FirebaseStorage.instance.ref().child('tasks/$proofPath');
      UploadTask uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() {});
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl; // Return the download URL after the file is uploaded
    } on FirebaseException catch (e) {
      debugPrint('Error uploading file to Firebase Storage: $e');
      rethrow; // Rethrow the exception after logging it
    }
  }


  // Add manually
 Future<void> addTaskManually() async {
    try {
      await tasksColleciton.add(
        TaskModel(
          title: 'Historical Walk in Intramuros',
          description:
              'Tasks associated with organizing the Historical Walk in Intramuros. Ensure all tasks are completed to provide an educational and engaging experience.',
          progress: 0.0,
          toDoList: [
            ToDoItem(title: 'Design the route to cover major historical sites', isChecked: false),
            ToDoItem(title: 'Hire knowledgeable tour guides', isChecked: false),
            ToDoItem(title: 'Coordinate with Intramuros Administration for access permissions', isChecked: false),
            ToDoItem(title: 'Arrange for audio equipment for the tour', isChecked: false),
            ToDoItem(title: 'Prepare informative materials and handouts', isChecked: false),
            ToDoItem(title: 'Set up registration booth and checkpoints', isChecked: false),
            ToDoItem(title: 'Organize a briefing on the historical significance of Intramuros', isChecked: false),
            ToDoItem(title: 'Confirm bookings for group meals or refreshments', isChecked: false),
            ToDoItem(title: 'Plan for first-aid and emergency contingencies', isChecked: false),
            ToDoItem(title: 'Gather feedback forms for the end of the tour', isChecked: false),
          ],
          type: 'Cultural',
          referenceId: '6LMTLXQOloSsEWbIL1il' // Replace with the actual ID for the event.
        ).toMap()
      );
    } catch (e) {
      debugPrint('Error adding Mount Apo Trekking Task to Firestore: $e');
      // Implement more error handling as necessary
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
