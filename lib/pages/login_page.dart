import 'package:cooptourism/components/button.dart';
import 'package:cooptourism/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // Sign user in

  void signIn() async {
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailTextController.text,
      password: passwordTextController.text,
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
                        onTap: widget.onTap,
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
                  
                  const SizedBox(height: 50),
            
                  // go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        "To register as a cooperative, ",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      GestureDetector(
                        // onTap: widget.onTap,
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