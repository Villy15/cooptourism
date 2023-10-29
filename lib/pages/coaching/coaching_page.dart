import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CoachingPage extends ConsumerStatefulWidget {
  const CoachingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoachingPageState();
}

class _CoachingPageState extends ConsumerState<CoachingPage> {
  final userRepository = UserRepository();
  User? user;

  final List<UserModel> _coaches = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _fetchCoaches();
    // userRepository.addMessageManually();
    Future.delayed(Duration.zero, () {
      _updateNavBarAndAppBarVisibility(false);
    });
  }

  // get coaches from firestore
  Future<void> _fetchCoaches() async {
    final coaches = await userRepository.getUsersByRole('Coach');

    setState(() {
      _coaches.addAll(coaches);
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
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: ListView.builder(
            itemCount: _coaches.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // display coach full name
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  height: 50, 
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: _coaches[index].profilePicture != null && _coaches[index].profilePicture!.isNotEmpty 
                           ? DisplayProfilePicture(
                            storageRef: FirebaseStorage.instance.ref(), 
                            coopId: _coaches[index].uid!,
                            data: _coaches[index].profilePicture, 
                            height: 50, 
                            width: 50) : Icon (Icons.person, size: 50, color: Theme.of(context).colorScheme.primary),
                ),
                title: Text(
                  '${_coaches[index].firstName} ${_coaches[index].lastName}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  )
                ),
                subtitle: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${_coaches[index].userAccomplishment}', 
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 14
                          )
                        ),
                      )
                    ),
                    
                    const SizedBox(width: 10),
                  ],
                ),
                onTap: () {
                  context.go('/profile_page/coaching_page/${_coaches[index].uid}');
                },
              );
            },
          )
        )
      ),
    );
  }



  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Available Coaches'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          _updateNavBarAndAppBarVisibility(true);
          Navigator.of(context).pop(); // to go back
        },
      ),
    );
  }

  void _updateNavBarAndAppBarVisibility(bool isVisible) {
    ref.read(navBarVisibilityProvider.notifier).state = isVisible;
    ref.read(appBarVisibilityProvider.notifier).state = isVisible;
  }
}