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
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/images/login_bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // New here? register now
                      //  Row(
                      //   children: [
                      //     Text(
                      //       "Login",
                      //       style: Theme.of(context).textTheme.bodyLarge,
                      //     ),
                      //   ],
                      // ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Kamusta? Tara,",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Satisfy',
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Lakbay!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Satisfy'),
                        ),
                      ),

                      // Row(
                      //   children: [
                      //       Text(
                      //       "New here? ",
                      //       style: Theme.of(context).textTheme.bodySmall,
                      //     ),
                      //     GestureDetector(
                      //       onTap: () => {
                      //          widget.onTap?.call(),
                      //       },
                      //       child: Text(
                      //         "Register now!",
                      //         style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //           decoration: TextDecoration.underline,
                      //           fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     )
                      //   ],
                      // ),

                      const SizedBox(height: 75),

                      // email textfield
                      MyTextField(
                          controller: emailTextController,
                          hintText: "Email",
                          obscureText: false),

                      const SizedBox(height: 10),

                      // password textfield
                      MyTextField(
                          controller: passwordTextController,
                          hintText: "Password",
                          obscureText: true),

                      const SizedBox(height: 10),

                      // login button
                      MyButton(
                        onTap: signIn,
                        text: "Login",
                      ),

                      const SizedBox(height: 20),

                      // Forgot password
                      

                      const SizedBox(height: 150),

                      // go to register page
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              widget.onTap?.call();
                            },
                            child: const Text(
                              "Create Account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
          ),
        ));
  }
}
