// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/providers/home_page_provider.dart';
import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:cooptourism/widgets/leading_back_button.dart';
import 'package:cooptourism/widgets/post_card.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final PostRepository postRepository = PostRepository();

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
                                        // StreamBuilder(
                                        //   stream: cooperativesStream
                                        //       .collection('members')
                                        //       .snapshots(),
                                        //   builder: (BuildContext context,
                                        //       AsyncSnapshot<QuerySnapshot> snapshot) {
                                        //     final docs = snapshot.data?.docs;
                                        //     return Text(
                                        //       '${docs?.length}' ' members',
                                        //       style: const TextStyle(fontSize: 12),
                                        //     );
                                        //   },
                                        // ),
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
                                    child: const Icon(
                                      Icons.handshake,
                                      color: Colors.white,
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
