// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cooptourism/data/models/coop_application.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/coopjoin_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class JoinCoopPage extends ConsumerStatefulWidget {
  final String coopId;
  const JoinCoopPage({super.key, required this.coopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinCoopPageState();
}

class _JoinCoopPageState extends ConsumerState<JoinCoopPage> {
  final cooperativeRepository = CooperativesRepository();
  final TextEditingController _reasonController = TextEditingController();
  List<File> uploadedFiles = [];
  List<String> neededFiles = [
    'Valid Government ID',
    'Birth Certificate',
    'Pre-Membership Education Seminar Certificate',
    'Proof of Payment of Membership Fee',
    'Marriage Certificate (if married)',
  ];
  final joinCooperativeRepository = JoinCooperativeRepository();
  final userRepository = UserRepository();

  Future<void> uploadFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      uploadedFiles.addAll(files);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Join Cooperative'),
      body: SingleChildScrollView(
          child: StreamBuilder(
              stream: cooperativeRepository
                  .getCooperative(widget.coopId)
                  .asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final coop = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Center(
                              child: DisplayImage(
                                  path: '${widget.coopId}/images/${coop!.logo}',
                                  height: 120,
                                  width: 120,
                                  radius: BorderRadius.circular(100))),
                          const SizedBox(height: 15),
                          Center(
                            child: Text(
                              coop.name!,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Mabuhay! Welcome to ${coop.name}! We admire your interest in joining our cooperative. Please fill out the form below and we will get back to you as soon as possible.',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'If you wish to join our cooperative, please submit the following requirements: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                itemCount: coop.memberRequirements!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 8);
                                },
                                itemBuilder: (context, index) {
                                  return Text(
                                    ' - ${coop.memberRequirements?[index]}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Text('Uploaded Files: '),
                          const SizedBox(height: 15),
                          uploadedFiles.isEmpty
                              ? const Center(
                                  child: Text('No files uploaded'),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: uploadedFiles.length,
                                  itemBuilder: (context, index) {
                                    String extension = path
                                        .extension(uploadedFiles[index].path)
                                        .toLowerCase();
                                    IconData iconData;

                                    switch (extension) {
                                      case '.jpg':
                                        iconData = Icons.image;
                                        break;
                                      case '.pdf':
                                        iconData = Icons.picture_as_pdf;
                                        break;
                                      case '.doc':
                                        iconData = Icons.picture_as_pdf;
                                        break;
                                      default:
                                        iconData = Icons.image;
                                    }
                                    return ListTile(
                                      leading: Icon(iconData),
                                      title: Text(path
                                          .basename(uploadedFiles[index].path)),
                                    );
                                  },
                                ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                await uploadFiles();
                              },
                              child: const Text('Upload File/s'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Enter your reason for joining our cooperative: ',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: _reasonController,
                              maxLines: 7,
                              decoration: InputDecoration(
                                hintText: 'Enter your reason here...',
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
                          const SizedBox(height: 20),
                          Text(
                            "By clicking the 'Submit' button below, you agree to the terms and conditions of ${coop.name} Cooperative, and you agree to abide by the rules and regulations of the cooperative.",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'You also agree that the information you have provided is true and correct. Your application form will carefully be reviewed by our cooperative. We will get back to you as soon as possible.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (uploadedFiles.isEmpty ||
                                    _reasonController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please fill out all the fields'),
                                    ),
                                  );
                                  return;
                                }
                                final List<String> fileNames = [];
                                User currentUser =
                                    FirebaseAuth.instance.currentUser!;
                                // get user details through user repository
                                final user = await userRepository
                                    .getUser(currentUser.uid);
                                for (final file in uploadedFiles) {
                                  final fileName = path.basename(file.path);
                                  fileNames.add(fileName);
                                }

                                final coopApplication = CooperativeAppFormModel(
                                  coopId: widget.coopId,
                                  coopName: coop.name!,
                                  userUID: currentUser.uid,
                                  firstName: user.firstName,
                                  lastName: user.lastName,
                                  reasonForJoining: _reasonController.text,
                                  status: 'Pending',
                                  coopDocuments: fileNames,
                                  timestamp: DateTime.now(),
                                );

                                await joinCooperativeRepository
                                    .addCoopApplication(coopApplication);
                                for (final file in uploadedFiles) {
                                  final fileName = path.basename(file.path);
                                  final destination =
                                      '${widget.coopId}/appforms/${user.uid}/documents/$fileName';
                                  await firebase_storage
                                      .FirebaseStorage.instance
                                      .ref(destination)
                                      .putFile(file);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Application submitted'),
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        ]),
                  );
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            child: IconButton(
              onPressed: () {
                // showAddPostPage(context);
              },
              icon: const Icon(
                Icons.settings,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
