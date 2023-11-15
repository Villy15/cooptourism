// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/events.dart';
import 'package:cooptourism/data/models/task.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final CooperativesRepository cooperativesRepository = CooperativesRepository();

final TaskRepository taskRepository = TaskRepository();

class ManagerTasksCreate extends ConsumerStatefulWidget {
  final EventsModel event;
  const ManagerTasksCreate({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManagerTasksCreateState();
}

class _ManagerTasksCreateState extends ConsumerState<ManagerTasksCreate> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMember;
  String? _title;
  String? _description;
  final List<ToDoItem> _toDoList = [];
  final List<Map<String, String>> _members = [];

  Timestamp? _selectedDate = Timestamp.fromDate(DateTime.now());
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();

    cooperativesRepository
        .getCooperativeMembersNamesUid("sslvO5tgDoCHGBO82kxq")
        .then((value) {
      debugPrint("value: $value");
      setState(() {
        _members.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Create Task'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                dropDownMembers(),
                titleText(),
                descText(),

                // Add the list of tasks with its date in a listtile
                // Text of Tasks: 
                taskHeading(),
                taskLists(),

                // Create a button add task
                ElevatedButton(
                  onPressed: () {
                    _showAddTaskModal(context);
                  },
                  child: const Text('Add Task'),

                ),

                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: submitBtn(context),
                ),

                const SizedBox(height: 100)
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView taskLists() {
    return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _toDoList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_toDoList[index].title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
                    // Format the date as 11/15/2023 00:00 
                    subtitle: Text(DateFormat('MM/dd/yyyy HH:mm').format(_toDoList[index].date!.toDate()), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primaryColor)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: primaryColor),
                      onPressed: () {
                        setState(() {
                          _toDoList.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              );
  }

  Padding taskHeading() {
    return const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text('Tasks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
              );
  }

  

  void _showAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .40,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                maxLines: 3,
                controller: _taskController,
                decoration: const InputDecoration(labelText: 'Task Description'),
              ),
              const SizedBox(height: 20),
              // Text of selected Date and format it to Jun 13,2013
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Icon of calendar
                      const Icon(Icons.calendar_today, color: primaryColor),
                      const SizedBox(width: 10),
                      // Format the date as 11/15/2023 00:00 
                      Text(
                        _selectedDate != null
                            ? DateFormat('MM/dd/yyyy HH:mm')
                                .format(_selectedDate!.toDate())
                            : 'No Date Selected!',
                        style: const TextStyle(color: primaryColor, fontSize: 16),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2025),
                      );
                      if (pickedDate != null) {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          DateTime pickedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          setState(() {
                            _selectedDate = Timestamp.fromDate(pickedDateTime);
                          });
                        }
                      }
                    },
                    child: const Text('Select Date and Time'),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              Align (
                alignment: Alignment.center,
                child: ElevatedButton(
                  // Width bigger
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // Add task to list
                    setState(() {
                      _toDoList.add(ToDoItem(
                        title: _taskController.text,
                        date: _selectedDate!,
                        isChecked: false,
                        proof: '',
                      ));
                    });
                    Navigator.pop(context); // Close the modal
                  },
                  child: const Text('Add Task'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ElevatedButton submitBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // Make it widger full
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          // handle form submission
          TaskModel task = TaskModel(
              assignedMember: _selectedMember!,
              title: _title!,
              description: _description!,
              progress: 0,
              toDoList: _toDoList,
              referenceId: widget.event.uid,
              isManagerApproved: true,
              type: 'Event');

          debugPrint("Task; $task");

          taskRepository.addTask(task);

          // Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task created successfully'),
            ),
          );

          // Navigate back to the previous screen
          Navigator.pop(context);
        }
      },
      child: const Text('Submit'),
    );
  }

  TextFormField descText() {
    return TextFormField(
      maxLines: 3,
      onChanged: (value) {
        _description = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a description';
        }
        return null;
      },
      decoration: const InputDecoration(labelText: 'Description'),
    );
  }

  TextFormField titleText() {
    return TextFormField(
      onChanged: (value) {
        _title = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
      decoration: const InputDecoration(labelText: 'Title'),
    );
  }

  DropdownButtonFormField<String> dropDownMembers() {
    return DropdownButtonFormField(
      value: _selectedMember,
      items: _members.map((member) {
        return DropdownMenuItem(
          value: member['id'],
          child: Text(member['name']!),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedMember = value;
          debugPrint("Selected Member: $_selectedMember");
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a member';
        }
        return null;
      },
      decoration: const InputDecoration(labelText: 'Member'),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      iconTheme: const IconThemeData(color: primaryColor),
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
    );
  }
}
