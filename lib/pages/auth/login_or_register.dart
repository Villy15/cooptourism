import 'package:cooptourism/pages/auth/login_page.dart';
import 'package:cooptourism/pages/auth/register_coop/register_coop_page.dart';
import 'package:cooptourism/pages/auth/register_page.dart';
import 'package:flutter/material.dart';

enum AuthPage { login, register, registerCoop }

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  AuthPage currentPage = AuthPage.login;

  void showRegisterCoopPage() {
    setState(() {
      currentPage = AuthPage.registerCoop;
    });
  }

  void togglePages() {
    setState(() {
      currentPage =
          currentPage == AuthPage.login ? AuthPage.register : AuthPage.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (currentPage) {
      case AuthPage.login:
        return LoginPage(
          onTap: togglePages,
          onCoopTap: showRegisterCoopPage,
        );
      case AuthPage.register:
        return RegisterPage(
          onTap: togglePages,
          onCoopTap: showRegisterCoopPage,
        );
      case AuthPage.registerCoop:
        return RegisterCoopPage(
          onTap: togglePages,
            );
      default:
        throw Exception('Unknown page');
    }
  }
}
