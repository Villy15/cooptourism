import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path_utils;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerUtility {
  final VoidCallback? onImagePicked;
  final VoidCallback? onFilePicked;

  FilePickerUtility({this.onImagePicked, this.onFilePicked});

  File? _image;  // This will store the picked image
  File? _pickedFile; // This will store the picked file
  IconData? _pickedFileIcon;

  File? get image => _image;
  File? get pickedFile => _pickedFile;
  IconData? get pickedFileIcon => _pickedFileIcon;

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      _image = File(pickedImage.path);
      
      onImagePicked?.call();

      String fileName = path_utils.basename(_image!.path);
      debugPrint('Image picked: $fileName');

    } else {
      debugPrint('No image selected.');
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _pickedFile = File(result.files.single.path!);
      _pickedFileIcon = _getFileIcon();
      
      onFilePicked?.call();

      String fileName = path_utils.basename(_pickedFile!.path);
      debugPrint('File picked: $fileName');
      
    } else {
      debugPrint('No file selected.');
    }
  }
  
  String get _fileExtension {
    if (_pickedFile != null) {
      return path_utils.extension(_pickedFile!.path).toLowerCase();
    }
    return '';
  }

  IconData _getFileIcon() {
    switch (_fileExtension) {
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
}
