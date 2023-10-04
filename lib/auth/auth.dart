import 'package:cooptourism/auth/login_or_register.dart';
import 'package:cooptourism/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            // User is authenticated, add to Firestore
            addUserToFirestore(snapshot.data!);

            return const HomePage();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }

  Future<void> addUserToFirestore(User user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        // Add any additional fields you want to store for the user
      });
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }
}
