import 'dart:convert';

class PollPostModel {
  String? uid;
  String title;
  List<String>? options;
  Map<String, List<String>>? votes;

  PollPostModel({
    this.uid,
    required this.title,
    this.options,
    this.votes
  });

  PollPostModel copyWith({
    String? uid,
    String? title,
    List<String>? options,
    Map<String, List<String>>? votes,
  }) {
    return PollPostModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      options: options ?? this.options,
      votes: votes ?? this.votes,
    );
  }

  // Convert a Poll to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'options': options,
      'votes': votes,
    };
  }

  // Convert a Map to a Poll
  // add null check
  factory PollPostModel.fromMap(String id, Map<String, dynamic> map) {
    return PollPostModel(
      uid: id,
      title: map['title'],
      options: List<String>.from(map['options']),
      votes: Map<String, List<String>>.from(map['votes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PollPostModel.fromJson(String id, Map<String, dynamic> data) =>
      PollPostModel.fromMap(id, data);

  // factory PollPostModel.fromJson(String source, Map<String, dynamic> data) =>
  //     PollPostModel.fromMap('',json.decode(source));

  @override
  String toString() {
    return 'PollPostModel(uid: $uid, title: $title, options: $options, votes: $votes)';
  }

}
