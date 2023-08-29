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