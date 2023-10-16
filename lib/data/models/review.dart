import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? id;
  String? author;
  String? title;
  String? positiveDescription;
  String? negativeDescription;
  Timestamp? reviewDate;
  

  ReviewModel({
    this.id,
    this.author,
    this.title,
    this.positiveDescription,
    this.negativeDescription,
    this.reviewDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'title': title,
      'positiveDescription': positiveDescription,
      'negativeDescription': negativeDescription,
      'reviewDate': reviewDate,
    };
  }

  factory ReviewModel.fromJson(String id, Map<String, dynamic> json) {
    return ReviewModel(
      id: id,
      author: json['author'],
      title: json['title'],
      positiveDescription: json['positiveDescription'],
      negativeDescription: json['negativeDescription'],
      reviewDate: json['reviewDate'] as Timestamp,
    );
  }
}
