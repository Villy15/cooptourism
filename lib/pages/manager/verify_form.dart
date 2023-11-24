// ignore_for_file: use_build_context_synchronously

// import 'dart:ffi';

import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/coopjoin_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/pages/manager/view_img.dart';
import 'package:cooptourism/pages/manager/view_pdf.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class VerifyFormPage extends ConsumerStatefulWidget {
  final String coopAppId;
  const VerifyFormPage({
    Key? key,
    required this.coopAppId,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerifyFormPageState();
}

class _VerifyFormPageState extends ConsumerState<VerifyFormPage> {
  final userRepository = UserRepository();
  final joinCooperativeRepository = JoinCooperativeRepository();
  final cooperativesRepository = CooperativesRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'App Form'),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future:
              joinCooperativeRepository.getCoopApplication(widget.coopAppId),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final coopApp = snapshot.data;
              debugPrint('coopApp: $coopApp');
              return FutureBuilder(
                  future: userRepository.getUser(coopApp['userUID']),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userData = snapshot.data!;
                      debugPrint('userData: $userData');
                      if (userData.uid != null &&
                          userData.profilePicture != null) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              Center(
                                child: DisplayImage(
                                    path:
                                        'users/${userData.email}/${userData.profilePicture}',
                                    height: 120,
                                    width: 120,
                                    radius: BorderRadius.circular(60)),
                              ),
                              const SizedBox(height: 15),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                        '${userData.firstName} ${userData.lastName}',
                                        style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold)),
                                    const Text('Aspiring Member',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ))
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Reason for joining ${coopApp['coopName']}:",
                                          style: const TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              coopApp['reasonForJoining'],
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ),
                                    ]),
                              ),
                              const SizedBox(height: 15),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('Documents Uploaded: ',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold)),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: coopApp['coopDocuments'].length,
                                itemBuilder: (context, index) {
                                  final fileName =
                                      coopApp['coopDocuments'][index];
                                  return FutureBuilder<String>(
                                      future: FirebaseStorage.instance
                                          .ref(
                                              '${coopApp['coopId']}/appforms/${coopApp['userUID']}/documents/$fileName')
                                          .getDownloadURL(),
                                      builder: ((context, snapshot) {
                                        if (snapshot.hasData) {
                                          final fileURL = snapshot.data;
                                          final fileExtension = p
                                              .extension(fileName)
                                              .toLowerCase();
                                          debugPrint(
                                              "$fileExtension is the file extension");
                                          return InkWell(
                                            onTap: () async {
                                              if (fileExtension == '.pdf') {
                                                final Dio dio = Dio();

                                                final dir =
                                                    await getApplicationDocumentsDirectory();
                                                final path =
                                                    '${dir.path}/$fileName';

                                                final response = await dio
                                                    .download(fileURL!, path);
                                                if (response.statusCode ==
                                                    200) {
                                                  debugPrint('Downloaded');
                                                }

                                                debugPrint(
                                                    '$path this is the path');

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewPDFPage(path: path),
                                                  ),
                                                );
                                              } else if (fileExtension ==
                                                      '.png' ||
                                                  fileExtension == '.jpg' ||
                                                  fileExtension == '.jpeg') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewImagePage(
                                                            url: fileURL!),
                                                  ),
                                                );
                                              } else {
                                                debugPrint(
                                                    'File type not supported');
                                              }
                                            },
                                            child: SizedBox(
                                              height: 40,
                                              child: ListTile(
                                                title: Text(fileName,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                leading: Icon(Icons.file_copy,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                                trailing: Icon(Icons.download,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                              ),
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return const Center(
                                              child: Text('Error'));
                                        } else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      }));
                                },
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Text('NOTE: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                    const SizedBox(height: 10),
                                    Text(
                                        'Accepting this application will add ${userData.firstName} ${userData.lastName} to the ${coopApp['coopName']} cooperative. Please review the documents submitted by the applicant and accept or decline the application.',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400)),
                                    const SizedBox(height: 15),
                                    const Text(
                                        'Please review each document submitted by the applicant and verify that it is valid. If the document is not valid, please decline the application to not add the applicant to the cooperative.',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 15),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          userData.role = 'Member';
                                          userData.cooperativesJoined
                                              ?.add(coopApp['coopId']);

                                          await userRepository.updateUser(
                                              userData.uid!, userData);
                                          await cooperativesRepository
                                              .addCooperativeMember(
                                                  coopApp['coopId'],
                                                  userData.uid!,
                                                  userData);
                                          await joinCooperativeRepository
                                              .approveCoopApplication(
                                                  widget.coopAppId);

                                          const SnackBar(
                                            content:
                                                Text('Application accepted'),
                                            duration: Duration(seconds: 2),
                                          );
                                          Navigator.of(context).pop();
                                        } catch (e) {
                                          debugPrint('Error: $e');
                                        }
                                      },
                                      child: const Text('Accept')),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                      onPressed: () async {
                                        await joinCooperativeRepository
                                            .deleteCoopApplication(
                                                widget.coopAppId);

                                        const SnackBar(
                                          content: Text('Application accepted'),
                                          duration: Duration(seconds: 2),
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Decline')),
                                ],
                              ),

                              const SizedBox(height: 100)

                              // Text('${userData.firstName} ${userData.lastName}'),
                              // Text('${userData.uid}/images/${userData.profilePicture}')
                            ]);
                      } else {
                        return const Text('User data is incomplete');
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  });
              // return Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     const SizedBox(height: 15),
              //     // Text(
              //     //   coopApp['firstName'] + ' ' + coopApp['lastName'],
              //     //   style: TextStyle(
              //     //     color: Theme.of(context).colorScheme.primary,
              //     //     fontSize: 20,
              //     //     fontWeight: FontWeight.bold
              //     //   )
              //     // ),

              //     // ListView.builder(
              //     //     physics: const NeverScrollableScrollPhysics(),
              //     //     shrinkWrap: true,
              //     //     itemCount: coopApp['coopDocuments'].length,
              //     //     itemBuilder: (context, index) {
              //     //       final fileName = coopApp['coopDocuments'][index];
              //     //       return ListTile(
              //     //         title: Text(fileName),
              //     //         leading: const Icon(Icons.file_copy),
              //     //       );
              //     //     },
              //     //   ),
              //   ]
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
    );
  }
}
