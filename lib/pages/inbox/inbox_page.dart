import 'package:flutter/material.dart';
import 'package:cooptourism/widgets/user_item.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';

class InboxPage extends StatelessWidget {
  final UserRepository userRepository = UserRepository();

  InboxPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Inbox"),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder<List<UserModel>>(
        stream: userRepository.getAllUsers(),
        builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<UserModel> users = snapshot.data ?? [];
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: users.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => UserItem(user: users[index]),
            );
          }
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title, style: TextStyle(fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                // showAddPostPage(context);
              },
              icon: const Icon(Icons.message, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
