// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  String? id;
  String? owner;
  String? title;
  String? description;
  String? cooperativeOwned;
  String? city;
  String? province;
  Map? categories;
  num? rating;
  Map? amenities;
  num? price;
  String? type;
  Timestamp? postDate;
  List<String>? images;
  int? visits;
  String? ownerMember;

  ListingModel({
    this.id,
    this.owner,
    this.title,
    this.description,
    this.rating,
    this.amenities,
    this.price,
    this.type,
    this.postDate,
    this.images,
    this.visits,
    this.ownerMember,
    this.city,
  });



  ListingModel copyWith({
    String? id,
    String? owner,
    String? title,
    String? description,
    num? rating,
    Map? amenities,
    num? price,
    String? type,
    Timestamp? postDate,
    List<String>? images,
    int? visits,
    String? ownerMember,
    String? city,
  }) {
    return ListingModel(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      title: title ?? this.title,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      amenities: amenities ?? this.amenities,
      price: price ?? this.price,
      type: type ?? this.type,
      postDate: postDate ?? this.postDate,
      images: images ?? this.images,
      visits: visits ?? this.visits,
      ownerMember: ownerMember ?? this.ownerMember,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'owner': owner,
      'title': title,
      'description': description,
      'rating': rating,
      'amenities': amenities,
      'price': price,
      'type': type,
      'postDate': postDate,
      'images': images,
      'visits': visits,
      'ownerMember': ownerMember,
      'city': city,
    };
  }

  factory ListingModel.fromMap(String id, Map<String, dynamic> map) {
    return ListingModel(
      id: id,
      owner: map['owner'] != null ? map['owner'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      rating: map['rating'] != null ? map['rating'] as num : null,
      amenities: map['amenities'] as Map<String, dynamic>?,
      price: map['price'] != null ? map['price'] as int : null,
      type: map['type'] != null ? map['type'] as String : null,
      postDate: map['postDate'] as Timestamp?,
      images: map['images'] != null ? List<String>.from(map['images'].map((e) => e.toString())) : null,
      visits: map['visits'] != null ? map['visits'] as int : null,
      ownerMember: map['ownerMember'] != null ? map['ownerMember'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListingModel.fromJson(String source) => ListingModel.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListingModel(id: $id, owner: $owner, title: $title, description: $description, rating: $rating, amenities: $amenities, price: $price, type: $type, postDate: $postDate, images: $images, visits: $visits, ownerMember: $ownerMember city: $city)';
  }
}
