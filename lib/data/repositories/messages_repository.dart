import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/message.dart';
import 'package:flutter/material.dart';

class MessageRepository {
  final CollectionReference coachingMsgCollection =
      FirebaseFirestore.instance.collection('coaching_messages');
  final CollectionReference inboxMsgCollection =
      FirebaseFirestore.instance.collection('inbox_messages');

  // get one chat room from firestore with chatRoomId
  Future<List<MessageModel>> getOneCoachingRoom(
      String userId, String receiverId) async {
    String chatRoomId = '';
    List<String> combineIds = [userId, receiverId];
    combineIds.sort();
    chatRoomId = combineIds.join('_');

    try {
      final snapshot = await coachingMsgCollection
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timeStamp', descending: false)
          .get();
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      debugPrint('Error getting chat room from Firestore: $e');
      // You might want to handle errors more gracefully here
      return [];
    }
  }

  // get one chat room from firestore with chatRoomId
  Future<List<MessageModel>> getOneChatRoom(
      String userId, String receiverId) async {
    String chatRoomId = '';
    List<String> combineIds = [userId, receiverId];
    combineIds.sort();
    chatRoomId = combineIds.join('_');

    try {
      final snapshot = await inboxMsgCollection
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timeStamp', descending: false)
          .get();
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      debugPrint('Error getting chat room from Firestore $e');
      return [];
    }
  }

  // get messages from firestore
  Stream<List<MessageModel>> getAllCoachingMsgs(
      String senderId, String receiverId) {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String coachMsgId = ids.join('_');
    return coachingMsgCollection
        .doc(coachMsgId)
        .collection('messages')
        .where(Filter.and(
            Filter.or(Filter('senderId', isEqualTo: senderId),
                Filter('senderId', isEqualTo: receiverId)),
            Filter.or(Filter('receiverId', isEqualTo: senderId),
                Filter('receiverId', isEqualTo: receiverId))))
        .orderBy('timeStamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Stream<List<MessageModel>> getAllInboxMsgs(
      String senderId, String receiverId) {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String inboxMsgId = ids.join('_');

    return inboxMsgCollection
        .doc(inboxMsgId)
        .collection('messages')
        .where(Filter.and(
            Filter.or(Filter('senderId', isEqualTo: senderId),
                Filter('senderId', isEqualTo: receiverId)),
            Filter.or(Filter('receiverId', isEqualTo: senderId),
                Filter('receiverId', isEqualTo: receiverId))))
        .orderBy('timeStamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Add a message to Firestore
  Future<void> addCoachMsg(
      MessageModel message, String userId, String receiverId) async {
    try {
      List<String> ids = [userId, receiverId];
      ids.sort();
      String coachMsgId = ids.join('_');
      await coachingMsgCollection
          .doc(coachMsgId)
          .collection('messages')
          .add(message.toMap());
    } catch (e) {
      debugPrint('Error adding Listing to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  Future<void> addInboxMsg(
      MessageModel message, String userId, String receiverId) async {
    try {
      List<String> ids = [userId, receiverId];
      ids.sort();
      String inboxMsgId = ids.join('_');
      await inboxMsgCollection
          .doc(inboxMsgId)
          .collection('messages')
          .add(message.toMap());
    } catch (e) {
      debugPrint('Error adding Listing to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
  }

  // create chat room for a group chat
  Future<void> createGroupChat(List<String> userId, String coachId) async {
    List<String> combineIds = userId;
    combineIds.add(coachId);
    combineIds.sort();
    String chatRoomId = combineIds.join('_');

    try {
      await coachingMsgCollection.doc(chatRoomId).set({
        'chatRoomId': chatRoomId,
        'userIds': userId,
        'coachId': coachId,
      });
    } catch (e) {
      debugPrint('Error adding event to Firestore: $e');
      // You might want to handle errors more gracefully here
    }
    
  }
  // add manually
  Future<void> addCoachMessageManually() async {
    List<Map<String, dynamic>> events = [
      {
        'senderId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'receiverId': 'Vy4YiXQBhuNZu3sHeSel',
        'content': 'Hello! I am interested in coaching!',
        'timeStamp': DateTime.now(),
      },
      {
        'senderId': 'Vy4YiXQBhuNZu3sHeSel',
        'receiverId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'content': 'Oh yes. I am available.',
        'timeStamp': DateTime.now(),
      }
    ];

    List<String> combineIds = [
      'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
      'Vy4YiXQBhuNZu3sHeSel'
    ];
    combineIds.sort();
    String chatRoomId = combineIds.join('_');

    for (var event in events) {
      try {
        await coachingMsgCollection
            .doc(chatRoomId)
            .collection('messages')
            .add(event);
      } catch (e) {
        debugPrint('Error adding event to Firestore: $e');
        // You might want to handle errors more gracefully here
      }
    }
  }

  Future<void> addInboxMsgManually() async {
    List<Map<String, dynamic>> events = [
      {
        'senderId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'receiverId': 'zGcuP5yECrdmX3Qns58MIxaWn9Q2',
        'content': 'Hello, Villy! Kamusta ka? :)',
        'timeStamp': DateTime.now(),
      },
      {
        'senderId': 'zGcuP5yECrdmX3Qns58MIxaWn9Q2',
        'receiverId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'content': 'Ok naman. doing Capstone ATM...',
        'timeStamp': DateTime.now(),
      }
    ];

    List<String> combineIds = [
      'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
      'zGcuP5yECrdmX3Qns58MIxaWn9Q2'
    ];
    combineIds.sort();
    String chatRoomId = combineIds.join('_');

    for (var event in events) {
      try {
        await inboxMsgCollection
            .doc(chatRoomId)
            .collection('messages')
            .add(event);
      } catch (e) {
        debugPrint('Error adding event to Firestore: $e');
        // You might want to handle errors more gracefully here
      }
    }
  }
}
