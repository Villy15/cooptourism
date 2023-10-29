// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PollModel {
  String? uid;
  String optionText;
  int votes;
  List<String>? voters;
  DateTime? dateDeadline;  // added field
  String? optionId;  // added field

  PollModel({
    this.uid,
    required this.optionText,
    required this.votes,
    this.voters,
    this.dateDeadline,  // added field
    this.optionId,  // added field
  });

  PollModel copyWith({
    String? uid,
    String? optionText,
    int? votes,
    List<String>? voters,
    DateTime? dateDeadline,  // added field
    String? optionId,  // added field
  }) {
    return PollModel(
      uid: uid ?? this.uid,
      optionText: optionText ?? this.optionText,
      votes: votes ?? this.votes,
      voters: voters ?? this.voters,
      dateDeadline: dateDeadline ?? this.dateDeadline,  // added field
      optionId: optionId ?? this.optionId,  // added field
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'uid': uid,
      'optionText': optionText,
      'votes': votes,
      'voters': voters,
      'dateDeadline': dateDeadline?.toIso8601String(),  // added field
      'optionId': optionId,  // added field
    };
  }

  factory PollModel.fromMap(String id, Map<String, dynamic> map) {
    return PollModel(
      uid: id,
      optionText: map['optionText'] as String,
      votes: map['votes'] as int,
      voters: map['voters'] != null ? (map['voters'] as List).cast<String>() : null,
      dateDeadline: map['dateDeadline'] != null
          ? map['dateDeadline'] is Timestamp 
            ? (map['dateDeadline'] as Timestamp).toDate()
            : DateTime.parse(map['dateDeadline'] as String)
          : null, // Convert Timestamp to DateTime// added field
      optionId: map['optionId'] as String?,  // added field
    );
  }

  String toJson() => json.encode(toMap());

  factory PollModel.fromJson(String source) =>
      PollModel.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PollModel(uid: $uid, optionText: $optionText, votes: $votes, voters: $voters, dateDeadline: $dateDeadline, optionId: $optionId)';  // modified
  }
}
