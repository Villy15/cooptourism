// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class EventsModel {
  String? uid;
  String title;
  DateTime startDate;
  DateTime endDate;
  String description;
  String location;
  List<String>? contributors;
  List<String>? participants;
  List<String>? tags;
  List<String>? image;
  
  EventsModel({
    this.uid,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.location,
    this.contributors,
    this.participants,
    this.tags,
    this.image,
  });

  EventsModel copyWith({
    String? uid,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    String? location,
    List<String>? contributors,
    List<String>? participants,
    List<String>? tags,
    List<String>? image,
  }) {
    return EventsModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      location: location ?? this.location,
      contributors: contributors ?? this.contributors,
      participants: participants ?? this.participants,
      tags: tags ?? this.tags,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'uid': uid,
      'title': title,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'description': description,
      'location': location,
      'contributors': contributors,
      'participants': participants,
      'tags': tags,
      'image': image,
    };
  }

  factory EventsModel.fromMap(String id, Map<String, dynamic> map) {
    return EventsModel(
      uid: id,
      title: map['title'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      description: map['description'] as String,
      location: map['location'] as String,
      contributors: map['contributors'] != null ? List<String>.from(map['contributors'] as List<dynamic>).cast<String>() : null,
      participants: map['participants'] != null ? List<String>.from(map['participants'] as List<dynamic>).cast<String>() : null,
      tags: map['tags'] != null ? List<String>.from(map['tags'] as List<dynamic>).cast<String>() : null,
      image: map['image'] != null ? List<String>.from(map['image'] as List<dynamic>).cast<String>() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventsModel.fromJson(String source) => EventsModel.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventsModel(uid: $uid, title: $title, startDate: $startDate, endDate: $endDate, description: $description, location: $location, contributors: $contributors,  participants: $participants, tags: $tags, image: $image)';
  }
}
