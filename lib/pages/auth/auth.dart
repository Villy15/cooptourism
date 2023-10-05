import 'package:cooptourism/pages/auth/login_or_register.dart';
import 'package:cooptourism/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  final Widget child;
  const AuthPage({Key? key, required this.child}) : super(key: key);
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          if (snapshot.hasData) {
            // User is authenticated, add to Firestore
            return HomePage(child: widget.child);
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}