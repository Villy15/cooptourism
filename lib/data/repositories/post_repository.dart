import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/poll.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:flutter/material.dart';

class PostRepository {
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  CollectionReference getPollSubCollection(String postId) {
    return postsCollection.doc(postId).collection('polls');
  }

  // Get all posts from Firestore
  Stream<List<PostModel>> getAllPosts() {
    return postsCollection.orderBy("timestamp", descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<PostModel>> getSpecificPosts(String authorId) {
    return postsCollection.where("authorId", isEqualTo: authorId).orderBy("timestamp", descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Add a post to Firestore
  Future<void> addPost(PostModel post) async {
    try {
      await postsCollection.add(post.toJson());
    } catch (e) {
      debugPrint('Error adding post to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Read a post from Firestore
  Future<PostModel> getPost(String postId) async {
    try {
      final doc = await postsCollection.doc(postId).get();
      return PostModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting post from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Update a post in Firestore
  Future<void> updatePost(String postId, PostModel post) async {
    try {
      await postsCollection.doc(postId).update(post.toJson());
    } catch (e) {
      debugPrint('Error updating post in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete a post from Firestore
  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
    } catch (e) {
      debugPrint('Error deleting post from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }


  // LIKES AND DISLIKES

  // Add a user in the likes list of a post
  Future<void> likePost(String? postId, String userId) async {
    try {
      await postsCollection.doc(postId).update({
        'likes': FieldValue.arrayUnion([userId])
      });

      debugPrint('Post liked in Firestore');
    } catch (e) {
      debugPrint('Error liking post in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Remove a user from the likes list of a post
  Future<void> unlikePost(String? postId, String userId) async {
    try {
      await postsCollection.doc(postId).update({
        'likes': FieldValue.arrayRemove([userId])
      });

      debugPrint('Post unliked in Firestore');
    } catch (e) {
      debugPrint('Error unliking post in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Add a user in the dislikes list of a post
  Future<void> dislikePost(String? postId, String userId) async {
    try {
      await postsCollection.doc(postId).update({
        'dislikes': FieldValue.arrayUnion([userId])
      });

      debugPrint('Post disliked in Firestore');
    } catch (e) {
      debugPrint('Error disliking post in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Remove a user from the dislikes list of a post
  Future<void> undislikePost(String? postId, String userId) async {
    try {
      await postsCollection.doc(postId).update({
        'dislikes': FieldValue.arrayRemove([userId])
      });

      debugPrint('Post undisliked in Firestore');
    } catch (e) {
      debugPrint('Error undisliking post in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Add dummy post
  Future<void> addDummyPost() async {
  try {
    // Add the post and get the reference
    DocumentReference postRef = await postsCollection.add({
      'author': 'Iwahori Multipurpose Cooperative',  // fixed typo from 'author:' to 'author'
      'authorId': 'sslvO5tgDoCHGBO82kxq',
      'authorType': 'cooperative',
      'comments': [],
      'content': "Dear Members and Stakeholders 📢, We're excited to bring to your attention the upcoming elections focused on tourism cooperatives under the Iwahori Multipurpose Cooperative banner. This is a pivotal moment as we aim to strengthen our commitment to promoting sustainable tourism and fostering a collaborative environment for all our members. Your participation and vote will guide the future direction of our tourism initiatives and ensure that we continue to thrive and serve our community effectively.",
      'likes': [],
      'dislikes': [],
      'timestamp': DateTime.now(),
    });

    debugPrint('Dummy post added to Firestore');

    // Now use the postRef.id (which is the postId) to add a poll
      List<Map<String, dynamic>> pollOptions = [
        {
          'optionText': 'Adrian Villanueva',
          'optionId' : 'zBUyW0hYTZRrCkp8PIDNlPvdlBy2',  // added field
          'votes': 5,
          'voters': ['user1', 'user2', 'user3', 'user4', 'user5'],
          'dateDeadline': DateTime.now().add(const Duration(days: 1)),  // added field
        },
        {
          'optionText': 'Timothy Mendoza',
          'optionId' : 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
          'votes': 3,
          'voters': ['user6', 'user7', 'user8'],
          'dateDeadline': DateTime.now().add(const Duration(days: 1)),
        },
        {
          'optionText': 'Anthony Paguio',
          'optionId' : 'G5nugbNv6hh1fcbuLc1Uwf785ls1',
          'votes': 4,
          'voters': ['user9', 'user10', 'user11', 'user12'],
          'dateDeadline': DateTime.now().add(const Duration(days: 1)),
        },
      ];

      for (var option in pollOptions) {
        await getPollSubCollection(postRef.id).add(option);
      }

  } catch (e) {
    debugPrint('Error adding dummy post to Firestore: $e');
    // You might want to handle errors more gracefully here
  }
}


  // POLL SUBCOLLECTION 
  // Stream all polls from a post
  Stream<List<PollModel>> getAllPolls(String? postId) {
    return getPollSubCollection(postId!).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PollModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Add a poll to a post
  Future<void> addPoll(String? postId, PollModel poll) async {
    try {
      await getPollSubCollection(postId!).add(poll.toJson());
    } catch (e) {
      debugPrint('Error adding poll to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Read a poll from a post
  Future<PollModel> getPoll(String? postId, String pollId) async {
    try {
      final doc = await getPollSubCollection(postId!).doc(pollId).get();
      return PollModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting poll from Firestore: $e');
      // You might want to handle errors more gracefully here
      rethrow;
    }
  }

  // Update a poll in a post
  Future<void> updatePoll(String? postId, String? pollId, PollModel poll) async {
    try {
      await getPollSubCollection(postId!).doc(pollId).update(poll.toMap());
    } catch (e) {
      debugPrint('Error updating poll in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Delete a poll from a post
  Future<void> deletePoll(String? postId, String pollId) async {
    try {
      await getPollSubCollection(postId!).doc(pollId).delete();
    } catch (e) {
      debugPrint('Error deleting poll from Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }
}
