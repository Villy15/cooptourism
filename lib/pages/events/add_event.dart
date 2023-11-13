import 'dart:io';

import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/events.dart';
import 'package:cooptourism/data/repositories/events_repository.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

final EventsRepository eventsRepository = EventsRepository();

class AddEventPage extends ConsumerStatefulWidget {
  const AddEventPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEventPageState();
}

class _AddEventPageState extends ConsumerState<AddEventPage> {

  final _formKey = GlobalKey<FormState>();
  String? title;
  String? description;
  String? location;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  XFile? image;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Add Event'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                textTitle(),
                textDesc(),
                textLocation(),
                datePicker(context),
                if (image != null)
                  SizedBox(
                      height: 200,
                      width: 300,
                    child: Image.file(File(image!.path))),
                imagePicker(),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: submitBtn(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton imagePicker() {
    return ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    image = selectedImage;
                  });
                },
                child: const Text('Select Image'),
              );
  }

  ElevatedButton submitBtn() {
    final user = ref.read(userModelProvider);
    return ElevatedButton(
      // Take the maximum width
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.orange.shade700),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          // Add event to database
          final event = EventsModel(
            title: title!,
            startDate: startDate,
            endDate: endDate,
            description: description!,
            location: location!,
            // image: [image!.path],
            // Image absolute path
            image: [image!.path.split('/').last],
            participants: [user!.uid!],
          );

          // Add event to database
          eventsRepository.addEvent(event, image!);

          // Show snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Event added successfully'),
            ),
          );

          // Pop
          Navigator.pop(context);
          
        }
      },
      child: const Text('Submit'),
    );
  }

  Row datePicker(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dates',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold)),
                      Text(
                          '${DateFormat('dd MMM').format(startDate)} - ${DateFormat('dd MMM').format(endDate)} (${endDate.difference(startDate).inDays} days)',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      final result = await showDialog<PickerDateRange>(
                        context: context,
                        builder: (context) => Dialog(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.8, // 80% of screen width
                            height: MediaQuery.of(context).size.height *
                                0.6, // 60% of screen height
                            child: SfDateRangePicker(
                              // onSelectionChanged: _onDateSelection,
                              selectionMode:
                                  DateRangePickerSelectionMode.range,
                              initialSelectedRange: PickerDateRange(
                                startDate,
                                endDate,
                              ),
                              showActionButtons:
                                  true, // Enable the confirm and cancel buttons
                              onSubmit: (value) {
                                Navigator.pop(context, value);
                              },
                              onCancel: () {
                                Navigator.pop(context, null);
                              },
                            ),
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          startDate = result.startDate!;
                          endDate = result.endDate!;
                          // nights = endDate.difference(startDate).inDays;
                        });
                      }
                    },
                    child: const Text('Edit',
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            decoration: TextDecoration.underline)),
                  ),
                ],
              );
  }

  TextFormField textLocation() {
    return TextFormField(
                decoration: const InputDecoration(labelText: 'Location'),
                onSaved: (value) => location = value,
                style: const TextStyle(color: primaryColor),
              );
  }

  TextFormField textDesc() {
    return TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value,
                style: const TextStyle(color: primaryColor),

              );
  }

  TextFormField textTitle() {
    return TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => title = value,
                style: const TextStyle(color: primaryColor),
              );
  }

   AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      iconTheme: const IconThemeData(color: primaryColor),
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