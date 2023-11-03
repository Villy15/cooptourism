// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


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
