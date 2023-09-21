import 'package:cooptourism/auth/auth.dart';
import 'package:cooptourism/pages/manager/home_page.dart';
import 'package:cooptourism/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        secondaryHeaderColor: Colors.black,

        // Define the default font family.
        fontFamily: 'Inter',

        // Text Themes
        textTheme: TextTheme(
          // BODY LARGE
          bodyLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),

          // BODY MEDIUM
          bodyMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.grey[700],
          ),

          // BODY SMALL
          bodySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[700],
          ),

          headlineMedium: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),

        ),
      ),

      home: const HomePageManager(),
    );
  }
}
