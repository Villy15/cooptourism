// import 'dart:io';

import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/events.dart';
import 'package:cooptourism/data/repositories/events_repository.dart';
import 'package:cooptourism/pages/events/selected_events_page.dart';
// import 'package:cooptourism/providers/user_provider.dart';
// import 'package:cooptourism/widgets/display_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

final EventsRepository eventsRepository = EventsRepository();

class EditEventPage extends ConsumerStatefulWidget {
  final EventsModel event;
  const EditEventPage({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditEventPageState();
}

class _EditEventPageState extends ConsumerState<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? description;
  String? location;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  String? imagePath;
  XFile? image;

  @override
  void initState() {
    super.initState();
    title = widget.event.title;
    description = widget.event.description;
    location = widget.event.location;
    startDate = widget.event.startDate;
    endDate = widget.event.endDate;
    imagePath = widget.event.image?.first;

    // image = XFile(imagePath!);
  }

  @override
  Widget build(BuildContext context) {
    // final event = widget.event;
    return Scaffold(
      appBar: _appBar(context, 'Edit Event'),
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
                // if (imagePath != null && image == null)
                //   Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 12.0),
                //     child: DisplayImage(
                //       path: "${event.uid}/${event.image![0]}",
                //       height: 200,
                //       width: 300,
                //       radius: const BorderRadius.only(),
                //     ),
                //   ),

                // if (image != null)
                //   SizedBox(
                //       height: 200,
                //       width: 300,
                //     child: Image.file(File(image!.path))),
                // imagePicker(),
                Padding(
                  padding: const EdgeInsets.only(top: 140.0),
                  child: submitBtn(),
                ),
                const SizedBox(
                  height: 100,
                )
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
        XFile? selectedImage =
            await picker.pickImage(source: ImageSource.gallery);
        setState(() {
          image = selectedImage;
        });
      },
      child: const Text('Select Image'),
    );
  }

  ElevatedButton submitBtn() {
    return ElevatedButton(
      // Take the maximum width
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.orange.shade700),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          // Add event to database
          final event = widget.event.copyWith(
            title: title!,
            startDate: startDate,
            endDate: endDate,
            description: description!,
            location: location!,
          );

          debugPrint("event: ${event.toString()}");

          // Add event to database
          eventsRepository.updateEvent(widget.event.uid, event);

          // Show snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Event edited successfully'),
            ),
          );

          // Pop
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SelectedEventsPage(eventId: widget.event.uid!)),
          );
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
                    selectionMode: DateRangePickerSelectionMode.range,
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
      initialValue: location,
      decoration: const InputDecoration(labelText: 'Location'),
      onSaved: (value) => location = value,
      style: const TextStyle(color: primaryColor),
    );
  }

  TextFormField textDesc() {
    return TextFormField(
      initialValue: description,
      decoration: const InputDecoration(labelText: 'Description'),
      onSaved: (value) => description = value,
      style: const TextStyle(
        color: primaryColor,
        // Make the textfield bigger
      ),
      maxLines: 8,
    );
  }

  TextFormField textTitle() {
    return TextFormField(
      initialValue: title,
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