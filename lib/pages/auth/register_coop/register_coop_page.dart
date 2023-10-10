// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/widgets/button.dart';
import 'package:cooptourism/widgets/text_field.dart';
import 'package:flutter/material.dart';


class RegisterCoopPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterCoopPage({super.key, this.onTap});

  @override
  State<RegisterCoopPage> createState() => _RegisterCoopPageState();
}

class _RegisterCoopPageState extends State<RegisterCoopPage> {
  final coopNameController = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();
  int _currentStep = 0;

  List<Step> _buildSteps(BuildContext context) {
    return [
      Step(
        title: const Text('Name', ),
        content: Column(
          children: [
            MyTextField(
              controller: coopNameController,
              hintText: 'Cooperative Name',
              obscureText: false,
            ),
          ],
        ),
        isActive: _currentStep == 0,
      ),
      Step(
        title: const Text('Image'),
        content: const Column(
          children: [
            Placeholder()
          ],
        ),
        isActive: _currentStep == 1,
      ),
      Step(
        title: const Text('City'),
        content: Column(
          children: [
            MyTextField(
              controller: cityController,
              hintText: 'City',
              obscureText: false,
            ),
          ],
        ),
        isActive: _currentStep == 2,
      ),
      Step(
        title: const Text('Province'),
        content: Column(
          children: [
            MyTextField(
              controller: provinceController,
              hintText: 'Province',
              obscureText: false,
            ),
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


  // Create a List of Step where first it has it has a name, an image, city, province
  // and the last step has a button to submit the form


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
                const SizedBox(height: 25),

                Container(
                  
                ),

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
                  onStepContinue: () {
                    setState(() {
                      if (_currentStep < _buildSteps(context).length - 1) {
                        _currentStep++;
                      }
                    });
                  },
                  onStepCancel: () {
                    setState(() {
                      if (_currentStep > 0) {
                        _currentStep--;
                      }
                    });
                  },
                  steps: _buildSteps(context),
                ),
                if (_currentStep == _buildSteps(context).length - 1)
                  MyButton(
                    onTap: () {
                      // Submit the form
                    },
                    text: 'Submit',
                  ),
              ],
            ),
          ),
        ),
      )
    );
  }
}