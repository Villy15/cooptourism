import 'package:flutter/material.dart';

class ManagerHomePage extends StatefulWidget {
  const ManagerHomePage({super.key});

  @override
  State<ManagerHomePage> createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Home"),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Text("Test")
            
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(right: 16.0),
      //     child: CircleAvatar(
      //       backgroundColor: Colors.grey.shade300,
      //       child: IconButton(
      //         onPressed: () {
      //           // showAddPostPage(context);
      //         },
      //         icon: const Icon(Icons.settings, color: Colors.white),
      //       ),
      //     ),
      //   ),
      // ],
    );
  }
}