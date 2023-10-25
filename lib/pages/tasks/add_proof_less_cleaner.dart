import 'package:cooptourism/core/file_picker.dart';
import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/task.dart';
import 'package:cooptourism/data/repositories/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path_utils;

final TaskRepository taskRepository = TaskRepository();

class AddTaskProofPage extends StatefulWidget {
  final ToDoItem item;
  final TaskModel task;
  const AddTaskProofPage({Key? key, required this.item, required this.task})
      : super(key: key);

  @override
  AddPostPageState createState() => AddPostPageState();
}

class AddPostPageState extends State<AddTaskProofPage> {
  late FilePickerUtility filePickerUtility;

  @override
  void initState() {
    super.initState();
    filePickerUtility = FilePickerUtility(
      onImagePicked: _updateImageUI,
      onFilePicked: _updateFileUI,
    );
  }

  void _updateImageUI() {
    // Trigger a rebuild to reflect changes in the image
    setState(() {});
  }

  void _updateFileUI() {
    // Trigger a rebuild to reflect changes in the picked file
    setState(() {});
  }

  void updateTask() async {
    try {
      final proofPath = _getProofPath();

      if (proofPath == null) {
        _showSnackBar('Please add a proof first!');
        return;
      }

      debugPrint("Proof path: $proofPath");

      await _updateTaskInDatabase(proofPath);

      _showSnackBar('Task updated successfully!');
    } catch (e) {
      debugPrint('Error updating Task: $e');
      _showSnackBar('Error updating task!');
    }
  }

  Widget displayPickedFile() {
    if (filePickerUtility.pickedFile == null) {
      return Container(); // Empty widget or you can use a placeholder
    }

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 250,
        height: 200,
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(filePickerUtility.pickedFileIcon,
                size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                path_utils.basename(filePickerUtility.pickedFile!.path),
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceChoice(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery',
                      style: TextStyle(color: primaryColor)),
                  onTap: () {
                    Navigator.pop(context);
                    filePickerUtility.pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Take a Picture',
                      style: TextStyle(color: primaryColor)),
                  onTap: () {
                    Navigator.pop(context);
                    filePickerUtility.pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text('Choose a File',
                      style: TextStyle(color: primaryColor)),
                  onTap: () {
                    Navigator.pop(context);
                    filePickerUtility.pickFile();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Add Proof',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              Text(
                widget.item.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              if (filePickerUtility.image != null) ...[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(filePickerUtility.image!),
                      ),
                    ),
                  ),
                ),
              ] else if (filePickerUtility.pickedFile != null) ...[
                displayPickedFile(),
              ] else ...[
                imagePlaceHolder(primaryColor),
              ],

              const SizedBox(height: 16),

              // Create a rectangular button that has Add record
              addRecordRow(context, primaryColor),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String? _getProofPath() {
    if (filePickerUtility.image != null) {
      return path_utils.basename(filePickerUtility.image!.path);
    } else if (filePickerUtility.pickedFile != null) {
      return path_utils.basename(filePickerUtility.pickedFile!.path);
    }
    return null;
  }

  Future<void> _updateTaskInDatabase(String proofPath) async {
    TaskModel updatedTask = widget.task.copyWith(proof: proofPath);
    debugPrint(updatedTask.toString());

    await taskRepository.updateTask(widget.task.uid, updatedTask);
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Align imagePlaceHolder(Color primaryColor) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          _showImageSourceChoice(context);
        },
        child: Container(
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo, size: 40, color: Colors.grey[700]),
              const SizedBox(height: 10),
              Text(
                'Add Proof',
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row addRecordRow(BuildContext context, Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.secondary, // color of the button
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12), // padding inside the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // shape of the button
            ),
          ),
          child: Text('Cancel',
              style: TextStyle(fontSize: 16, color: primaryColor)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        const SizedBox(width: 16), // Add some space between the buttons

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor, // color of the button
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12), // padding inside the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // shape of the button
            ),
          ),
          child: const Text('Add record', style: TextStyle(fontSize: 16)),
          onPressed: () {
            updateTask();
            // Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
