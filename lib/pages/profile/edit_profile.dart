import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:email_auth/email_auth.dart';

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
  EmailAuth emailAuth = EmailAuth(sessionName: "Email Verification");

  @override
  void initState() {
    super.initState();
    
  }


  void sendOTP() async {
    var res = await emailAuth.sendOtp(
      recipientMail: _emailController.value.text,
      otpLength: 6,
    );

    if (res) {
      debugPrint('OTP sent');
    }
    else {
      debugPrint('OTP not sent');
    }
  }

  void verifyOTP() async {
    var res = emailAuth.validateOtp(recipientMail: _emailController.value.text, userOtp: _otpController.value.text);

    if (res) {
      debugPrint('OTP verified');
    }
    else {
      debugPrint('OTP not verified');
    }
  }

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
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Icon(
                                Icons.mark_email_read,
                                size: 70,
                                color: Theme.of(context).colorScheme.secondary
                              )
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Email Verification',
                              style: TextStyle(
                                fontSize: 22,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'We need to verify your email address to continue. We will send you an email with a link to verify your email address.',
                            style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'This is to ensure that you will be of service to the cooperative/s you will be enrolling to. We respect your privacy and will not share your email address with anyone.',
                            style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 45),
                          Text(
                            'Enter your email address: ',
                            style: TextStyle(
                              fontSize: 19,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Email Address...',
                                suffixIcon: TextButton(
                                  onPressed: sendOTP,
                                  child: const Text('Send OTP'),
                                )
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    );
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

  Padding customerSignUp(BuildContext context) {
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
                            'Email Verification',
                            style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Enter your email address: ',
                          style: TextStyle(
                            fontSize: 19,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),

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
                              final UserModel newUser = UserModel(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                bio: _profileBioController.text,
                                location: _locationController.text,
                              );
                              await userRepository.updateUser(widget.profileId, newUser);
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ),
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