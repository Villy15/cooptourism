import 'package:cooptourism/widgets/button.dart';
import 'package:cooptourism/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';


class LoginPage extends StatefulWidget {
  final Function()? onTap;
  final Function()? onCoopTap;

  const LoginPage({super.key, this.onTap, this.onCoopTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  void signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

    } on FirebaseAuthException catch (e) {
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
      backgroundColor: Theme.of(context).colorScheme.background,
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
                        "Login",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
            
                  Row(
                    children: [
                        Text(
                        "New here? ",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      GestureDetector(
                        onTap: () => {
                           widget.onTap?.call(),
                        },
                        child: Text(
                          "Register now!",
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
            
                  
                  // login button 
                  MyButton(
                    onTap: signIn,
                    text: "Login",
                  ),
            
                  const SizedBox(height: 20),
                  
                  // Forgot password
                  GestureDetector(
                    // onTap: ,
                    child: Text(
                      "Forgot Password?",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 150),
            
                  // go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        "To register as a cooperative, ",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      GestureDetector(
                        onTap: widget.onCoopTap,
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