// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PollConcernsModel {
  String? uid;
  String optionText;
  int? votes;
  List<String>? concerns;
  String? optionId;  // added field

  PollConcernsModel({
    this.uid,
    required this.optionText,
    this.votes,
    this.concerns,
    this.optionId,  // added field
  });

  PollConcernsModel copyWith({
    String? uid,
    String? optionText,
    int? votes,
    List<String>? concerns,
    String? optionId,  // added field
  }) {
    return PollConcernsModel(
      uid: uid ?? this.uid,
      optionText: optionText ?? this.optionText,
      votes: votes ?? this.votes,
      concerns: concerns ?? this.concerns, 
      optionId: optionId ?? this.optionId,  // added field
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'uid': uid,
      'optionText': optionText,
      'votes': votes,
      'concerns': concerns,
      'optionId': optionId,  // added field
    };
  }

  factory PollConcernsModel.fromMap(String id, Map<String, dynamic> map) {
    return PollConcernsModel(
      uid: id,
      optionText: map['optionText'] as String,
      votes: map['votes'] as int,
      concerns: map['concerns'] != null ? (map['concerns'] as List).cast<String>() : null,
      optionId: map['optionId'] as String?,  // added field
    );
  }

  String toJson() => json.encode(toMap());

  factory PollConcernsModel.fromJson(String source) =>
      PollConcernsModel.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PollModel(uid: $uid, optionText: $optionText, votes: $votes, concerns: $concerns, optionId: $optionId)';  // modified
  }
}
