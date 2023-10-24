// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class EventsModel {
  String? uid;
  String title;
  DateTime startDate;
  DateTime endDate;
  String description;
  String location;
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
      participants: map['participants'] != null ? List<String>.from(map['participants'] as List<dynamic>).cast<String>() : null,
      tags: map['tags'] != null ? List<String>.from(map['tags'] as List<dynamic>).cast<String>() : null,
      image: map['image'] != null ? List<String>.from(map['image'] as List<dynamic>).cast<String>() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventsModel.fromJson(String source) => EventsModel.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventsModel(uid: $uid, title: $title, startDate: $startDate, endDate: $endDate, description: $description, location: $location, participants: $participants, tags: $tags, image: $image)';
  }

  @override
  bool operator ==(covariant EventsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.title == title &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.description == description &&
      other.location == location &&
      listEquals(other.participants, participants) &&
      listEquals(other.tags, tags) &&
      listEquals(other.image, image);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      title.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      description.hashCode ^
      location.hashCode ^
      participants.hashCode ^
      tags.hashCode ^
      image.hashCode;
  }
}
