import 'dart:io';
import 'package:cooptourism/core/file_picker.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/widgets/category_picket.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:cooptourism/widgets/type_picker.dart';
import 'package:cooptourism/widgets/province_city_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path_utils;

class AddListing extends ConsumerStatefulWidget {
  const AddListing({super.key});

  @override
  ConsumerState<AddListing> createState() => _AddListingState();
}

class _AddListingState extends ConsumerState<AddListing> {
  String listingType = "Service";
  List<File> uploadedImages = [];
  FilePickerUtility filePickerUtility = FilePickerUtility();
  // String _province = "";
  // String _city = "";
  // String _category = "";
  // String _tourismType = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = true;
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  }

  Future<void> pickImages() async {
    try {
      // Pick multiple image files
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowCompression: true, // This will filter and allow images only
        allowMultiple: true, // Enable multi-selection
      );

      if (result != null) {
        // This is a list of all selected files
        List<PlatformFile> files = result.files;
        // PlatformFile file = result.files.first;

        // Use the files
        // For example, you could update the state to display the images
        setState(() {
          uploadedImages.addAll(files.map((file) => File(file.path!)));
          // uploadedImages = files.map((file) => File(file.path!)).toList(); 
          // uploadedImages.add(File(file.path!));
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      // Handle exception by logging or showing a message to the user
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();

    return WillPopScope(
        onWillPop: () async {
          ref.read(navBarVisibilityProvider.notifier).state = true;
          ref.read(appBarVisibilityProvider.notifier).state = true;
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Add Listing"),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12), // Padding inside the container
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(15), // Makes it circular
                      border: Border.all(
                        color: Colors.grey, // Color of the border
                        width: 1, // Width of the border
                      ),
                    ),
                    child: Form(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text("Title"),
                          border: InputBorder.none, // Removes underline
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null; // Return null if the entered value is valid
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12), // Padding inside the container
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(15), // Makes it circular
                      border: Border.all(
                        color: Colors.grey, // Color of the border
                        width: 1, // Width of the border
                      ),
                    ),
                    child: Form(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text("Description"),
                          border: InputBorder.none, // Removes underline
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null; // Return null if the entered value is valid
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const CategoryPicker(),
                  const SizedBox(height: 5),
                  const TypePicker(),
                  const SizedBox(height: 5),
                  const ProvinceCityPicker(),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12), // Padding inside the container
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(15), // Makes it circular
                      border: Border.all(
                        color: Colors.grey, // Color of the border
                        width: 1, // Width of the border
                      ),
                    ),
                    child: Form(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text("Price"),
                          border: InputBorder.none, // Removes underline
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          return null; // Return null if the entered value is valid
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (uploadedImages.isEmpty)
                    InkWell(
                      onTap: () {
                        pickImages();
                      },
                      child: Container(
                        height: MediaQuery.sizeOf(context).height / 5,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Column(children: [
                          Stack(
                            fit: StackFit.loose,
                            alignment: Alignment.topRight,
                            children: [
                              const Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 90,
                              ),
                              Positioned(
                                top: -10,
                                right: -15,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey[300],
                                  size: 70,
                                ),
                              ),
                            ],
                          ),
                          DisplayText(
                            text: "Add Images",
                            lines: 1,
                            style: Theme.of(context).textTheme.bodySmall!,
                          ),
                        ]),
                      ),
                    ),
                  if (uploadedImages.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      height: 200,
                      child: GridView.builder(
                        // Sets the grid structure
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: uploadedImages.length <= 4
                              ? uploadedImages.length
                              : 4, // Number of columns
                          crossAxisSpacing: 4.0, // Space between columns
                          mainAxisSpacing: 4.0, // Space between rows
                          childAspectRatio: 1,
                        ),
                        itemCount: uploadedImages.length,
                        itemBuilder: (context, index) {
                          return Expanded(
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(uploadedImages[index]),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (uploadedImages.isNotEmpty)
                    InkWell(
                      onTap: () {
                        pickImages();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Column(children: [
                          Stack(
                            fit: StackFit.loose,
                            alignment: Alignment.topRight,
                            children: [
                              const Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 50,
                              ),
                              Positioned(
                                top: -7.5,
                                right: -10,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey[300],
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                          DisplayText(
                            text: "Add Images",
                            lines: 1,
                            style: Theme.of(context).textTheme.bodySmall!,
                          ),
                        ]),
                      ),
                    ),
                  const SizedBox(height: 20),
                  DisplayText(
                    text: "Notes:",
                    lines: 1,
                    style: Theme.of(context).textTheme.headlineSmall!,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        DisplayText(
                          text:
                              "Not all Provinces and Cities are available, We recommend leaving it empty if so.",
                          lines: 2,
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),
                        const SizedBox(height: 5),
                        DisplayText(
                          text:
                              "Images should provide valuable information regarding the service to increase its popularity.",
                          lines: 3,
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),
                        const SizedBox(height: 5),
                        DisplayText(
                          text:
                              "Images are better displayed if their resolution is rectangular in shape (crosswise).",
                          lines: 3,
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 15.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Submit Listing"),
                    ),
                  )
                ],
              ),
            )));
  }

  String? _getProofPath() {
    if (filePickerUtility.image != null) {
      return path_utils.basename(filePickerUtility.image!.path);
    } else if (filePickerUtility.pickedFile != null) {
      return path_utils.basename(filePickerUtility.pickedFile!.path);
    }
    return null;
  }
}
