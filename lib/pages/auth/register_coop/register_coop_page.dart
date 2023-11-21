// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/widgets/button.dart';
// import 'package:cooptourism/widgets/text_field.dart';
import 'package:flutter/material.dart';

class RegisterCoopPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterCoopPage({Key? key, this.onTap}) : super(key: key);

  @override
  State<RegisterCoopPage> createState() => _RegisterCoopPageState();
}

class _RegisterCoopPageState extends State<RegisterCoopPage> {
  final coopNameController = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();

  final coopRepostiroy = CooperativesRepository();
  int _currentStep = 0;

  List<Step> _buildSteps(BuildContext context) {
    return [
      Step(
        title: const Text('Name'),
        content: Column(
          children: [
            TextField(
              controller: coopNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Cooperative Name*',
              ),
            )
          ],
        ),
        isActive: _currentStep == 0,
      ),
      Step(
        title: const Text('Image'),
        content: const Column(
          children: [Placeholder()],
        ),
        isActive: _currentStep == 1,
      ),
      Step(
        title: const Text('City'),
        content: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'City*',
              ),
            )
          ],
        ),
        isActive: _currentStep == 2,
      ),
      Step(
        title: const Text('Province'),
        content: Column(
          children: [
            TextField(
              controller: provinceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Province*',
              ),
            )
          ],
        ),
        isActive: _currentStep == 3,
      ),
      Step(
        title: const Text('Submit'),
        content: const Column(
          children: [
            Text('Press the button below to submit the form.'),
          ],
        ),
        isActive: _currentStep == 4,
      ),
    ];
  }

  void _submitForm() async {
    try {
      final coop = CooperativesModel(
        name: coopNameController.text,
        city: cityController.text,
        province: provinceController.text,
      );

      await coopRepostiroy.addCooperative(coop);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cooperative added successfully!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // New here? register now
                const SizedBox(height: 50),

                Container(),
                Row(
                  children: [
                    Text(
                      "Co-Op Register",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Go back to login?  ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login here!",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                Stepper(
                  currentStep: _currentStep,
                  physics: const NeverScrollableScrollPhysics(),
                  onStepTapped: (value) => setState(() => _currentStep = value),
                  steps: _buildSteps(context),
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controlsDetails) {
                    if (_currentStep == _buildSteps(context).length - 1) {
                      return Container();
                    } else {
                      return Row(
                        children: [
                          if (controlsDetails.onStepContinue != null)
                            MyButton(
                              onTap: controlsDetails.onStepContinue,
                              text: 'Continue',
                            ),
                          if (controlsDetails.onStepCancel != null)
                            MyButton(
                              onTap: controlsDetails.onStepCancel,
                              text: 'Cancel',
                            ),
                        ],
                      );
                    }
                  },
                ),
                if (_currentStep == _buildSteps(context).length - 1)
                  const SizedBox(height: 60),
                MyButton(
                  onTap: () {
                    _submitForm();
                  },
                  text: 'Submit',
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                    ),
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Please fill out the form above to register your cooperative.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
