import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? uid;
  String? authorId;
  String? authorType;
  String? title;
  String? content;
  String? author;
  List<String>? likes;
  List<String>? dislikes;
  List<String>? comments;
  // CollectionReference? comments;
  Timestamp timestamp;
  List<String>? images;

  PostModel({
    this.uid,
    this.title,
    this.authorId,
    this.authorType,
    this.content,
    this.author,
    this.likes,
    this.dislikes,
    this.comments,
    required this.timestamp,
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'authorId': authorId,
      'authorType': authorType,
      'content': content,
      'author': author,
      'likes': likes,
      'dislikes': dislikes,
      'comments': comments,
      'timestamp': timestamp.toDate().toIso8601String(),
      'images': images,
    };
  }

  factory PostModel.fromJson(String uid, Map<String, dynamic> json) {
    return PostModel(
      uid: uid,
      title: json['title'],
      authorId: json['authorId'],
      authorType: json['authorType'],
      content: json['content'],
      author: json['author'],
      likes: json['likes'] is List<dynamic> ? List<String>.from(json['likes'] as List<dynamic>) : null,
      dislikes: json['dislikes'] is List<dynamic> ? List<String>.from(json['dislikes'] as List<dynamic>) : null,
      comments: json['comments'] is List<dynamic> ? List<String>.from(json['comments'] as List<dynamic>) : null,
      // comments: FirebaseFirestore.instance.collection('posts').doc(uid).collection('comments'),
      timestamp: json['timestamp'] as Timestamp,
      images: List<String>.from(json['images'] as List<dynamic>),
    );
  }

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      uid: doc.id,
      author: data['author'],
      authorId: data['authorId'],
      authorType: data['authorType'],
      content: data['content'],
      likes: data['likes'],
      dislikes: data['dislikes'],
      comments: data['comments'],
      // comments: FirebaseFirestore.instance.collection('posts').doc(doc.id).collection('comments'),
      timestamp: data['timestamp'] as Timestamp,
      images: (data['images'] as List<dynamic>?)?.cast<String>(),
    );
  }
}
