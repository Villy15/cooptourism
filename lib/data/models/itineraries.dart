// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';


class ItineraryModel {
  String? uid;
  String city;
  String province;
  List<String>? images;
  int days;
  String name;
  String? description;
  num budget;
  List<String>? tags;
  ItineraryModel({
    this.uid,
    required this.city,
    required this.province,
    this.images,
    required this.days,
    required this.name,
    this.description,
    required this.budget,
    this.tags,
  });

  ItineraryModel copyWith({
    String? uid,
    String? city,
    String? province,
    List<String>? images,
    int? days,
    String? name,
    String? description,
    num? budget,
    List<String>? tags,
  }) {
    return ItineraryModel(
      uid: uid ?? this.uid,
      city: city ?? this.city,
      province: province ?? this.province,
      images: images ?? this.images,
      days: days ?? this.days,
      name: name ?? this.name,
      description: description ?? this.description,
      budget: budget ?? this.budget,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'city': city,
      'province': province,
      'images': images,
      'days': days,
      'name': name,
      'description': description,
      'budget': budget,
      'tags': tags,
    };
  }

  factory ItineraryModel.fromMap(String id, Map<String, dynamic> map) {
    return ItineraryModel(
      uid: id,
      city: map['city'] as String,
      province: map['province'] as String,
      images: map['images'] != null ? List<String>.from((map['images'] as List<dynamic>).cast<String>()) : null,
      days: map['days'] as int,
      name: map['name'] as String,
      description: map['description'] != null ? map['description'] as String : null,
      budget: map['budget'] as num,
      tags: map['tags'] != null ? List<String>.from((map['tags'] as List<dynamic>).cast<String>()) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItineraryModel.fromJson(String source) => ItineraryModel.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItineraryModel(uid: $uid, city: $city, province: $province, images: $images, days: $days, name: $name, description: $description, budget: $budget, tags: $tags)';
  }
}


class ActivityModel {
  DateTime datetime;  // e.g., '9AM', '12PM'
  String description;  // e.g., 'Breakfast at XYZ Cafe'
  String location;
  String activityType;  // e.g., 'Food', 'Transportation', 'Accommodation';
  ActivityModel({
    required this.datetime,
    required this.description,
    required this.location,
    required this.activityType,
  });
  

  ActivityModel copyWith({
    DateTime? datetime,
    String? description,
    String? location,
    String? activityType,
  }) {
    return ActivityModel(
      datetime: datetime ?? this.datetime,
      description: description ?? this.description,
      location: location ?? this.location,
      activityType: activityType ?? this.activityType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'datetime': Timestamp.fromDate(datetime),
      'description': description,
      'location': location,
      'activityType': activityType,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      datetime: (map['datetime'] as Timestamp).toDate(),
      description: map['description'] as String,
      location: map['location'] as String,
      activityType: map['activityType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityModel.fromJson(String source) => ActivityModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ActivityModel(datetime: $datetime, description: $description, location: $location, activityType: $activityType)';
  }

}

class DaySchedModel {
  int dayNumber;
  List <ActivityModel> activities;
  DaySchedModel({
    required this.dayNumber,
    required this.activities,
  });

  DaySchedModel copyWith({
    int? dayNumber,
    List <ActivityModel>? activities,
  }) {
    return DaySchedModel(
      dayNumber: dayNumber ?? this.dayNumber,
      activities: activities ?? this.activities,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dayNumber': dayNumber,
      'activities': activities.map((activity) => activity.toMap()).toList(),
    };
  }

  factory DaySchedModel.fromMap(Map<String, dynamic> map) {
    return DaySchedModel(
      dayNumber: map['dayNumber'] as int,
      activities: List <ActivityModel>.from((map['activities'] as List<dynamic>).map((e) => ActivityModel.fromMap(e as Map<String, dynamic>))),
    );
  }

  String toJson() => json.encode(toMap());

  factory DaySchedModel.fromJson(String source) => DaySchedModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DaySchedModel(dayNumber: $dayNumber, activities: $activities)';


}
