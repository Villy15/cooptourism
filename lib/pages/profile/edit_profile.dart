import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:email_otp/email_otp.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final String profileId;
  const EditProfilePage({Key? key, required this.profileId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _profileBioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final userRepository = UserRepository();
  File? _image;
  final picker = ImagePicker();
  EmailOTP emailAuth = EmailOTP();


  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        debugPrint('Image selected. Image is $pickedFile and $_image');
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Edit Profile'),
      body: SingleChildScrollView (
        child: 
            FutureBuilder<UserModel>(
              future: userRepository.getUser(widget.profileId),
              builder: (context, snapshot) {
                debugPrint(widget.profileId);
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  debugPrint('user is $user');
                  if (user?.firstName == 'Customer' && user?.role == 'Customer') {
                    debugPrint(user?.emailStatus);
                    return customerSignUp(context, user!);
                  }
                  else {
                    return const Column();
                  }
                }
                else {
                  return const Center(child: CircularProgressIndicator());
                
                }
              }
            )
      ),
    );
  }

  Padding customerSignUp(BuildContext context, UserModel user) {
    return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: getImage,
                            child: Container(
                              width: 120.0,
                              height: 120.0,
                              decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.secondary,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3.0,
                              )
                            ),
                            child: Stack(
                              children: [
                                if (_image != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(60.0),
                                  child: Image.file(
                                    _image!,
                                    width: 120.0,
                                    height: 120.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (_image == null)
                                  Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 60.0,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                
                                Positioned(
                                  right: 2,
                                  bottom: 0,
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 20.0,
                                      color: Theme.of(context).colorScheme.primary
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Enter Personal Information',
                            style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: Text(
                            'We wish to know you better. Please enter your personal information below. This is for the sole purpose of the cooperative/s you will be enrolling to. We respect your privacy and will not share your personal information with anyone.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          'Enter your first name:',
                          style: TextStyle(
                            fontSize: 19,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Enter your last name:',
                          style: TextStyle(
                            fontSize: 19,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Enter a suitable description for your profile:',
                          style: TextStyle(
                            fontSize: 19,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          child: TextFormField(
                            controller: _profileBioController,
                            decoration: const InputDecoration(
                              labelText: 'Bio',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Enter your location:',
                          style: TextStyle(
                            fontSize: 19,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_lastNameController != null) {
                                final UserModel newUser = UserModel(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                bio: _profileBioController.text,
                                location: _locationController.text,
                                email: user.email,
                                emailStatus: user.emailStatus,
                                role: user.role,
                                profilePicture: path.basename(_image!.path),
                                                              );
                              await userRepository.updateUser(widget.profileId, newUser);

                              firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance
                              .ref('${widget.profileId}}/images/${path.basename(_image!.path)}');

                              firebase_storage.UploadTask uploadTask = reference.putFile(_image!);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Personal information updated successfully!'),
                                ),
                                
                              );

                              Navigator.pop(context);
                              }
                              else {
                                debugPrint('All fields are not filled');

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All fields are not filled!'),
                                  ),
                                );
                              }
                              

                              
                            },
                            child: const Text('Save'),
                          ),
                        ),

                        const SizedBox(height: 90)
                      ],
                    ),
                  );
  }

   AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                // showAddPostPage(context);
              },
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}