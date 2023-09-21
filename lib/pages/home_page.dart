import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Home",
            style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          ),
          iconTheme:
              IconThemeData(color: Theme.of(context).secondaryHeaderColor),
        ),
        drawer: Container(
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
  }
}
