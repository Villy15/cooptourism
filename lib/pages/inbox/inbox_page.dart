import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cooptourism/widgets/user_item.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InboxPage extends ConsumerStatefulWidget {
  const InboxPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InboxPageState();
}


class _InboxPageState extends ConsumerState<InboxPage> {
  final userRepository = UserRepository();
  User? user;

  final List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _fetchMembers();

    Future.delayed(Duration.zero, () {
      _updateNavBarAndAppBarVisibility(false);
    });
  }

  // get all users with the role of Member from firestore
  Future<void> _fetchMembers() async {
    final members = await userRepository.getUsersByRole('Member');

    setState(() {
    _users.addAll(members.where((member) => member.uid != user?.uid));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {  
        _updateNavBarAndAppBarVisibility(true);
        return true;
      },
      child: Scaffold(
        appBar: _appBar(context, 'Inbox'),
        body: SingleChildScrollView(
          child: ListView.separated(
            itemCount: _users.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            // display user full name
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(24)
                  ),
                  child: _users[index].profilePicture != null && _users[index].profilePicture!.isNotEmpty
                        ? DisplayProfilePicture(
                          storageRef: FirebaseStorage.instance.ref(), 
                          coopId: _users[index].uid!, 
                          data: _users[index].profilePicture, 
                          height: 50, 
                          width: 50
                        ) : Icon (Icons.person, size: 50, color: Theme.of(context).colorScheme.primary),
                ),
                title: Text(
                  '${_users[index].firstName} ${_users[index].lastName}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  context.go('/inbox_page/${_users[index].uid!}');
                }
              );
            },
          ),
        )
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title, style: TextStyle(fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          // _updateNavBarAndAppBarVisibility(true);
          // Navigator.of(context).pop();
        }
      ),
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

  void _updateNavBarAndAppBarVisibility(bool isVisible) {
    ref.read(navBarVisibilityProvider.notifier).state = isVisible;
    ref.read(appBarVisibilityProvider.notifier).state = isVisible;
  }
  
  
}

