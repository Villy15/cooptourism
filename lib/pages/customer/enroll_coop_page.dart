// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/widgets/coop_province_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EnrollCoopPage extends ConsumerStatefulWidget {
  final String profileId;
  const EnrollCoopPage({Key ? key, required this.profileId}) : super (key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EnrollCoopPageState();
}

class _EnrollCoopPageState extends ConsumerState<EnrollCoopPage> {
  TextEditingController coopNameController = TextEditingController();
  TextEditingController coopDescriptionController = TextEditingController();
  // list of managers controller
  List<TextEditingController> managerEmailControllers = [TextEditingController()];
  List<TextEditingController> managerNameControllers = [TextEditingController()];
  TextEditingController membershipFeeController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  late UserModel user;
  final userRepository = UserRepository();
  String? selectedProvince;
  String? selectedCity;
  final cooperativeRepository = CooperativesRepository();
  final List<String> cooperativeTypes = [
    'Agricultural',
    'Consumer',
    'Credit',
    'Housing',
    'Marketing',
    'Multipurpose',
    'Producers',
    'Service',
    'Transport',
    
  ];
  String? selectedType;
  List<TextEditingController> memberReqsController = [TextEditingController()];

  
  
  void onSelectionChanged(String? province, String? city) {
    setState(() {
      selectedProvince = province;
      selectedCity = city;
    });
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
    debugPrint(widget.profileId);
    
    return Scaffold(
      appBar: _appBar(context, 'Cooperative Enrollment'),
      body: SingleChildScrollView (
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: enrollCoop(context, cooperativeRepository),
        ),
      ),
    );
    }

  Column enrollCoop(BuildContext context, CooperativesRepository cooperativeRepository) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              'Enter the name of the cooperative: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                controller: coopNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Cooperative Name...',
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Enter a short description of the cooperative and its operations: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                controller: coopDescriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Description of the cooperative...',
                ),
                maxLines: 7,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select the type of cooperative: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary
              ),
            ),
            Center(
              child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: PopupMenuButton<String>(
                  onSelected: (String? value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return cooperativeTypes.map((String value) {
                      return PopupMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList();
                  },
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              selectedType ?? 'Select cooperative type',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                                fontSize: 17
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ),
            const SizedBox(height: 5),
            Text(
              'Insert image / logo of the cooperative: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary
              ),
            ),
            const SizedBox(height: 10),
            _image == null
            ? Center(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1.5,
                        style: BorderStyle.solid,
                        color: Theme.of(context).colorScheme.secondary
                      ),
                    ),
                    child: Icon(
                      Icons.image, 
                      size: 100,
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                      onPressed: getImage,
                      child: const Text('Choose Image'),
                    ),
                ],
              ),
            )
            : Center(
              child: Image.file(
                _image!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Choose the province and city of the cooperative: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary
              ),
            ),
            const SizedBox(height: 10),
            CoopProvinceCityPicker(
              onSelectionChanged: onSelectionChanged,
            ),
            const SizedBox(height: 20),

            Text(
              'Indicate who the manager/s of the cooperative will be: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary
              ),
            ),

            const SizedBox(height: 20),
            Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: managerEmailControllers.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(
                          'Manager ${index + 1}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.primary
                          ),
                        ),
                        TextFormField(
                          controller: managerNameControllers[index],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Manager's full name...",
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: managerEmailControllers[index],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Manager email...',
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
                TextButton(
                  child: Text(
                    'Add another email',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  onPressed: () {
                    setState(() {
                      managerEmailControllers.add(TextEditingController());
                      managerNameControllers.add(TextEditingController());
                    });
                  },
                ),
                const SizedBox(height: 5),
                Text(
                  'Take note that the managers indicated here will be given direct access to the cooperative\'s profile. They will be able to login their accounts and manage the cooperative.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary
                  )
                )
              ],
            ),

            const SizedBox(height: 20),

            Text(
              'Enter the membership fee of the cooperative: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                controller: membershipFeeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter membership fee...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  final number = double.tryParse(value);
                  if (number == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Enter the membership requirements of the cooperative: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary
              ),
            ),

            const SizedBox(height: 10),


            Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: memberReqsController.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: memberReqsController[index],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter member requirement here...',
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
                TextButton(
                  child: Text(
                    'Add another requirement',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  onPressed: () {
                    setState(() {
                      memberReqsController.add(TextEditingController());
                    });
                  },
                ),
                
              ],
            ),

            const SizedBox(height: 20),

            // add submit button

            Center(
              child: Text(
                'Upon submitting, you will be appointed as one of the managers of the application. You will be able to login your account and manage the cooperative.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary
                )
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // use CooperativeModel to create a new cooperative
                  CooperativesModel newCoop = CooperativesModel(
                    name: coopNameController.text,
                    profileDescription: coopDescriptionController.text,
                    province: selectedProvince,
                    city: selectedCity,
                    logo: path.basename(_image!.path),
                    profilePicture: path.basename(_image!.path),
                    cooperativeType: selectedType,
                    membershipFee: double.parse(membershipFeeController.text),
                    memberRequirements: memberReqsController.map((e) => e.text).toList(),


                  );

                  // add the new cooperative to the database
                  DocumentReference docRef = await cooperativeRepository.addCooperative(newCoop);

                  String? uid = docRef.id;
                  debugPrint('Cooperative added to database. Cooperative ID is $uid');
                  // current date
                  DateTime now = DateTime.now();

                  // Formate the date as a string
                  String dateJoined = DateFormat('MMMM dd, yyyy').format(now);

                  // add managers to the cooperative
                  // store names and emails of the user to user model
                  FirebaseFirestore firestore = FirebaseFirestore.instance;

                  for (int i = 0; i < managerEmailControllers.length; i++) {
                    String email = managerEmailControllers[i].text;
                    String name = managerNameControllers[i].text;
                    List<String> nameParts = name.split(' ');
                    String firstName = nameParts.first;
                    String lastName = nameParts.last;
                    
                    // search for the user in the database
                    QuerySnapshot querySnapshot = await firestore.collection('users').where('email', isEqualTo: email).get();
                    
                    // if user exists, update the user's role to manager and add the user to the cooperative
                    if (querySnapshot.docs.isNotEmpty) {
                      debugPrint('User exists');
                      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
                      String userId = documentSnapshot.id;
                      UserModel user = UserModel(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        role: 'Manager',
                        profilePicture: '',
                        emailStatus: 'Verified',
                        dateJoined: dateJoined,

                        
                      );
                      userRepository.updateUser(userId, user);
                      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);
                      await FirebaseFirestore.instance.collection('cooperatives').doc(uid).update({
                        'managers': FieldValue.arrayUnion([userRef])
                      });
                    }
                    else {
                      // if user does not exist, it will not submit. warn the current user enrolling the cooperative that the user does not exist. they should be enrolled
                      // in the application first before they can be added as a manager of the cooperative
                      debugPrint('User does not exist');
                      // show dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('User does not exist'),
                          content: const Text('The user you are trying to add as a manager does not exist. Please enroll the user in the application first before adding them as a manager.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            )
                          ],
                        )
                      );
                      return;
                    }
                  }


                  firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance
                  .ref('$uid/images/${path.basename(_image!.path)}');

                  // ignore: unused_local_variable
                  firebase_storage.UploadTask uploadTask = reference.putFile(_image!);

                  
                  // get user 
                  user = await userRepository.getUser(widget.profileId);
                  user.role = "Manager";
                  userRepository.updateUser(widget.profileId, user);

                  DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(widget.profileId);
                  await FirebaseFirestore.instance.collection('cooperatives').doc(uid).update({
                    'managers': FieldValue.arrayUnion([userRef])
                  });
                  // add a prompt to show that the cooperative has been added
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cooperative added successfully!'),
                    ),
                  );
                  
                  // close the page
                  GoRouter.of(context).go('/profile_page/${widget.profileId}');
                },
                child: const Text('Submit'),
              ),
            ),

            const SizedBox(height: 125)
          ],
        );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
      style: TextStyle(
      fontSize: 25, color: Theme.of(context).colorScheme.primary)),
      
    );
  }
}
