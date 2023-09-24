import 'package:flutter/material.dart';

class CoopsPage extends StatefulWidget {
  const CoopsPage({super.key});

  @override
  State<CoopsPage> createState() => _CoopsPageState();
}

class _CoopsPageState extends State<CoopsPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Coops",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}