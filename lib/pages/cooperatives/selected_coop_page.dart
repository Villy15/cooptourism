// import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:cooptourism/data/repositories/coopjoin_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:cooptourism/widgets/leading_back_button.dart';
import 'package:cooptourism/widgets/post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SelectedCoopPage extends ConsumerStatefulWidget {
  final String coopId;
  const SelectedCoopPage({super.key, required this.coopId});

  @override
  ConsumerState<SelectedCoopPage> createState() => _SelectedCoopPageState();
}

class _SelectedCoopPageState extends ConsumerState<SelectedCoopPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(appBarVisibilityProvider.notifier).state = false;
      ref.read(navBarVisibilityProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final storageRef = FirebaseStorage.instance.ref();
    final CooperativesRepository cooperativeRepository =
        CooperativesRepository();

    final userRepository = UserRepository();
    final PostRepository postRepository = PostRepository();
    final joinCooperativeRepository = JoinCooperativeRepository();

    final Stream<List<PostModel>> coopPosts =
        postRepository.getSpecificPosts(widget.coopId);
    final Future<CooperativesModel> cooperative =
        cooperativeRepository.getCooperative(widget.coopId);

    return Scaffold(
      body: FutureBuilder(
          future: cooperative,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final cooperative = snapshot.data!;

            return StreamBuilder<List<PostModel>>(
              stream: coopPosts,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final coopPosts = snapshot.data!;
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      leadingWidth: 45,
                      toolbarHeight: 35,
                      leading: LeadingBackButton(ref: ref),
                      expandedHeight: 300,
                      pinned: false,
                      floating: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          children: [
                            DisplayImage(
                              path:
                                  "${widget.coopId}/images/${cooperative.logo}",
                              height: 150,
                              width: double.infinity,
                              radius: BorderRadius.zero,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DisplayText(
                                          text: cooperative.name!,
                                          lines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: InkWell(
                                      onTap: () async {
                                        // check if user is already a member
                                        // if not, add user to members
                                        final currentUser = FirebaseAuth.instance.currentUser;
                                        final memberRef = await cooperativeRepository.getCooperativeMember(widget.coopId, currentUser!.uid);
                                        final isMember = memberRef.exists;
                                        final appRef = await joinCooperativeRepository.getFormUsingMemberUID(currentUser.uid, widget.coopId);
                                        final isApplicant = appRef?.exists;
                                        // verify isMember
                                        //
                                        // if isMember, show dialog
                                        //
                                        if (isMember) {
                                          // ignore: use_build_context_synchronously
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Already a member',
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary
                                                  )
                                                ),
                                                content: Text(
                                                  'You are already a member of this cooperative.',
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary
                                                  )
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }

                                        else if (isApplicant != null) {
                                          // ignore: use_build_context_synchronously
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Application Pending',
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary
                                                  )
                                                ),
                                                content: Text(
                                                  'Your application to join this cooperative is still pending.',
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary
                                                  )
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                        
                                        else {
                                          GoRouter.of(context).go('/coops_page/${widget.coopId}/join_coop');
                                        } 
                                      },
                                      child: const Icon(
                                        Icons.handshake,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                cooperative.profileDescription ?? "",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList.builder(
                      itemCount: coopPosts.length,
                      itemBuilder: (context, index) {
                        final coopPost = coopPosts[index];

                        return PostCard(postModel: coopPost);
                      },
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}
