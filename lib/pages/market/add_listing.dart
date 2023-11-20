import 'dart:io';
import 'package:cooptourism/core/file_picker.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/providers/market_page_provider.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:cooptourism/widgets/category_picker.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:cooptourism/widgets/listing_dropdown.dart';
import 'package:cooptourism/widgets/type_picker.dart';
import 'package:cooptourism/widgets/listing_province_city_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_stepper/stepper.dart';
// import 'package:path/path.dart' as path_utils;

class AddListing extends ConsumerStatefulWidget {
  const AddListing({super.key});

  @override
  ConsumerState<AddListing> createState() => _AddListingState();
}

class _AddListingState extends ConsumerState<AddListing> {
  String listingType = "Service";
  List<File> uploadedImages = [];
  FilePickerUtility filePickerUtility = FilePickerUtility();
  Map<String, dynamic> amenities = {};
  int roleCount = 0;
  int taskCount = 0;
  Map<String, dynamic> tasks = {};
  Map<String, dynamic> roleMemberPair = {};
  List<String> memberNames = [];
  List<String> selectedMemberName = [];
  List<String> selectedRole = [];
  List<TextEditingController> roleController = [];
  List<TextEditingController> taskRoleController = [];
  List<FocusNode> roleFocus = [];
  List<FocusNode> taskFocus = [];
  int activeStep = 0;
  int upperBound = 6;
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

  void _saveField(FocusNode node, Function save) {
    debugPrint("is this even running");
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
    // final storageRef = FirebaseStorage.instance.ref();

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        ref.read(navBarVisibilityProvider.notifier).state = true;
        ref.read(appBarVisibilityProvider.notifier).state = true;
        ref.invalidate(marketCitiesProvider);
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
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
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
        return 'Rewiew';

      default:
        return 'Details';
    }
  }

  Widget stepForm() {
    CooperativesRepository cooperativesRepository = CooperativesRepository();
    Future<List<String>> getCooperativesJoined = cooperativesRepository
        .getCooperativeNames(ref.watch(userModelProvider)!.cooperativesJoined!);
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
        Future<Map<String, dynamic>> getCooperativeMembersNames;
        if (ref.watch(marketAddListingProvider)!.cooperativeOwned == null) {
          getCooperativeMembersNames =
              cooperativesRepository.getCooperativeMembersNames(
                  ref.watch(userModelProvider)!.cooperativesJoined![0]);
        } else {
          getCooperativeMembersNames =
              cooperativesRepository.getCooperativeMembersNames(
                  ref.watch(marketAddListingProvider)!.cooperativeOwned!);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (roleCount > 0)
              ListView.builder(
                shrinkWrap: true,
                itemCount: roleCount,
                itemBuilder: (context, index) {
                  selectedMemberName.add(
                    "${ref.watch(userModelProvider)!.lastName} ${ref.watch(userModelProvider)!.firstName}",
                  );
                  roleFocus.add(FocusNode());
                  roleFocus[index].addListener(() {
                    _saveField(roleFocus[index], () {
                      roleMemberPair.addAll({
                        selectedMemberName[index]:
                            roleController[index].value.text
                      });
                      ref.read(marketAddListingProvider.notifier).setAddListing(
                            ref
                                .watch(marketAddListingProvider)!
                                .copyWith(roles: roleMemberPair),
                          );
                    });
                  });
                  roleController.add(TextEditingController());
                  return Container(
                    height: 75,
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FutureBuilder(
                          future: getCooperativeMembersNames,
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<String, dynamic>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(); // show loader while waiting for data
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Expanded(
                                child: Container(
                                  // width: MediaQuery.sizeOf(context).width / 1.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        15), // Create a circular shape
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 1), // Add a border
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        labelText: "Assigned To",
                                        border: InputBorder.none,
                                      ),
                                      menuMaxHeight: 300,
                                      alignment: Alignment.center,
                                      value: selectedMemberName[index],
                                      onChanged: (newValue) {
                                        selectedMemberName[index] = newValue!;
                                        roleMemberPair.addEntries(
                                          {selectedMemberName[index]: ""}
                                              .entries,
                                        );
                                      },
                                      items: snapshot.data!.values
                                          .map<DropdownMenuItem<String>>(
                                              (dynamic value) {
                                        return DropdownMenuItem<String>(
                                          alignment: Alignment.centerLeft,
                                          value: value,
                                          child: DisplayText(
                                            text: value,
                                            lines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!,
                                          ),
                                        );
                                      }).toList(),
                                      iconSize: 30.0,
                                      isExpanded: true,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: MediaQuery.sizeOf(context).width / 1.7,
                          padding: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: Form(
                            key: Key(roleCount.toString()),
                            child: TextFormField(
                              controller: roleController[index],
                              focusNode: roleFocus[index],
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
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                setState(() {
                  roleCount = roleCount + 1;
                });
              },
              child: Container(
                height: MediaQuery.sizeOf(context).height / 10,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.people_outline_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                    const SizedBox(width: 20),
                    DisplayText(
                      text: "Add and Assign a Role",
                      lines: 1,
                      style: Theme.of(context).textTheme.bodyMedium!,
                    ),
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
                children: [
                  const SizedBox(height: 5),
                  DisplayText(
                    text: "Roles will be used to designate tasks.",
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
            if (taskCount > 0)
              ListView.builder(
                shrinkWrap: true,
                itemCount: taskCount,
                itemBuilder: (context, index) {
                  taskRoleController.add(TextEditingController());
                  selectedRole.add(ref
                      .watch(marketAddListingProvider)!
                      .roles!
                      .entries
                      .first
                      .value);
                  taskFocus.add(FocusNode());
                  taskFocus[index].addListener(() {
                    _saveField(taskFocus[index], () {
                      tasks.addAll({
                        taskRoleController[index].value.text:
                            selectedRole[index]
                      });
                      ref.read(marketAddListingProvider.notifier).setAddListing(
                          ref
                              .watch(marketAddListingProvider)!
                              .copyWith(tasks: tasks));
                    });
                  });
                  return Container(
                    height: 75,
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width / 1.7,
                          padding: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: Form(
                            key: Key(taskCount.toString()),
                            child: TextFormField(
                              controller: taskRoleController[index],
                              focusNode: taskFocus[index],
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
                          child: Container(
                            // width: MediaQuery.sizeOf(context).width / 1.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  15), // Create a circular shape
                              border: Border.all(
                                  color: Colors.grey, width: 1), // Add a border
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: "Assign to Role",
                                  border: InputBorder.none,
                                ),
                                menuMaxHeight: 300,
                                alignment: Alignment.center,
                                value: selectedRole[index],
                                onChanged: (newValue) {
                                  selectedRole[index] = newValue!;
                                  tasks.addAll({
                                    taskRoleController[index].value.text:
                                        selectedRole[index]
                                  });
                                  ref
                                      .read(marketAddListingProvider.notifier)
                                      .setAddListing(
                                        ref
                                            .watch(marketAddListingProvider)!
                                            .copyWith(tasks: tasks),
                                      );
                                },
                                items: ref
                                    .watch(marketAddListingProvider)!
                                    .roles!
                                    .values
                                    .map<DropdownMenuItem<String>>(
                                        (dynamic value) {
                                  return DropdownMenuItem<String>(
                                    alignment: Alignment.centerLeft,
                                    value: value,
                                    child: DisplayText(
                                      text: value,
                                      lines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!,
                                    ),
                                  );
                                }).toList(),
                                iconSize: 30.0,
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                setState(() {
                  taskCount = taskCount + 1;
                });
              },
              child: Container(
                height: MediaQuery.sizeOf(context).height / 10,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.people_outline_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                    const SizedBox(width: 20),
                    DisplayText(
                      text: "Add and Assign a Task",
                      lines: 1,
                      style: Theme.of(context).textTheme.bodyMedium!,
                    ),
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
        debugPrint(
            "this should be final ${ref.watch(marketAddListingProvider).toString()}");
        return Column(
          children: [
            const Text("Review"),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {}, child: const Text("Submit Listing")),
            )
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListingDropdown(
              title: "Cooperative Partner",
              future: getCooperativesJoined,
              selectedValue:
                  ref.watch(marketAddListingProvider)!.cooperativeOwned,
              onValueChange: (newValue) {
                ref.read(marketAddListingProvider.notifier).setAddListing(
                      ref
                          .watch(marketAddListingProvider)!
                          .copyWith(cooperativeOwned: newValue),
                    );
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
              child: Form(
                child: TextFormField(
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
              child: Form(
                child: TextFormField(
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
                      child: Form(
                        child: TextFormField(
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
        );
    }
  }

  // String? _getProofPath() {
  //   if (filePickerUtility.image != null) {
  //     return path_utils.basename(filePickerUtility.image!.path);
  //   } else if (filePickerUtility.pickedFile != null) {
  //     return path_utils.basename(filePickerUtility.pickedFile!.path);
  //   }
  //   return null;
  // }
}
