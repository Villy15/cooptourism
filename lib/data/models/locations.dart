// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LocationModel {
  String? uid;
  String city;
  String province;
  List<String>? images;
  LocationModel({
    this.uid,
    required this.city,
    required this.province,
    this.images,
  });

  LocationModel copyWith({
    String? uid,
    String? city,
    String? province,
    List<String>? images,
  }) {
    return LocationModel(
      uid: uid ?? this.uid,
      city: city ?? this.city,
      province: province ?? this.province,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'city': city,
      'province': province,
      'images': images,
    };
  }

  factory LocationModel.fromMap(String id, Map<String, dynamic> map) {
    return LocationModel(
      uid: id,
      city: map['city'] as String,
      province: map['province'] as String,
      images: map['images'] != null ? List<String>.from(map['images'] as List<dynamic>).cast<String>() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) => LocationModel.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LocationModel(uid: $uid, city: $city, province: $province, images: $images)';

}
