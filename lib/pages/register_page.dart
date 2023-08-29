import 'package:cooptourism/components/button.dart';
import 'package:cooptourism/components/text_field.dart';
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
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Inter",
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
            
                  Row(
                    children: [
                       Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login Here",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
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
                        controller: passwordTextController,
                        hintText: "Confirm Password",
                        obscureText: true
                      ),
            
                  const SizedBox(height: 10),
            
                  
                  // login button 
                  MyButton(
                    onTap: () {},
                    text: "Register",
                  ),
            
                  const SizedBox(height: 20),
                
                  
                  const SizedBox(height: 50),
            
                  // go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        "To register as a cooperative, ",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      GestureDetector(
                        // onTap: widget.onTap,
                        child: Text(
                          "click here",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
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