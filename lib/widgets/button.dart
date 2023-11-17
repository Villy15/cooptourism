import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Function()? onTap;
  final String text;

  const MyButton({super.key, this.onTap, required this.text});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {
        widget.onTap!();
      },
      child: Text(widget.text),
    );
  }
}
