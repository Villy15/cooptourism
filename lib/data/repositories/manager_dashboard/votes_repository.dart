import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/manager_dashboard.dart/votes.dart';
import 'package:cooptourism/data/models/poll.dart';
import 'package:flutter/material.dart';

class VoteRepository {
  final CollectionReference voteCollection =
      FirebaseFirestore.instance.collection('votes');
  
  CollectionReference getPollSubCollection(String voiteId) {
    return voteCollection.doc(voiteId).collection('polls');
  }

  // Get All Stream Votes and sort it by date desc and name asc
  Stream<List<VoteModel>> getAllVotes() {
    return voteCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => VoteModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Add Vote
  Future<void> addVote(VoteModel vote, List<PollModel> polls) async {
    try {
      // Add the vote to the voteCollection and get the DocumentReference
      DocumentReference voteDocRef = await voteCollection.add(vote.toMap());

      // Loop through the polls list and add each poll to the polls subcollection
      for (var poll in polls) {
        debugPrint("poll: ${poll.toString()}");
        await voteDocRef.collection('polls').add(poll.toMap());
      }
    } catch (e) {
      debugPrint('Error adding vote to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }


  Stream<List<PollModel>> getAllPolls(String? voteId) {
    return getPollSubCollection(voteId!).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PollModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update a poll in a post
  Future<void> updatePoll(String? voteId, String? pollId, PollModel poll) async {
    try {
      await getPollSubCollection(voteId!).doc(pollId).update(poll.toMap());

      // Get the length of the
    } catch (e) {
      debugPrint('Error updating poll in Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // Add vote manually
  Future<void> addVoteManually() async {
    try {
      List<Map<String, dynamic>> votes = [
        {
          'title': 'President',
          'description': 'Vote for president',
          'date': DateTime(2023, 11, 8, 17, 30),
        },
        {
          'title': 'Vice President',
          'description': 'Vote for vice president',
          'date': DateTime(2023, 11, 8, 17, 30),
        },
        {
          'title': 'Secretary',
          'description': 'Vote for secretary',
          'date': DateTime(2023, 11, 8, 17, 30),
        },
        {
          'title': 'Treasurer',
          'description': 'Vote for treasurer',
          'date': DateTime(2023, 11, 8, 17, 30),
        },
        {
          'title': 'Auditors',
          'description': 'Vote for auditors',
          'date': DateTime(2023, 11, 8, 17, 30),
        }
      ];

      for (var vote in votes) {
        await voteCollection.add(vote);
      }

    } catch (e) {
      debugPrint('Error adding vote to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }
}