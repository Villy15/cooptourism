import 'package:cooptourism/core/file_picker.dart';
import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/task.dart';
import 'package:cooptourism/data/repositories/task_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path_utils;

final TaskRepository taskRepository = TaskRepository();

class AddTaskProofPage extends StatefulWidget {
  final ToDoItem item;
  final TaskModel task;
  final int index;
  const AddTaskProofPage(
      {Key? key, required this.item, required this.task, required this.index})
      : super(key: key);

  @override
  AddPostPageState createState() => AddPostPageState();
}

class AddPostPageState extends State<AddTaskProofPage> {
  late FilePickerUtility filePickerUtility;

  @override
  void initState() {
    super.initState();
    debugPrint("Item title: ${widget.item.title}");
    filePickerUtility = FilePickerUtility(
      onImagePicked: _updateImageUI,
      onFilePicked: _updateFileUI,
    );
  }

  void _updateImageUI() => setState(() {});

  void _updateFileUI() => setState(() {});

  Future<void> updateTask(BuildContext context) async {
    try {
      final proofPath = _getProofPath();

      if (proofPath == null) {
        _showSnackBar('Please add a proof first!');
        return;
      }

      await _updateTaskInDatabase(proofPath);
      await _updateTaskInStorage(proofPath);
      _showSnackBar('Task updated successfully!');
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showSnackBar('Error updating task!');
    }
  }

  // Find the index of the item in the list and update it
  Future<void> _updateTaskInDatabase(String proofPath) async {
    final task = widget.task;
    final index = widget.index;
    task.toDoList[index].proof = proofPath;
    await taskRepository.updateTask(widget.task.uid, task);
  }

  Future<void> _updateTaskInStorage(String proofPath) async {
    await taskRepository.uploadFile(
        widget.task.uid, proofPath, filePickerUtility);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: Text('Add Proof',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaskTitle(primaryColor),
              const SizedBox(height: 16),
              _buildContent(primaryColor),
              const SizedBox(height: 16),
              _addRecordRow(context, primaryColor),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildTaskTitle(Color primaryColor) {
    return Text(widget.item.title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold));
  }

  Widget _buildContent(Color primaryColor) {
    if (filePickerUtility.image != null) {
      return _buildImageContent();
    } else if (filePickerUtility.pickedFile != null) {
      return _displayPickedFile();
    }
    return _imagePlaceHolder(primaryColor);
  }

  Widget _addRecordRow(BuildContext context, Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _cancelButton(context, primaryColor),
        const SizedBox(width: 16),
        if (filePickerUtility.image != null ||
            filePickerUtility.pickedFile != null ||
            widget.item.proof == null ||
            widget.item.proof == '')
          _addRecordButton()
        else ...[_changeRecordButton(primaryColor)]
      ],
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  String? _getProofPath() {
    if (filePickerUtility.image != null) {
      return path_utils.basename(filePickerUtility.image!.path);
    } else if (filePickerUtility.pickedFile != null) {
      return path_utils.basename(filePickerUtility.pickedFile!.path);
    }
    return null;
  }

  Widget _buildImageContent() {
    return Align(
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
    );
  }

  Widget _displayPickedFile() {
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
                blurRadius: 5)
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
                      color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceHolder(Color primaryColor) {
    final storageRef = FirebaseStorage.instance.ref();
    String imagePath = "tasks/${widget.item.proof}";

    return FutureBuilder(
      future: storageRef.child(imagePath).getDownloadURL(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while waiting
        } else if (snapshot.hasError) {
          return _buildPlaceholder(
              primaryColor); // Show placeholder if error occurred
        } else {
          return _buildImage(snapshot.data); // Show image if it exists
        }
      },
    );
  }

  Widget _buildPlaceholder(Color primaryColor) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => _showImageSourceChoice(context),
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
                  blurRadius: 5)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo, size: 40, color: Colors.grey[700]),
              const SizedBox(height: 10),
              const Text('Add Proof',
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 250,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }

  Widget _cancelButton(BuildContext context, Color primaryColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Cancel',
          style: TextStyle(
            fontSize: 16,
          )),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _addRecordButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () => updateTask(context),
      child: const Text('Add record', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _changeRecordButton(Color primaryColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () => _showImageSourceChoice(context),
      child: const Text('Change record', style: TextStyle(fontSize: 16)),
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
}
