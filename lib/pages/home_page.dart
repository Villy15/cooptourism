import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'coops_page.dart';
import 'market_page.dart';
import 'menu_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = const [
    CoopsPage(), //this has to be homepage. lets figure out the error first
    CoopsPage(),
    MarketPage(),
    ProfilePage(),
    MenuPage(),
  ];
  void signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Home",
            style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          ),
          iconTheme:
              IconThemeData(color: Theme.of(context).secondaryHeaderColor),
        ),
        body: _tabs[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              child: GNav(
                tabMargin:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                backgroundColor: Theme.of(context).primaryColor,
                color: Theme.of(context).secondaryHeaderColor,
                activeColor: Theme.of(context).secondaryHeaderColor,
                tabBorderRadius: 50,
                tabActiveBorder: Border.all(
                    color: Theme.of(context).secondaryHeaderColor, width: 1),
                curve: Curves.easeOutExpo,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                gap: 15,
                // onTabChange: (index) {print(index);},
                tabs: const [
                  GButton(
                    icon: Icons.home_outlined,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.groups_outlined,
                    text: 'Coops',
                  ),
                  GButton(
                    icon: Icons.store_mall_directory_outlined,
                    text: 'Market',
                  ),
                  GButton(
                    icon: Icons.person_outline_sharp,
                    text: 'Profile',
                  ),
                  GButton(
                    icon: Icons.settings_accessibility,
                    text: 'Menu',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
              },
              ),
            ),
          ),
        ));
  }
}
