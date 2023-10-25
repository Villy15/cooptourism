import 'dart:io';

import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/task.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path_utils;

class AddTaskProofPage extends StatefulWidget {
  final ToDoItem item;
  final TaskModel task;
  const AddTaskProofPage({Key? key, required this.item, required this.task}) : super(key: key);

  @override
  AddPostPageState createState() => AddPostPageState();
}

class AddPostPageState extends State<AddTaskProofPage> {
  File? _image;  // This will store the picked image
  File? _pickedFile; // This will store the picked file
  IconData? _pickedFileIcon;



  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      String fileName = path_utils.basename(_image!.path);
      debugPrint("Image: $fileName");

    } else {
      debugPrint('No image selected.');
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
        _pickedFileIcon = getFileIcon();
      });
      debugPrint("Picked file: ${_pickedFile!.path}");
    } else {
      debugPrint('No file selected.');
    }
  }
  
  String get fileExtension {
    if (_pickedFile != null) {
      return path_utils.extension(_pickedFile!.path).toLowerCase();
    }
    return '';
  }

  IconData getFileIcon() {
    switch (fileExtension) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.doc':
      case '.docx':
        return Icons.description;
      // Add other file types and their icons as needed
      default:
        return Icons.insert_drive_file; // default file icon
    }
  }

  Widget displayPickedFile() {
    if (_pickedFile == null) {
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
            Icon(_pickedFileIcon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                path_utils.basename(_pickedFile!.path),
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
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Take a Picture',
                      style: TextStyle(color: primaryColor)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text('Choose a File',
                      style: TextStyle(color: primaryColor)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickFile();
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
      body: SingleChildScrollView (
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

              if (_image != null) ...[
                Align (
                  alignment: Alignment.center,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(_image!),
                      ),
                    ),
                  ),
                ),
              ] else if (_pickedFile != null) ...[
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
                    Icon(Icons.add_a_photo,
                        size: 40, color: Colors.grey[700]),
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
                  backgroundColor: Theme.of(context).colorScheme.secondary, // color of the button
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // padding inside the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // shape of the button
                  ),
                ),
                child: Text('Cancel', style: TextStyle(fontSize: 16, color: primaryColor)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(width: 16), // Add some space between the buttons

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // color of the button
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // padding inside the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // shape of the button
                  ),
                ),
                child: const Text('Add record', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  //TODO add record
                },
              ),
            ],
          );
  }
}
