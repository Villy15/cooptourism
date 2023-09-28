import 'package:cloud_firestore/cloud_firestore.dart';
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
  }

  void _submitForm() async {
    
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    // final user = FirebaseAuth.instance.currentUser;
    // final author = user?.displayName ?? 'Anonymous';

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
                Icon(Icons.account_circle, size: 40, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                 Text(
                  'Adrian Villanueva',
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
              style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary),
              // Add color to text background
              cursorColor: primaryColor,
              focusNode: _contentFocusNode,
            ),
          ],
        ),
      ),
    );
  }
}