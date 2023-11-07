// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/coaching_form.dart';
import 'package:cooptourism/data/repositories/coaching_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoachingPage extends ConsumerStatefulWidget {
  const CoachingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoachingPageState();
}

class _CoachingPageState extends ConsumerState<CoachingPage> {
  final userRepository = UserRepository();
  final coachingRepository = CoachingRepository();

  final concernDescriptionController = TextEditingController();
  final goalController = TextEditingController(); 

  User? user;
  final List<String> _concerns = [
    'Tour Accommodation',
    'Driving Skills',
    'Tour Guide',
    'Credit Loans',
  ];

  String firstName = "";
  String lastName = "";

  String dropdownValue = 'Tour Accommodation';


  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    // userRepository.addMessageManually();

    getName();
    Future.delayed(Duration.zero, () {
      _updateNavBarAndAppBarVisibility(false);
    });
  }

  Future<void> getName () async {
    final userName = await userRepository.getUser(user!.uid);

    setState(() {
      firstName = userName.firstName!;
      lastName = userName.lastName!;
    });
  } 

  Future<void>? _submitFuture; 

  // get coaches from firestore
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
     onWillPop: () async {
        _updateNavBarAndAppBarVisibility(true);
        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Tell us about your coaching needs.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary
                    )
                  )
                ),
                const SizedBox(height: 20),
                const Text(
                  'Choose your coaching focus: '
                  ),
                const SizedBox(height: 10),
                DropdownButton(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      debugPrint('dropdownValue: $dropdownValue');
                    });
                  },
                  items: _concerns.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary
                        )
                      )
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text('Describe your concern: '),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: concernDescriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your concern here...',
                    ),
                    maxLines: 5,
                  ),
                ),
                const SizedBox(height: 20),
                const Text('What do you wish to accomplish?'),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: goalController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your goal here...',
                    ),
                    maxLines: 5,
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<void>(
                  future: _submitFuture,
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // If the Future is running, show a CircularProgressIndicator
                      return const CircularProgressIndicator();
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, show a success message
                      return const Text('Your form has been submitted!');
                    } else {
                      // If the Future hasn't started yet, show the submit button
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _submitFuture = addCoachingForm();
                          });
                        },
                        child: const Text('Submit'),
                      );
                    }
                  },
                ),
              ],
            ),
          )
        )
      ),
    );
  }

  Future<void> addCoachingForm() async {
    CoachingFormModel coachingForm = 
    CoachingFormModel(
      concern: dropdownValue,
      concernDescription: concernDescriptionController.text,
      goal: goalController.text,
      userUID: user!.uid,
      firstName: firstName, 
      lastName: lastName,
      status: 'Pending',
      timestamp: DateTime.now()
    );

    await coachingRepository.addCoachingForm(coachingForm);
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Coaching Application Form'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          _updateNavBarAndAppBarVisibility(true);
          Navigator.of(context).pop(); // to go back
        },
      ),
    );
  }

  void _updateNavBarAndAppBarVisibility(bool isVisible) {
    ref.read(navBarVisibilityProvider.notifier).state = isVisible;
    ref.read(appBarVisibilityProvider.notifier).state = isVisible;
  }
}