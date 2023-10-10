import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:cooptourism/widgets/display_logo.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:cooptourism/widgets/post_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SelectedCoopPage extends StatefulWidget {
  final String coopId;
  const SelectedCoopPage({super.key, required this.coopId});

  @override
  State<SelectedCoopPage> createState() => _SelectedCoopPageState();
}

class _SelectedCoopPageState extends State<SelectedCoopPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final storageRef = FirebaseStorage.instance.ref();
    final CooperativesRepository cooperativeRepository =
        CooperativesRepository();
    final PostRepository postRepository = PostRepository();

    final Stream<List<PostModel>> coopPosts =
        postRepository.getSpecificPosts(widget.coopId);
    final Future<CooperativesModel> cooperative =
        cooperativeRepository.getCooperative(widget.coopId);

    return FutureBuilder(
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
                    automaticallyImplyLeading: false,
                    expandedHeight: 240,
                    pinned: false,
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        children: [
                          DisplayLogo(
                            storageRef: storageRef,
                            coopId: widget.coopId,
                            data: cooperative.logo,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                DisplayProfilePicture(
                                  storageRef: storageRef,
                                  coopId: widget.coopId,
                                  data: cooperative.profilePicture,
                                  height: 50.0,
                                  width: 50.0,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cooperative.name ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          softWrap: true,
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.fontSize),
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
                                ),
                                OutlinedButton(
                                  onPressed: () async {
                                    await showDialog<void>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                                content: Stack(
                                              clipBehavior: Clip.none,
                                              children: <Widget>[
                                                Positioned(
                                                  right: -40,
                                                  top: -40,
                                                  child: InkResponse(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const CircleAvatar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      child: Icon(Icons.close),
                                                    ),
                                                  ),
                                                ),
                                                Form(
                                                  key: formKey,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: TextFormField(),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: TextFormField(),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: TextFormField(),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: ElevatedButton(
                                                          child: const Text(
                                                              'Submitß'),
                                                          onPressed: () {
                                                            if (formKey
                                                                .currentState!
                                                                .validate()) {
                                                              formKey
                                                                  .currentState!
                                                                  .save();
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )));
                                  },
                                  child: const Text("Join"),
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

                      return PostCard(
                          key: ValueKey(coopPost.uid),
                          author: coopPost.author,
                          authorId: coopPost.authorId,
                          authorType: coopPost.authorType,
                          content: coopPost.content,
                          likes: coopPost.likes,
                          dislikes: coopPost.dislikes,
                          comments: coopPost.comments,
                          timestamp: coopPost.timestamp,
                          images: coopPost.images);
                    },
                  ),
                ],
              );
            },
          );
        });
  }
}
