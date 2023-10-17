import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/widgets/display_featured.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ManagerProfileView extends StatefulWidget {
  ManagerProfileView({Key? key, required this.member}) : super(key: key);

  final String member;

  @override
  State<ManagerProfileView> createState() => _ManagerProfileViewState();
}

class _ManagerProfileViewState extends State<ManagerProfileView> {
  final userRepository = UserRepository();
  late String _userUID = ' ';

  @override
  void initState() {
    super.initState();
    _fetchUserUID(widget.member);
  }

  Future<void> _fetchUserUID (String memberName) async {
    // memberName to be split
    String firstName = memberName.split(' ')[0];
    String lastName = memberName.split(' ')[1];

    final userUID = await userRepository.getUserUIDByNames(firstName, lastName);
    
    setState(() {
      _userUID = userUID;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: userRepository.getUser(_userUID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return Stack(
            children: [
              Container(
                color: Theme.of(context).colorScheme.primary,
                height: 150
              ),

              const SizedBox(height: 16),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 85.0),
                      child: Center(
                        child: user.profilePicture != null ? DisplayProfilePicture(
                          storageRef: FirebaseStorage.instance.ref(),
                          coopId: _userUID,
                          data: user.profilePicture,
                          height: 100,
                          width: 100,
                        ) : Icon (
                          Icons.person,
                          size: 300,
                          color: Theme.of(context).colorScheme.secondary
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Center(
                      child: Text('${user.firstName} ${user.lastName}',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary
                        )
                      ),
                    ),
                    
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        '${user.userAccomplishment}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary
                        )
                      ),
                    ),

                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'About',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary
                        )
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Text(
                        user.bio ?? 'Bio',
                        style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).colorScheme.primary
                        )
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Featured',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary
                        )
                      ),
                    ),
                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: user.featuredImgs?.length ?? 0,
                          separatorBuilder: (context, index) => SizedBox(
                            width: 5,
                            height: 0.5,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                              ),
                            )
                          ),
                          itemBuilder: (context, index) {
                            final featuredImg = user.featuredImgs![index];
                            return Container(
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                color: Theme.of(context).colorScheme.secondary, 
                                width: 2
                                )
                              ),
                              child: DisplayFeatured(storageRef: FirebaseStorage.instance.ref(), userID: _userUID, data: featuredImg, height: 150, width: 200)
                            );
                          },
                        )
                      ),
                    )
                  ]
                ),
            ],
          );
        }
        else if (snapshot.hasError) {
          return const Text('Error loading data');
        }
        else {
          return const CircularProgressIndicator();
        }
      }
    );

  }
}