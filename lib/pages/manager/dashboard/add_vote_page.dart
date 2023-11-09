import 'package:cooptourism/core/theme/light_theme.dart';
import 'package:cooptourism/data/models/manager_dashboard.dart/votes.dart';
import 'package:cooptourism/data/models/poll.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/manager_dashboard/votes_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final CooperativesRepository cooperativesRepository = CooperativesRepository();
final UserRepository userRepository = UserRepository();
final VoteRepository voteRepository = VoteRepository();

class AddVotePage extends ConsumerStatefulWidget {
  const AddVotePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddVotePageState();
}

class _AddVotePageState extends ConsumerState<AddVotePage> {
  String? title = '';
  String? description = '';
  DateTime? selectedDate;
  List<String> selectedMembers = [];
  List<String?> selectedMembersUId = [];

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    debugPrint("title: $title");
    debugPrint("description: $description");
    debugPrint("selectedDate: $selectedDate");
    debugPrint("selectedMembers: $selectedMembers");
    debugPrint("selectedMembersUId: $selectedMembersUId");


    return Scaffold(
      appBar: _appBar(context, 'Add Vote'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                titleInput(),
                descriptionInput(),
                datePicker(context),
                addUsers(context),
                submitButton(formKey),
              ],
            ),
          ),
        ),
      ),
    );
  }

 

  Widget addUsers(BuildContext context) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Column(
      children: [
        const Text("Choices", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primaryColor)),
        ...selectedMembers.map((member) => ListTile(
          title: Text(member, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primaryColor)),
        )).toList(),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Add Member', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primaryColor)),
          onTap: () {
            showModalBottomSheet(
              // add height
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return SizedBox(height: 350, child: listMembers());
              },
            );
          },
        ),
      ],
    ),
  );
}

  FutureBuilder<List<String>> listMembers() {
    return FutureBuilder(
          future: cooperativesRepository
              .getCooperativeMembers("sslvO5tgDoCHGBO82kxq"),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error loading data');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              // Return shirnk or no widget
              return const SizedBox.shrink();
            }

            final members = snapshot.data as List<String>;

             return ListView.builder(
    shrinkWrap: true,
    itemCount: members.length,
    itemBuilder: (context, index) {
      return FutureBuilder<UserModel>(
        future: userRepository.getUser(members[index]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error loading data');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }

          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    setState(() {
                      selectedMembers.add('${user.firstName} ${user.lastName}');
                    });
                    setState(() {
                      selectedMembersUId.add(user.uid);
                    });
                    Navigator.pop(context);
                  },
                  title: Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
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
        },
      );
    },
  );
          },
        );
  }



  ElevatedButton submitButton(GlobalKey<FormState> formKey) {
    List<PollModel> polls = List<PollModel>.generate(
      selectedMembers.length,
      (index) => PollModel(
        optionText: selectedMembers[index],
        optionId: selectedMembersUId[index],
        votes: 0,
        voters: [],
      ),
    );

    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          // Add the vote to the database
          voteRepository.addVote(
            VoteModel(
              title: title!,
              description: description!,
              date: selectedDate!,
            ),
            polls,
          );

          // Add polls to the vote



          // Show snackbar and pop
          // Show snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vote added successfully'),
              duration: Duration(seconds: 2),
            ),
          );

          // Pop the current screen after a delay
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
        }
      },
      child: const Text('Submit'),
    );
  }

  Widget datePicker(BuildContext context) {
    return Align (
      alignment: Alignment.centerLeft,
      child: TextButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  },
                  child: Row(
                    children: [
                      const Icon (
                        Icons.calendar_today,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        selectedDate == null
                            ? 'Select a date'
                            : "Date: ${DateFormat('MMM d, y').format(selectedDate!)}",
                      ),
                    ],
                  ),
                ),
    );
  }

  TextFormField descriptionInput() {
    return TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Description', hintText: 'Enter a description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                style: const TextStyle (
                  color: primaryColor,
                ),
                onSaved: (value) {
                  description = value;
                },
              );
  }

  TextFormField titleInput() {
    return TextFormField(
                decoration: const InputDecoration(labelText: 'Title', hintText: 'Enter a title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                style: const TextStyle (
                  color: primaryColor,
                ),
                onSaved: (value) {
                  title = value;
                },
              );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      iconTheme: const IconThemeData(color: primaryColor),
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      actions: const [
        // Padding(
        //   padding: const EdgeInsets.only(right: 16.0),
        //   child: CircleAvatar(
        //     backgroundColor: Colors.grey.shade300,
        //     child: IconButton(
        //       onPressed: () {
        //         // showAddPostPage(context);
        //       },
        //       icon: const Icon(Icons.settings, color: Colors.white),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
