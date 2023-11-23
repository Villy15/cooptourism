import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cooptourism/controller/post_provider.dart';
import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:cooptourism/data/models/poll.dart';
import 'package:cooptourism/data/models/poll_posts.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final PostRepository postRepository = PostRepository();

class PostCard extends StatefulWidget {
  final PostModel postModel;

  const PostCard({super.key, required this.postModel});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String getTimeDifference() {
    final now = Timestamp.now().toDate();
    final postTime = widget.postModel.timestamp.toDate();
    final difference = now.difference(postTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      final formatter = DateFormat.yMd().add_jm();
      return formatter.format(postTime);
    }
  }

  User? user;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();

    final cooperativeRepository = CooperativesRepository();
    final userRepository = UserRepository();
    final authorId = widget.postModel.authorId ?? "";
    final isCooperative = widget.postModel.authorType == 'cooperative';
    final Future<dynamic> authorFuture = isCooperative
        ? cooperativeRepository.getCooperative(authorId)
        : userRepository.getUser(authorId);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // display picture accordingly if member or cooperative
                isCooperative
                    ? pfpCoop(
                        authorFuture as Future<CooperativesModel>, storageRef)
                    : pfpMember(authorFuture as Future<UserModel>, storageRef),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.postModel.author ?? "No Author",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      getTimeDifference(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.more_horiz,
                      color: Theme.of(context).colorScheme.primary, size: 26),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                widget.postModel.content!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 8),
            // ClipRRect(
            //   child: imageCache.getImageUrl(widget.authorId ?? "") != null
            //       ? Image.network(
            //           imageCache.getImageUrl(widget.authorId ?? "")!,
            //           height: 225,
            //           width: double.infinity,
            //           fit: BoxFit.cover,
            //         )
            //       : const SizedBox.shrink(),
            // ),
            // Add polling
            StreamBuilder<List<PollModel>>(
              stream: postRepository.getAllPolls(
                  widget.postModel.uid), // Assume uid is the post ID
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final polls = snapshot.data!;

                  if (polls.isEmpty) {
                    return const SizedBox.shrink(); // Returns an empty widget
                  }

                  return PollingWidget(polls: polls, post: widget.postModel);
                }
              },
            ),

            // StreamBuilder<List<PollPostModel>>(
            //     stream: postRepository.getAllPollPosts(widget.postModel.uid),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const CircularProgressIndicator();
            //       } else if (snapshot.hasError) {
            //         return Text('Error: ${snapshot.error}');
            //       } else {
            //         final pollPosts = snapshot.data!;

            //         if (pollPosts.isEmpty) {
            //           return const SizedBox.shrink(); // Returns an empty widget
            //         }

            //         return ListView.builder(
            //           physics: const NeverScrollableScrollPhysics(),
            //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
            //           shrinkWrap:
            //               true, // Makes the list view confined to its content
            //           itemCount: pollPosts.length,
            //           itemBuilder: (context, index) {
            //             final String uid = user!.uid;
            //             return Container(
            //               decoration: BoxDecoration(
            //                 borderRadius:
            //                     BorderRadius.circular(8.0), // Rounded corners
            //               ),
            //               child: Column(
            //                 children: [
            //                   ListTile(
            //                     title: Center(
            //                       child: Text(pollPosts[index].title,
            //                           style: const TextStyle()),
            //                     ),
            //                   ),
            //                   for (var i = 0;
            //                       i < pollPosts[index].options!.length;
            //                       i++)
            //                     CheckboxListTile(
            //                       title: Text(pollPosts[index].options![i]),
            //                       value: pollPosts[index]
            //                               .votes
            //                               ?.keys
            //                               .contains(uid) ??
            //                           false,
            //                       onChanged: (bool? value) {
            //                         setState(() {
            //                           final option =
            //                               pollPosts[index].options![i];

            //                           if (value!) {
            //                             debugPrint('i voted for $option');
            //                             pollPosts[index]
            //                                 .votes?[option]
            //                                 ?.add(uid);
            //                           } else {
            //                             // pollPosts[index].votes[option]?.remove(user!.uid);
            //                           }

            //                           //   postRepository.updatePollPost(
            //                           //       widget.postModel.uid,
            //                           //       pollPosts[index].uid,
            //                           //       pollPosts[index]);
            //                         });
            //                       },
            //                     )
            //                 ],
            //               ),
            //             );
            //           },
            //         );
            //       }
            //     }),

            ClipRRect(
              child: widget.postModel.images != null &&
                      widget.postModel.images!
                          .isNotEmpty // Check first if images is not null and not empty
                  ? FutureBuilder<String>(
                      future: storageRef
                          .child(
                              "${widget.postModel.authorId}/images/${widget.postModel.images?[0]}")
                          .getDownloadURL(),
                      builder: (context, urlSnapshot) {
                        if (urlSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (urlSnapshot.hasError) {
                          return Text('Error: ${urlSnapshot.error}');
                        }

                        final imageUrl = urlSnapshot.data;

                        return imageUrl != null
                            ? Image.network(
                                imageUrl,
                                height: 225,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container();
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
            postFunctions(context),
            // Add a horizontal line
            const Divider(height: 10, thickness: 1),
          ],
        ),
      ),
    );
  }

  Padding postFunctions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          LikeDislike(
              uid: widget.postModel.uid,
              likes: widget.postModel.likes,
              dislikes: widget.postModel.dislikes),
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.go('/posts/comments/${widget.postModel.uid}');
            },
            child: Icon(Icons.comment_outlined,
                color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 8),
          Text(
            widget.postModel.comments!.length.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Icon(Icons.share_outlined,
              color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }

  FutureBuilder<CooperativesModel> pfpCoop(
      Future<CooperativesModel> cooperative, Reference storageRef) {
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DisplayProfilePicture(
              storageRef: storageRef,
              coopId: widget.postModel.authorId ?? "",
              data: cooperative.profilePicture,
              height: 35.0,
              width: 35.0,
            ),
          );
        });
  }

  FutureBuilder<UserModel> pfpMember(
      Future<UserModel> user, Reference storageRef) {
    return FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final member = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DisplayProfilePicture(
              storageRef: storageRef,
              coopId: widget.postModel.authorId ?? "",
              data: member.profilePicture,
              height: 35.0,
              width: 35.0,
            ),
          );
        });
  }
}

class PollingWidget extends ConsumerStatefulWidget {
  final List<PollModel> polls;
  final PostModel post;

  const PollingWidget({Key? key, required this.polls, required this.post})
      : super(key: key);

  @override
  ConsumerState<PollingWidget> createState() => PollingWidgetState();
}

class PollingWidgetState extends ConsumerState<PollingWidget> {
  int? _selectedChoice;

  // @override
  // void initState() {
  //   super.initState();

  //   for (int i = 0; i < widget.polls.length; i++) {
  //     if (widget.polls[i].voters != null &&
  //         widget.polls[i].voters!.contains(user?.uid)) {
  //       _selectedChoice = i;
  //       break;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);
    // Only set _selectedChoice if it hasn't been set yet
    if (_selectedChoice == null) {
      for (int i = 0; i < widget.polls.length; i++) {
        if (widget.polls[i].voters != null &&
            widget.polls[i].voters!.contains(user?.uid)) {
          setState(() {
            _selectedChoice = i;
          });
          break;
        }
      }

      debugPrint("Selected choice: $_selectedChoice");
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Add padding around the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: Column(
        children: [
          // Display total votes at the top
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(16.0), // Add padding around the container
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0)), // Rounded corners
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.polls.fold(0, (sum, poll) => sum + poll.votes)} Total Votes',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MM/dd/yyyy, hh:mm a').format(widget.polls[0]
                          .dateDeadline!), // Format includes date and time/ Format as per your requirement
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
            decoration: const BoxDecoration(
              // Setting a background color
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0)), // Rounded corners
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              shrinkWrap: true, // Makes the list view confined to its content
              itemCount: widget.polls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(8.0), // Rounded corners
                    ),
                    child: ListTile(
                      title: Text(widget.polls[index].optionText,
                          style: const TextStyle()),
                      leading: Radio(
                        value: index,
                        groupValue: _selectedChoice,
                        onChanged: (int? value) {
                          setState(() {
                            // Check if the user is clicking on the same selected index
                            if (_selectedChoice == value) {
                              // Remove the user's vote
                              if (widget.polls[value!].voters != null) {
                                widget.polls[value].voters!.remove(user?.uid);
                                postRepository.updatePoll(
                                    widget.post.uid,
                                    widget.polls[value].uid,
                                    widget.polls[value]);
                              }
                              _selectedChoice =
                                  null; // Reset _selectedChoice to null
                              debugPrint("Vote removed for choice: $value");
                            } else {
                              // Remove the user's vote from the previously voted option
                              if (_selectedChoice != null &&
                                  widget.polls[_selectedChoice!].voters !=
                                      null) {
                                widget.polls[_selectedChoice!].voters!
                                    .remove(user?.uid);
                                debugPrint(
                                    "Current voters for choice $_selectedChoice: ${widget.polls[_selectedChoice!].voters}");
                                postRepository.updatePoll(
                                    widget.post.uid,
                                    widget.polls[_selectedChoice!].uid,
                                    widget.polls[_selectedChoice!]);
                              }

                              // Add the user's vote to the new selected option
                              if (widget.polls[value!].voters == null) {
                                widget.polls[value].voters = [];
                              }
                              widget.polls[value].voters!.add(user!.uid!);

                              // Set the selected choice to the new value
                              _selectedChoice = value;

                              postRepository.updatePoll(widget.post.uid,
                                  widget.polls[value].uid, widget.polls[value]);
                            }
                          });
                        },
                      ),
                      // Add trailing of a button of that shows View More Info
                      trailing: TextButton(
                        onPressed: () {
                          context.push(
                              '/profile_page/${widget.polls[index].optionId}');
                        },
                        child: const Text('View Profile'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LikeDislike extends ConsumerStatefulWidget {
  final String? uid;
  final List<String>? likes;
  final List<String>? dislikes;

  const LikeDislike({Key? key, this.uid, this.likes, this.dislikes})
      : super(key: key);

  @override
  ConsumerState createState() => LikeDislikeState();
}

class LikeDislikeState extends ConsumerState<LikeDislike> {
  final user = FirebaseAuth.instance.currentUser;
  PostRepository postRepository = PostRepository();
  bool isLiked = false;
  bool isDisliked = false;

  // function when pressing like, dislike, or comment
  void onPressLike() {
    // if isLiked
    if (isLiked) {
      postRepository.unlikePost(widget.uid, user!.uid);

      setState(() {
        isLiked = false; // Update the isLiked variable
      });
    } else {
      postRepository.likePost(widget.uid, user!.uid);

      setState(() {
        isLiked = true; // Update the isLiked variable
      });
    }
  }

  void onPressDislike() {
    // if isLiked
    if (isDisliked) {
      postRepository.undislikePost(widget.uid, user!.uid);

      setState(() {
        isDisliked = false; // Update the isLiked variable
      });
    } else {
      postRepository.dislikePost(widget.uid, user!.uid);

      setState(() {
        isDisliked = true; // Update the isLiked variable
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Check if the user has liked the post when the widget is first built
    if (widget.likes != null && user != null) {
      isLiked = widget.likes!.contains(user!.uid);
    }

    if (widget.dislikes != null && user != null) {
      isDisliked = widget.dislikes!.contains(user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onPressLike,
          child: Icon(
            Icons.thumb_up_alt_outlined,
            color: isLiked
                ? Colors.blue
                : Theme.of(context).colorScheme.primary, // Change the color
          ),
        ),
        const SizedBox(width: 8),
        Text(
          widget.likes?.length.toString() ?? '0',
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onPressDislike,
          child: Icon(
            Icons.thumb_down_alt_outlined,
            color: isDisliked
                ? Colors.red
                : Theme.of(context).colorScheme.primary, // Change the color
          ),
        ),
        const SizedBox(width: 8),
        Text(
          widget.dislikes?.length.toString() ?? '0',
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
