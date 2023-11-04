import 'package:cooptourism/data/models/itineraries.dart';
import 'package:cooptourism/data/repositories/itinerary_repository.dart';
import 'package:flutter/material.dart';

final ItineraryRepository itineraryRepository = ItineraryRepository();

class AddActivityPage extends StatefulWidget {
  final ItineraryModel itinerary;
  final int? selectedDay; // to keep track of selected day
  const AddActivityPage({Key? key, required this.itinerary, this.selectedDay}) : super(key: key);

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _activityType;
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Add Activity'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField(
                value: _activityType,
                onChanged: (String? newValue) {
                  setState(() {
                    _activityType = newValue;
                  });
                },
                items: <String>['Lodging', 'Food', 'Activities', 'Transport']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Activity Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an activity type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(_selectedDate == null
                    ? 'Pick Time of Activity'
                    : // Time of activity in 12am or 12pm format 
                    "Time of activity: " '${_selectedDate!.hour == 0 ? 12 : _selectedDate!.hour > 12 ? _selectedDate!.hour - 12 : _selectedDate!.hour}:${_selectedDate!.minute.toString().padLeft(2, '0')} ${_selectedDate!.hour < 12 ? 'am' : 'pm'}'),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                child: const Text('Save Activity'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process data
                    var newActivity = ActivityModel(
                      datetime: _selectedDate!,
                      description: _descriptionController.text,
                      location: _locationController.text,
                      activityType: _activityType!,
                    );

                    // Add activity to itinerary
                    itineraryRepository.updateActivity(widget.itinerary.uid, newActivity, widget.selectedDay!);

                    Navigator.pop(context);
                    // Show Snackbar upon success
                    ScaffoldMessenger.of(context).showSnackBar(
                      // Add primary color to snackbar
                      SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        content: const Text('Activity saved!'),
                      ),
                    );
                    
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue, // your color for the picker
          ),
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary
          ),
        ),
        child: child!,
      );
    },
  );
  if (pickedTime != null) {
    setState(() {
      final now = DateTime.now();
      _selectedDate = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }
}

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                // Navigator.push(context, 
                //   MaterialPageRoute(builder: (context) => AddActivityPage(itinerary: widget.itinerary))
                // );
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}