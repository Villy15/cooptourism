// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:email_otp/email_otp.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final String profileId;
  const EditProfilePage({Key? key, required this.profileId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _profileBioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  List<String> userSkills = [];

  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _otpController = TextEditingController();

  String userUID = '';

  Map<String, bool> checkedSkills = {};

  final List<String> _skills = [
    'Driver',
    'Tour Guide',
    'Tour Accommodation',
    'Credit Collector',
    'Quality Cooperative',
    'Cook',
    'Event Organizer',
    'Translator',
    'Photographer',
    'Social Media Manager',
    'Customer Service Representative',
  ];

  bool checkedSkillsInitialized = false;

  final List<String> _skillsManager = [
    'Team Management',
    'Leadership',
    'Strategic Planning',
    'Financial Management',
    'Marketing',
    'Human Resources',
    'Project Management',
    'Communication Skills',
    'Problem Solving',
    'Decision Making',
  ];

  @override
  void initState() {
    super.initState();
    // postRepository.addDummyPost();
    userUID = widget.profileId.replaceAll(RegExp(r'}+$'), '');
    final user = ref.read(userModelProvider);
    _profileBioController.text = user?.bio ?? '';
    _locationController.text = user?.location ?? '';
    userSkills = user!.skills!;

    // initialize checkedSkills with the skills of the user
    // check the user role and initialize the skills accordingly
    checkedSkills = {
      for (var skill in (user.role == 'Manager' ? _skillsManager : _skills))
        skill: userSkills.contains(skill),
    };
  }

  bool isNewImageSelected = false;

  final userRepository = UserRepository();
  File? _image;
  final picker = ImagePicker();
  EmailOTP emailAuth = EmailOTP();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        isNewImageSelected = true;
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Edit Profile'),
      body: SingleChildScrollView(
          child: FutureBuilder<UserModel>(
              future: userRepository.getUser(widget.profileId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  if (!checkedSkillsInitialized) {
                    checkedSkills = {
                      for (var skill in user?.role == 'Manager'
                          ? _skillsManager
                          : user?.role == 'Member'
                              ? _skills
                              : _skills)
                        skill: userSkills.contains(skill),
                    };
                    checkedSkillsInitialized =true;
                  }

                  if (user?.firstName == 'Customer' &&
                      user?.role == 'Customer') {
                    return customerSignUp(context, user!);
                  } else if (user?.role == 'Customer') {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 3.0,
                                    )),
                                child: Stack(
                                  children: [
                                     if (_image != null &&
                                        isNewImageSelected) ...[
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        child: Image.file(
                                          _image!,
                                          width: 120.0,
                                          height: 120.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ]
                                    else if (user?.profilePicture != null)
                                      DisplayImage(
                                          path:
                                              '${user!.uid}/images/${user.profilePicture}',
                                          height: 120,
                                          width: 120,
                                          radius: BorderRadius.circular(100))
                                    else if (user?.profilePicture == null)
                                      Center(
                                        child: Icon(
                                          Icons.person,
                                          size: 60.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        child: Icon(Icons.camera_alt,
                                            size: 20.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                  ],
                                ),
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
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: _profileBioController,
                              maxLines: 7,
                              decoration: InputDecoration(
                                hintText: _profileBioController.text.isEmpty
                                    ? 'Profile Bio'
                                    : _profileBioController.text,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2.0,
                                  ),
                                ),
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
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 3.0,
                                      )),
                                  child: Stack(
                                    children: [
                                      if (_image != null &&
                                        isNewImageSelected) ...[
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        child: Image.file(
                                          _image!,
                                          width: 120.0,
                                          height: 120.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ]
                                    else if (user?.profilePicture != null)
                                        DisplayImage(
                                            path:
                                                '${user!.uid}/images/${user.profilePicture}',
                                            height: 120,
                                            width: 120,
                                            radius: BorderRadius.circular(100))
                                      else if (user?.profilePicture == null)
                                        Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 60.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          child: Icon(Icons.camera_alt,
                                              size: 20.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),
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
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                controller: _profileBioController,
                                maxLines: 7,
                                decoration: InputDecoration(
                                  hintText: _profileBioController.text.isEmpty
                                      ? 'Profile Bio'
                                      : _profileBioController.text,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2.0,
                                    ),
                                  ),
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
                            Text(
                              'Choose skill/s that best describe you:',
                              style: TextStyle(
                                fontSize: 19,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Column(
                              children: (user?.role == 'Manager'
                                      ? _skillsManager
                                      : user?.role == 'Member'
                                          ? _skills
                                          : _skills)
                                  .map((skill) {
                                if (!checkedSkills.containsKey(skill)) {
                                  debugPrint(
                                      "checkedSkills doesn't contain $skill");
                                  checkedSkills[skill] = false;
                                }
                                return CheckboxListTile(
                                  title: Text(skill),
                                  value: checkedSkills.containsKey(skill) ? checkedSkills[skill] ?? false : false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkedSkills[skill] = value ?? false;
                                    });
                                    debugPrint('checkedSkills is $checkedSkills');
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    // update the changes the user made
                                    String oldProfilePicture = user?.profilePicture ?? '';
                                    final UserModel newUser = UserModel(
                                      firstName: user?.firstName,
                                      lastName: user?.lastName,
                                      bio: _profileBioController.text,
                                      location: _locationController.text,
                                      email: user?.email,
                                      emailStatus: user?.emailStatus,
                                      role: user?.role,
                                      skills: checkedSkills.keys
                                          .where((skill) =>
                                              checkedSkills[skill] ?? false)
                                          .toList(),
                                      profilePicture: path.basename(
                                          _image?.path ?? oldProfilePicture),
                                    );
                                    await userRepository.updateUser(userUID, newUser);

                                    if (_image != null) {
                                      firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance
                                      .ref('$userUID/images/${path.basename(_image!.path)}');

                                      // ignore: unused_local_variable
                                      firebase_storage.UploadTask uploadTask = reference.putFile(_image!);
                                    }
                                    context.go('/profile_page/${user?.uid}');
                                  },
                                  child: const Text('Submit')),
                            ),
                            const SizedBox(height: 100)
                          ]),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })),
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
                    )),
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
                        child: Icon(Icons.camera_alt,
                            size: 20.0,
                            color: Theme.of(context).colorScheme.primary),
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
              maxLines: 5,
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
                // ignore: unnecessary_null_comparison
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
                  await userRepository.updateUser(userUID, newUser);

                  firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance
                  .ref('${widget.profileId}/images/${path.basename(_image!.path)}');

                  // ignore: unused_local_variable
                  firebase_storage.UploadTask uploadTask = reference.putFile(_image!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Personal information updated successfully!'),
                    ),
                  );

                  context.go('/profile_page/${user.uid}');
                } else {
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
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
    );
  }
}
