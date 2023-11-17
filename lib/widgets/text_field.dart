import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  // Add an icon on the end of the text field where clicking it would reveal the password
  // Hint: Use the suffixIcon property of InputDecoration
  // Hint: Use the obscureText property of TextField
  

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white54,
        filled: true,
        prefixIcon: hintText == 'Email' ? const Icon(Icons.email) : const Icon(Icons.lock),
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
      ),
      // Text color of input
      controller: controller,
      obscureText: obscureText,
    );
  }
}
