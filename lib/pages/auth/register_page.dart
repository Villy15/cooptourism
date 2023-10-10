import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/widgets/button.dart';
import 'package:cooptourism/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  void signUp() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
    ));

    // Make sure passwords match

    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);
      displayMessage("Passwords do not match");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      if (context.mounted) {
        Navigator.pop(context);
      }

      // Add to firestore database w/ UID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'email': emailTextController.text,
        'role': 'Customer',
      });
      

    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(message),
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [          
                  
                  // New here? register now
                   Row(
                    children: [
                      Text(
                        "Register",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
            
                  Row(
                    children: [
                        Text(
                        "Already have an account?  ",
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
            
                  const SizedBox(height: 75),
            
                  
                  // email textfield
                  MyTextField(
                        controller: emailTextController,
                        hintText: "Email",
                        obscureText: false
                      ),
            
                  const SizedBox(height: 10),
                    
                  
                  // password textfield
                  MyTextField(
                        controller: passwordTextController,
                        hintText: "Password",
                        obscureText: true
                      ),

                  const SizedBox(height: 10),


                  MyTextField(
                        controller: confirmPasswordTextController,
                        hintText: "Confirm Password",
                        obscureText: true
                      ),
            
                  const SizedBox(height: 10),
            
                  
                  // login button 
                  MyButton(
                    onTap: signUp,
                    text: "Register",
                  ),
            
                  const SizedBox(height: 20),
                
                  
                  const SizedBox(height: 100),
            
                  // go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        "To register as a cooperative, ",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "click here",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}