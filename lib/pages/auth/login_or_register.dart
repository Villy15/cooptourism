
import 'package:cooptourism/pages/auth/login_page.dart';
import 'package:cooptourism/pages/auth/register_coop/register_coop_page.dart';
// import 'package:cooptourism/pages/auth/register_page.dart';
import 'package:flutter/material.dart';


class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
      debugPrint("showLoginPage: $showLoginPage");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterCoopPage(
        onTap: togglePages,
      );
    }
  }
}