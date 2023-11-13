// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  String? id = "";
  String? owner = "";
  String? title = "";
  String? description = "";
  String? cooperativeOwned = "";
  String? city = "";
  String? province = "";
  String? category = "";
  num? rating = 0;
  Map<String, dynamic>? amenities = {};
  Map<String, List<dynamic>>? roles = {};
  Map<String, List<dynamic>>? tasks = {};
  num? price = 0;
  String? type = "";
  Timestamp? postDate = Timestamp.now();
  List<dynamic>? images = [];
  int? visits = 0;
  String? ownerMember = "";
  ListingModel({
    this.id,
    this.owner,
    this.title,
    this.description,
    this.cooperativeOwned,
    this.city,
    this.province,
    this.category,
    this.rating,
    this.amenities,
    this.roles,
    this.tasks,
    this.price,
    this.type,
    this.postDate,
    this.images,
    this.visits,
    this.ownerMember,
  });
  

  ListingModel copyWith({
    String? id,
    String? owner,
    String? title,
    String? description,
    String? cooperativeOwned,
    String? city,
    String? province,
    String? category,
    num? rating,
    Map<String, dynamic>? amenities,
    Map<String, List<dynamic>>? roles,
    Map<String, List<dynamic>>? tasks,
    num? price,
    String? type,
    Timestamp? postDate,
    List<dynamic>? images,
    int? visits,
    String? ownerMember,
  }) {
    return ListingModel(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      title: title ?? this.title,
      description: description ?? this.description,
      cooperativeOwned: cooperativeOwned ?? this.cooperativeOwned,
      city: city ?? this.city,
      province: province ?? this.province,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      amenities: amenities ?? this.amenities,
      roles: roles ?? this.roles,
      tasks: tasks ?? this.tasks,
      price: price ?? this.price,
      type: type ?? this.type,
      postDate: postDate ?? this.postDate,
      images: images ?? this.images,
      visits: visits ?? this.visits,
      ownerMember: ownerMember ?? this.ownerMember,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'owner': owner,
      'title': title,
      'description': description,
      'cooperativeOwned': cooperativeOwned,
      'city': city,
      'province': province,
      'category': category,
      'rating': rating,
      'amenities': amenities,
      'roles': roles,
      'tasks': tasks,
      'price': price,
      'type': type,
      'postDate': postDate,
      'images': images,
      'visits': visits,
      'ownerMember': ownerMember,
    };
  }

  factory ListingModel.fromMap(String id, Map<String, dynamic> map) {
    return ListingModel(
      id: id,
      owner: map['owner'] != null ? map['owner'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      cooperativeOwned: map['cooperativeOwned'] != null ? map['cooperativeOwned'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      province: map['province'] != null ? map['province'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      rating: map['rating'] != null ? map['rating'] as num : null,
      amenities: map['amenities'] != null ? Map<String, dynamic>.from((map['amenities'] as Map<String, dynamic>)) : null,
      roles: map['roles'] != null ? Map<String, List<dynamic>>.from((map['roles'] as Map<String, List<dynamic>>)) : null,
      tasks: map['tasks'] != null ? Map<String, List<dynamic>>.from((map['tasks'] as Map<String, List<dynamic>>)) : null,
      price: map['price'] != null ? map['price'] as num : null,
      type: map['type'] != null ? map['type'] as String : null,
      postDate: map['postDate'] != null ? map['postDate'] as Timestamp : null,
      images: map['images'] != null ? List<dynamic>.from((map['images'] as List<dynamic>)) : null,
      visits: map['visits'] != null ? map['visits'] as int : null,
      ownerMember: map['ownerMember'] != null ? map['ownerMember'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListingModel.fromJson(String source) => ListingModel.fromMap("", json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListingModel(id: $id, owner: $owner, title: $title, description: $description, cooperativeOwned: $cooperativeOwned, city: $city, province: $province, category: $category, rating: $rating, amenities: $amenities, roles: $roles, tasks: $tasks, price: $price, type: $type, postDate: $postDate, images: $images, visits: $visits, ownerMember: $ownerMember)';
  }

}
