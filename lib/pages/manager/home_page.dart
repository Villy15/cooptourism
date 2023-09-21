import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePageManager extends StatefulWidget {
  const HomePageManager({super.key});

  @override
  State<HomePageManager> createState() => _HomePageManagerState();
}

class _HomePageManagerState extends State<HomePageManager> {
  void signOut() async {
    FirebaseAuth.instance.signOut();
  }



  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            "Home",
            style: TextStyle(color: Color(0xff667080)),
          ),
          iconTheme:
              IconThemeData(color: Theme.of(context).secondaryHeaderColor),
        ),
        bottomNavigationBar: GNav(
          backgroundColor: Theme.of(context).primaryColor,
          color: Theme.of(context).secondaryHeaderColor,
          activeColor: Theme.of(context).secondaryHeaderColor,
          // tabBackgroundColor: ,
          // tabActiveBorder: ,
          padding: const EdgeInsets.all(16),
          gap: 15,
          tabs: const [
            GButton(icon: Icons.home, text: 'Home',),
            GButton(icon: Icons.groups_outlined, text: 'Dashboard'),
            GButton(icon: Icons.search, text: 'Members'),
            GButton(icon: Icons.settings, text: 'Reports'),
            GButton(icon: Icons.settings, text: 'Inbox')
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        drawer: SizedBox(
          width: 250,
          child: Drawer(
              backgroundColor: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  ListView(shrinkWrap: true, children: [
                    DrawerHeader(
                        child: Center(
                      child: Text("Turistanginamo",
                          style: Theme.of(context).textTheme.headlineMedium),
                    )),
                    ListTile(
                      leading: const Icon(Icons.home),
                      iconColor: Theme.of(context).secondaryHeaderColor,
                      title: Text(
                        "Home",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.groups_outlined),
                                            iconColor: Theme.of(context).secondaryHeaderColor,
                      title: Text(
                        "Cooperatives",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      onTap: () {},
                    ),
                  ]),
                  Expanded(
                      child: Align(
                    alignment: FractionalOffset.bottomLeft,
                    child: ListTile(
                      leading: const Icon(Icons.logout),
                                            iconColor: Theme.of(context).secondaryHeaderColor,
                      title: Text(
                        "Logout",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      onTap: signOut,
                    ),
                  ))
                ],
              )),
        ));
        // ));
  }
}