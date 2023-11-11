import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/providers/market_page_provider.dart';
import 'package:cooptourism/widgets/province_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _image;
  final picker = ImagePicker();
  late UserModel user;
  final userRepository = UserRepository();
  

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
    final cooperativeRepository = CooperativesRepository();
    return Scaffold(
      appBar: _appBar(context, 'Cooperative Enrollment'),
      body: SingleChildScrollView (
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 20),
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
              const ProvinceCityPicker(),
              const SizedBox(height: 20),
              // add submit button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    debugPrint('Submit button pressed.');
                    debugPrint(path.basename(_image!.path));
                    // use CooperativeModel to create a new cooperative
                    CooperativesModel newCoop = CooperativesModel(
                      name: coopNameController.text,
                      profileDescription: coopDescriptionController.text,
                      province: ref.read(marketProvinceProvider),
                      city: ref.read(marketCityProvider),
                      logo: path.basename(_image!.path),
                      profilePicture: path.basename(_image!.path),
                    );

                    // add the new cooperative to the database
                    DocumentReference docRef = await cooperativeRepository.addCooperative(newCoop);

                    String? uid = docRef.id;
                    debugPrint('Cooperative added to database. Cooperative ID is $uid');

                    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance
                    .ref('$uid/images/${path.basename(_image!.path)}');

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
          ),
        ),
      ),
    );
    }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
      style: TextStyle(
      fontSize: 25, color: Theme.of(context).colorScheme.primary)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
