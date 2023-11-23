import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/core/file_picker.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/models/task.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/providers/market_page_provider.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:cooptourism/widgets/category_picker.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:cooptourism/widgets/type_picker.dart';
import 'package:cooptourism/widgets/listing_province_city_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_stepper/stepper.dart';
import 'package:path/path.dart' as path;
// import 'package:path/path.dart' as path_utils;

class AddListing extends ConsumerStatefulWidget {
  const AddListing({super.key});

  @override
  ConsumerState<AddListing> createState() => _AddListingState();
}

class _AddListingState extends ConsumerState<AddListing> {
  String listingType = "Service";
  List<File> uploadedImages = [];
  List<String> fileNames = [];
  FilePickerUtility filePickerUtility = FilePickerUtility();
  Map<String, List<String>> roles = {};
  int roleCount = 0;
  int taskCount = 0;
  List<ToDoItem> tasks = [];
  List<String> cooperativeNames = [];
  List<String> memberNames = [];
  List<String> selectedMemberName = [];
  List<String> selectedRole = [];
  List<TextEditingController> roleController = [];
  List<TextEditingController> taskRoleController = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController paxController = TextEditingController();
  FocusNode titleFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode paxFocus = FocusNode();
  List<FocusNode> roleFocus = [];
  List<FocusNode> taskFocus = [];
  int activeStep = 0;
  int upperBound = 6;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = true;
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  }

  void _saveField(FocusNode node, Function save) {
    if (!node.hasFocus) {
      save();
    }
  }

  void setMemberNames(List<String> names) {
    setState(() {
      memberNames = names;
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

        // Use the files
        // For example, you could update the state to display the images
        setState(() {
          uploadedImages.addAll(files.map((file) => File(file.path!)));
          for (var element in files) {
            fileNames.add(element.name);
          }
          // uploadedImages = files.map((file) => File(file.path!)).toList();
          // uploadedImages.add(File(file.path!));
        });

        ref.read(marketAddListingProvider.notifier).setAddListing(
              ref.watch(marketAddListingProvider)!.copyWith(images: fileNames),
            );
      } else {
        // User canceled the picker
      }
    } catch (e) {
      // Handle exception by logging or showing a message to the user
      debugPrint(e.toString());
    }
  }

  uploadImage() async {
    final firebaseStorage = FirebaseStorage.instance.ref();
    if (ref.watch(marketAddListingProvider)!.images != null) {
      for (var image in uploadedImages) {
        await firebaseStorage
            .child(
                "${ref.watch(marketAddListingProvider)!.cooperativeOwned!}/listingImages/${path.basename(image.path)}")
            .putFile(image);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final storageRef = FirebaseStorage.instance.ref();

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        ref.read(navBarVisibilityProvider.notifier).state = true;
        ref.read(appBarVisibilityProvider.notifier).state = true;
        ref.invalidate(marketCitiesProvider);
        ref.invalidate(marketProvinceProvider);
        ref
            .read(marketAddListingProvider.notifier)
            .setAddListing(ListingModel());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Listing',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.primary),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              IconStepper(
                stepColor: Colors.grey[400],
                activeStepColor: Colors.grey[800],
                enableNextPreviousButtons: false,
                icons: const [
                  Icon(
                    Icons.description_outlined,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.pin_drop_outlined,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.people_alt_outlined,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.task_rounded,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.summarize,
                    color: Colors.white,
                  ),
                ],

                // activeStep property set to activeStep variable defined above.
                activeStep: activeStep,

                // This ensures step-tapping updates the activeStep.
                onStepReached: (index) {
                  setState(() {
                    activeStep = index;
                  });
                },
              ),
              header(),
              const SizedBox(height: 5),
              stepForm(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget nextButton() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 12.5,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15), // Adjust this value as needed
          ),
        ),
        onPressed: () {
          // Increment activeStep, when the next button is tapped. However, check for upper bound.
          if (activeStep < upperBound) {
            setState(() {
              activeStep++;
            });
          }
        },
        child: const Text('Next Step'),
      ),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: const Text('Prev'),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              headerText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Location';

      case 2:
        return 'Category and Type';

      case 3:
        return 'Assign Roles';

      case 4:
        return 'Assign Tasks';

      case 5:
        return 'Review';

      default:
        return 'Details';
    }
  }

  Widget stepForm() {
    switch (activeStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListingProvinceCityPicker(),
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
                ],
              ),
            ),
            const SizedBox(height: 10),
            nextButton(),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CategoryPicker(),
            const SizedBox(height: 5),
            const TypePicker(),
            const SizedBox(height: 5),
            const SizedBox(height: 10),
            nextButton(),
            const SizedBox(height: 20),
            DisplayText(
              text: "Notes:",
              lines: 1,
              style: Theme.of(context).textTheme.headlineSmall!,
            ),
          ],
        );

      case 3:
        final CooperativesRepository cooperativesRepository =
            CooperativesRepository();
        Future<List<String>> getCooperativeMembersNames;
        if (ref.watch(marketAddListingProvider)!.cooperativeOwned == null) {
          getCooperativeMembersNames =
              cooperativesRepository.getCooperativeMembersNames(
                  ref.watch(userModelProvider)!.cooperativesJoined![0]);
        } else {
          getCooperativeMembersNames =
              cooperativesRepository.getCooperativeMembersNames(ref
                      .watch(userModelProvider)!
                      .cooperativesJoined![
                  cooperativeNames.indexOf(
                      ref.watch(marketAddListingProvider)!.cooperativeOwned!)]);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: roleCount,
              itemBuilder: (context, roleIndex) {
                /// All of this is used to prepare the textfield for input such as focusing on the textfield when it is created and then saving it when focus is lost
                roleFocus.add(FocusNode());
                roleFocus[roleIndex].addListener(() {
                  _saveField(roleFocus[roleIndex], () {
                    if (roles.containsKey(roleController[roleIndex].text) ==
                        false) {
                      roles.addAll({roleController[roleIndex].text: []});
                    }
                    ref.read(marketAddListingProvider.notifier).setAddListing(
                          ref
                              .watch(marketAddListingProvider)!
                              .copyWith(roles: roles),
                        );
                  });
                });
                roleController.add(TextEditingController());
                if (roleController[roleIndex].value.text.isEmpty) {
                  roleFocus[roleIndex].requestFocus();
                }

                /// end
                return Column(
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      height: 75,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width / 2,
                            padding: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: Form(
                              key: Key(roleCount.toString()),
                              child: TextFormField(
                                controller: roleController[roleIndex],
                                focusNode: roleFocus[roleIndex],
                                onTapOutside: (downEvent) {
                                  FocusScope.of(context).unfocus();
                                },
                                maxLines: null,
                                decoration: const InputDecoration(
                                  label: Text("Role"),
                                  border: InputBorder.none, // Removes underline
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a role name';
                                  }
                                  return null; // Return null if the entered value is valid
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                              child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Adjust this value as needed
                              ),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 350,
                                    child: FutureBuilder(
                                      future: getCooperativeMembersNames,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text(
                                              'Error loading data');
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // Return shirnk or no widget
                                          return const SizedBox.shrink();
                                        }

                                        final members = snapshot.data;
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: members?.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0.0),
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      onTap: () {
                                                        setState(() {
                                                          roles[roleController[
                                                                      roleIndex]
                                                                  .text]!
                                                              .add(members[
                                                                  index]);
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      title: Text(
                                                        members![index],
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            fontWeight: Theme
                                                                    .of(context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .fontWeight),
                                                      ),
                                                    ),
                                                    const Divider(
                                                      thickness: 1,
                                                      indent: 20,
                                                      endIndent: 20,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                const Text("Member"),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                    if (roles[roleController[roleIndex].text] != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                roles[roleController[roleIndex].text]!.length,
                            itemBuilder: (context, memberIndex) {
                              return Container(
                                margin: const EdgeInsets.only(left: 50),
                                height: MediaQuery.sizeOf(context).height / 15,
                                width: MediaQuery.sizeOf(context).width / 2,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      size: 20,
                                      Icons.person,
                                    ),
                                    const SizedBox(width: 10),
                                    DisplayText(
                                        text: roles[roleController[roleIndex]
                                            .text]![memberIndex],
                                        lines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!)
                                  ],
                                ),
                              );
                            }),
                      ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 12.5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15), // Adjust this value as needed
                  ),
                ),
                onPressed: () {
                  setState(() {
                    roleCount = roleCount + 1;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_alt_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                    const SizedBox(width: 20),
                    const Text("Add and Assign a Role"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            nextButton(),
            const SizedBox(height: 20),
            DisplayText(
              text: "Notes:",
              lines: 1,
              style: Theme.of(context).textTheme.headlineSmall!,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  DisplayText(
                    text:
                        "Roles will be used to designate tasks. This will allow you to create groups.",
                    lines: 3,
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                  const SizedBox(height: 5),
                  DisplayText(
                    text: "Roles are supposed to be uniquely named.",
                    lines: 3,
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                ],
              ),
            ),
          ],
        );

      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, taskIndex) {
                taskRoleController.add(TextEditingController());
                taskFocus.add(FocusNode());
                taskFocus[taskIndex].addListener(() {
                  _saveField(taskFocus[taskIndex], () {
                    // if (tasks.contains(taskRoleController[taskIndex].text) ==
                    //     false) {
                    //   roles.addAll({roleController[roleIndex].text: []});
                    // }
                    // tasks.add(ToDoItem(
                    //     title: taskRoleController[taskIndex].text,
                    //     isChecked: false));
                    ref.read(marketAddListingProvider.notifier).setAddListing(
                          ref
                              .watch(marketAddListingProvider)!
                              .copyWith(tasks: tasks),
                        );
                  });
                });
                if (taskRoleController[taskIndex].value.text.isEmpty) {
                  taskFocus[taskIndex].requestFocus();
                }
                return Column(
                  children: [
                    Container(
                      height: 75,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width / 1.6,
                            padding: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: Form(
                              key: Key(taskCount.toString()),
                              child: TextFormField(
                                controller: taskRoleController[taskIndex],
                                focusNode: taskFocus[taskIndex],
                                onTapOutside: (downEvent) {
                                  FocusScope.of(context).unfocus();
                                },
                                maxLines: null,
                                decoration: const InputDecoration(
                                  label: Text("Task"),
                                  border: InputBorder.none, // Removes underline
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a task';
                                  }
                                  return null; // Return null if the entered value is valid
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15), // Adjust this value as needed
                                ),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 350,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: ref
                                              .watch(marketAddListingProvider)!
                                              .roles!
                                              .keys
                                              .length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 0.0),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    onTap: () {
                                                      setState(() {
                                                        tasks[taskIndex]
                                                            .owner!
                                                            .add(
                                                              ref
                                                                  .watch(
                                                                      marketAddListingProvider)!
                                                                  .roles!
                                                                  .keys
                                                                  .elementAt(
                                                                      index),
                                                            );
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    title: Text(
                                                      ref
                                                          .watch(
                                                              marketAddListingProvider)!
                                                          .roles!
                                                          .keys
                                                          .elementAt(index),
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          fontWeight:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .fontWeight),
                                                    ),
                                                  ),
                                                  const Divider(
                                                    thickness: 1,
                                                    indent: 20,
                                                    endIndent: 20,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text("Role"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (tasks[taskIndex].owner != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: tasks.length,
                          itemBuilder: (context, memberIndex) {
                            return Container(
                              margin: const EdgeInsets.only(left: 50),
                              height: MediaQuery.sizeOf(context).height / 15,
                              width: MediaQuery.sizeOf(context).width / 2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    size: 20,
                                    Icons.groups_outlined,
                                  ),
                                  const SizedBox(width: 10),
                                  DisplayText(
                                      text:
                                          tasks[taskIndex].owner![memberIndex],
                                      lines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!)
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 12.5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15), // Adjust this value as needed
                  ),
                ),
                onPressed: () {
                  setState(() {
                    tasks.add(ToDoItem(title: "", isChecked: false));
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                    const SizedBox(width: 20),
                    const Text("Add and Assign a Task"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            nextButton(),
            const SizedBox(height: 20),
            DisplayText(
              text: "Notes:",
              lines: 1,
              style: Theme.of(context).textTheme.headlineSmall!,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(height: 5),
                ],
              ),
            ),
          ],
        );

      case 5:
        ListingRepository listingRepository = ListingRepository();
        debugPrint(
            "this should be final ${ref.watch(marketAddListingProvider).toString()}");
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    ref.read(marketAddListingProvider.notifier).setAddListing(
                        ref.watch(marketAddListingProvider)!.copyWith(
                            owner: ref.watch(userModelProvider)!.uid,
                            postDate: Timestamp.now()));
                    listingRepository
                        .addListing(ref.watch(marketAddListingProvider)!);
                    uploadImage();
                  },
                  child: const Text("Submit Listing")),
            )
          ],
        );
      default:
        CooperativesRepository cooperativesRepository =
            CooperativesRepository();
        Future<List<String>> getCooperativesJoined =
            cooperativesRepository.getCooperativeNames(
                ref.watch(userModelProvider)!.cooperativesJoined!);
        titleFocus.addListener(() {
          _saveField(titleFocus, () {
            ref.read(marketAddListingProvider.notifier).setAddListing(
                  ref.watch(marketAddListingProvider)!.copyWith(
                        title: titleController.text,
                      ),
                );
          });
        });
        descriptionFocus.addListener(() {
          _saveField(descriptionFocus, () {
            ref.read(marketAddListingProvider.notifier).setAddListing(
                  ref.watch(marketAddListingProvider)!.copyWith(
                        description: descriptionController.text,
                      ),
                );
          });
        });
        priceFocus.addListener(() {
          _saveField(priceFocus, () {
            ref.read(marketAddListingProvider.notifier).setAddListing(
                  ref.watch(marketAddListingProvider)!.copyWith(
                        price: num.parse(priceController.value.text),
                      ),
                );
          });
        });
        paxFocus.addListener(() {
          _saveField(paxFocus, () {
            ref.read(marketAddListingProvider.notifier).setAddListing(
                  ref.watch(marketAddListingProvider)!.copyWith(
                        pax: num.parse(paxController.value.text),
                      ),
                );
          });
        });

        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<String>>(
                future:
                    getCooperativesJoined, // your Future<List<String>> for types
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // show loader while waiting for data
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    cooperativeNames = snapshot.data!;
                    return Container(
                      // width: MediaQuery.sizeOf(context).width / 1.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            15), // Create a circular shape
                        border: Border.all(
                            color: Colors.grey, width: 1), // Add a border
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: "Cooperative Partner",
                            border: InputBorder.none,
                          ),
                          menuMaxHeight: 300,
                          alignment: Alignment.center,
                          value: ref
                              .watch(marketAddListingProvider)!
                              .cooperativeOwned,
                          onChanged: (newValue) {
                            ref
                                .read(marketAddListingProvider.notifier)
                                .setAddListing(
                                  ref
                                      .watch(marketAddListingProvider)!
                                      .copyWith(cooperativeOwned: newValue),
                                );
                          },
                          items: snapshot.data!
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              alignment: Alignment.centerLeft,
                              value: value,
                              child: DisplayText(
                                text: value,
                                lines: 2,
                                style: Theme.of(context).textTheme.bodySmall!,
                              ),
                            );
                          }).toList(),
                          iconSize: 30.0,
                          isExpanded: true,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12), // Padding inside the container
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the container
                  borderRadius: BorderRadius.circular(15), // Makes it circular
                  border: Border.all(
                    color: Colors.grey, // Color of the border
                    width: 1, // Width of the border
                  ),
                ),
                child: TextFormField(
                  autofocus: false,
                  controller: titleController,
                  focusNode: titleFocus,
                  maxLines: null,
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
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12), // Padding inside the container
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the container
                  borderRadius: BorderRadius.circular(15), // Makes it circular
                  border: Border.all(
                    color: Colors.grey, // Color of the border
                    width: 1, // Width of the border
                  ),
                ),
                child: TextFormField(
                  controller: descriptionController,
                  focusNode: descriptionFocus,
                  maxLines: null,
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
              const SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12), // Padding inside the container
                      decoration: BoxDecoration(
                        color:
                            Colors.white, // Background color of the container
                        borderRadius:
                            BorderRadius.circular(15), // Makes it circular
                        border: Border.all(
                          color: Colors.grey, // Color of the border
                          width: 1, // Width of the border
                        ),
                      ),
                      child: TextFormField(
                        controller: priceController,
                        focusNode: priceFocus,
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
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.3,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12), // Padding inside the container
                        decoration: BoxDecoration(
                          color:
                              Colors.white, // Background color of the container
                          borderRadius:
                              BorderRadius.circular(15), // Makes it circular
                          border: Border.all(
                            color: Colors.grey, // Color of the border
                            width: 1, // Width of the border
                          ),
                        ),
                        child: TextFormField(
                          controller: paxController,
                          focusNode: paxFocus,
                          decoration: const InputDecoration(
                            label: Text("Persons (pax)"),
                            border: InputBorder.none, // Removes underline
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Persons (pax)';
                            }
                            return null; // Return null if the entered value is valid
                          },
                        ),
                      ),
                    ),
                  ],
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
                      const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.grey,
                        size: 90,
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
                  margin: const EdgeInsets.only(top: 10),
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
                    height: MediaQuery.sizeOf(context).height / 8,
                    width: MediaQuery.sizeOf(context).width,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Column(children: [
                      const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.grey,
                        size: 50,
                      ),
                      DisplayText(
                        text: "Add Images",
                        lines: 1,
                        style: Theme.of(context).textTheme.bodySmall!,
                      ),
                    ]),
                  ),
                ),
              const SizedBox(height: 10),
              nextButton(),
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
                          "Information you provide here will be used for the following steps. Please fill everything out.",
                      lines: 3,
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
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
            ],
          ),
        );
    }
  }
}
