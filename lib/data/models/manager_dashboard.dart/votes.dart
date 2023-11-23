// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class VoteModel {
  String? uid;
  final String title;
  final String description;
  final DateTime date;
  String? category;
  VoteModel({
    this.uid,
    required this.title,
    required this.description,
    required this.date,
    this.category,
  });

  VoteModel copyWith({
    String? uid,
    String? title,
    String? description,
    DateTime? date,
    String? category,
  }) {
    return VoteModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'category': category ?? '',
    };
  }

  factory VoteModel.fromMap(String id, Map<String, dynamic> map) {
    return VoteModel(
      uid: id,
      title: map['title'] as String,
      description: map['description'] as String,
      date: (map['date'] as Timestamp).toDate(),
      category: map['category'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory VoteModel.fromJson(String source) =>
      VoteModel.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VoteModel(uid: $uid, title: $title, description: $description, date: $date)';
  }

  @override
  bool operator ==(covariant VoteModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.title == title &&
        other.description == description &&
        other.date == date;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ title.hashCode ^ description.hashCode ^ date.hashCode;
  }
}
