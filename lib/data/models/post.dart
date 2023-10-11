import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? uid;
  String? authorId;
  String? authorType;
  String? title;
  String content;
  String author;
  int likes;
  int dislikes;
  List<String> comments;
  Timestamp timestamp;
  List<String>? images;

  PostModel({
    this.uid,
    this.title,
    this.authorId,
    this.authorType,
    required this.content,
    required this.author,
    required this.likes,
    required this.dislikes,
    required this.comments,
    required this.timestamp,
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'authorId': authorId,
      'authorType': authorType,
      'content': content,
      'author': author,
      'likes': likes,
      'dislikes': dislikes,
      'comments': comments,
      'timestamp': timestamp,
      'images': images,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'],
      authorId: json['authorId'],
      authorType: json['authorType'],
      content: json['content'],
      author: json['author'],
      likes: json['likes'],
      dislikes: json['dislikes'] ?? 0,
      comments: List<String>.from(json['comments'] as List<dynamic>),
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
      comments: (data['comments'] as List<dynamic>?)!.cast<String>(),
      timestamp: data['timestamp'] as Timestamp,
      images: (data['images'] as List<dynamic>?)?.cast<String>(),
    );
  }
}
