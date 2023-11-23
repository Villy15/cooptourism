import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/poll_posts.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/data/models/user.dart';
// import 'package:cooptourism/data/models/user_chart.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  AddPostPageState createState() => AddPostPageState();
}

class AddPostPageState extends State<AddPostPage> {
  final _contentController = TextEditingController();
  final _contentFocusNode = FocusNode();
  final _postRepository = PostRepository();

  // Add type anotation
  late final UserModel userPosting;

  List<TextEditingController> _optionController = [
    TextEditingController(),
  ];
  TextEditingController _pollTitleController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Request focus when the page is initially loaded
    _contentFocusNode.requestFocus();
    getUser();
  }

  Future<void> getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final userRepository = UserRepository();
    final userName = await userRepository.getUser(user!.uid);

    setState(() {
      userPosting = userName;
      debugPrint('user uid is: ${userPosting.uid}');
    });
  }

  void _submitForm() async {
    final author = '${userPosting.firstName!} ${userPosting.lastName!}';
    final content = _contentController.text.trim();
    final timestamp = Timestamp.now();
    if (content.isNotEmpty &&
        _pollTitleController.text.isEmpty &&
        _optionController.isEmpty) {
      try {
        final post = PostModel(
          uid: '',
          author: author,
          authorId: userPosting.uid,
          authorType: userPosting.role,
          content: content,
          likes: [],
          dislikes: [],
          comments: [],
          timestamp: timestamp,
          images: [],
        );

        await _postRepository.addPost(post);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post added successfully!'),
            ),
          );

          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        }

        // Navigate back to the home feed page
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add post!'),
            ),
          );
        }
      } finally {
        // Clear the text field
        _contentController.clear();
        // Request focus again
        _contentFocusNode.requestFocus();
        // Close the keyboard
      }
    } else if (content.isNotEmpty &&
        _pollTitleController.text.isNotEmpty &&
        _optionController.isNotEmpty) {
      try {
        final author = '${userPosting.firstName!} ${userPosting.lastName!}';
        final content = _contentController.text.trim();
        final timestamp = Timestamp.now();

        final post = PostModel(
          uid: '',
          author: author,
          authorId: userPosting.uid,
          authorType: userPosting.role,
          content: content,
          likes: [],
          dislikes: [],
          comments: [],
          timestamp: timestamp,
          images: [],
        );

        final poll = PollPostModel(
          uid: '',
          title: _pollTitleController.text.trim(),
          options: _optionController.map((e) => e.text.trim()).toList(),
          votes: {
            for (var e in _optionController.map((e) => e.text.trim()).toList())
              e: []
          },
        );

        final String postId = await _postRepository.addPost(post);
        await _postRepository.addPollPost(postId, poll);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post added successfully!'),
            ),
          );

          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        }        


      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add post!'),
            ),
          );
        }
      } finally {
        // Clear the text field
        _contentController.clear();
        // Request focus again
        _contentFocusNode.requestFocus();
        // Close the keyboard
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Add Post',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: createPoll,
            icon: const Icon(Icons.poll_sharp, color: Colors.white),
          ),
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.post_add),
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle,
                    size: 40, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '${userPosting.firstName!} ${userPosting.lastName!}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                border: InputBorder.none,
              ),
              maxLines: null,
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).colorScheme.primary),
              // Add color to text background
              cursorColor: primaryColor,
              focusNode: _contentFocusNode,
            ),
          ],
        ),
      ),
    );
  }

  void createPoll() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create a poll'),
              actions: [
                TextButton(
                  child: const Text('Create'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    // clears the _optionController list and polls title
                    _pollTitleController.clear();
                    _optionController.clear();
                    _optionController.add(TextEditingController());
                    Navigator.of(context).pop();
                  },
                ),
              ],
              content: Column(
                children: [
                  TextFormField(
                    controller: _pollTitleController,
                    decoration: const InputDecoration(
                      hintText: 'Poll Title',
                    ),
                  ),
                  ..._optionController.asMap().entries.map((entry) {
                    int index = entry.key;
                    TextEditingController controller = entry.value;
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'Option ${index + 1}',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _optionController.removeAt(index);
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),
                  TextButton(
                    child: const Text('Add option'),
                    onPressed: () {
                      setState(() {
                        _optionController.add(TextEditingController());
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
