import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? uid;
  String? title;
  String content;
  String author;
  int likes;
  int dislikes;
  List<String> comments;
  Timestamp timestamp;

  PostModel({
   this.uid,
    this.title,
    required this.content,
    required this.author,
    required this.likes,
    required this.dislikes,
    required this.comments,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'author': author,
      'likes': likes,
      'dislikes': dislikes,
      'comments': comments,
      'timestamp': timestamp,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'],
      content: json['content'],
      author: json['author'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      comments: List<String>.from(json['comments'] as List<dynamic>),
      timestamp: json['timestamp'] as Timestamp,
    );
  }
}
