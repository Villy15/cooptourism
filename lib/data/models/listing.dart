// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:cooptourism/data/models/task.dart';

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
  Map<String, List<String>>? roles = {};
  List<ToDoItem>? tasks = [];
  num? price = 0;
  String? type = "";
  Timestamp? postDate = Timestamp.now();
  List<dynamic>? images = [];
  num? pax = 0;
  String? ownerMember = "";
  bool? isPublished = false;

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
    this.roles,
    this.tasks,
    this.price,
    this.type,
    this.postDate,
    this.images,
    this.pax,
    this.ownerMember,
    this.isPublished,
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
    Map<String, List<String>>? roles,
    List<ToDoItem>? tasks,
    num? price,
    String? type,
    Timestamp? postDate,
    List<dynamic>? images,
    num? pax,
    bool? isPublished,
    // String? ownerMember,
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
      roles: roles ?? this.roles,
      tasks: tasks ?? this.tasks,
      price: price ?? this.price,
      type: type ?? this.type,
      postDate: postDate ?? this.postDate,
      images: images ?? this.images,
      pax: pax ?? this.pax,
      isPublished: isPublished ?? this.isPublished,
      // ownerMember: ownerMember ?? this.ownerMember,
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
      'roles': roles,
      'tasks': tasks,
      'price': price,
      'type': type,
      'postDate': postDate!.toDate(),
      'images': images,
      'pax': pax!,
      'isPublished': isPublished!,
      // 'ownerMember': ownerMember,
    };
  }

  factory ListingModel.fromMap(String id, Map<String, dynamic> map) {
    return ListingModel(
      id: id,
      owner: map['owner'] != null ? map['owner'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      cooperativeOwned: map['cooperativeOwned'] != null
          ? map['cooperativeOwned'] as String
          : null,
      city: map['city'] != null ? map['city'] as String : null,
      province: map['province'] != null ? map['province'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      rating: map['rating'] != null ? map['rating'] as num : null,
      roles: map['roles'] != null
          ? Map<String, List<String>>.from(
              (map['roles'] as Map<String, List<String>>))
          : null,
      tasks: map['tasks'] != null
          ? List<ToDoItem>.from((map['tasks'] as List<ToDoItem>))
          : null,
      price: map['price'] != null ? map['price'] as num : null,
      type: map['type'] != null ? map['type'] as String : null,
      postDate: map['postDate'] != null ? map['postDate'] as Timestamp : null,
      images: map['images'] != null
          ? List<dynamic>.from((map['images'] as List<dynamic>))
          : null,
      pax: map['pax'] != null ? map['pax'] as num : null,
      isPublished:
          map['isPublished'] != null ? map['paisPublishedx'] as bool : null,
      // ownerMember: map['ownerMember'] != null ? map['ownerMember'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListingModel.fromJson(String source) =>
      ListingModel.fromMap("", json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListingModel(id: $id, owner: $owner, title: $title, description: $description, cooperativeOwned: $cooperativeOwned, city: $city, province: $province, category: $category, rating: $rating, roles: $roles, tasks: $tasks ,price: $price, type: $type, postDate: $postDate, images: $images, pax: $pax, isPublished: $isPublished)'; //, ownerMember: $ownerMember)';
  }
}

// class RoleModel {
//   String? roleName;
//   List<String>? assigned;
//   RoleModel({
//     this.roleName,
//     this.assigned,
//   });

//   RoleModel copyWith({
//     String? roleName,
//     List<String>? assigned,
//   }) {
//     return RoleModel(
//       roleName: roleName ?? this.roleName,
//       assigned: assigned ?? this.assigned,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'roleName': roleName,
//       'assigned': assigned,
//     };
//   }

//   factory RoleModel.fromMap(Map<String, dynamic> map) {
//     return RoleModel(
//       roleName: map['roleName'] != null ? map['roleName'] as String : null,
//       assigned: map['assigned'] != null
//           ? List<String>.from((map['assigned'] as List<String>))
//           : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory RoleModel.fromJson(String source) =>
//       RoleModel.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() => 'RoleModel(roleName: $roleName, assigned: $assigned)';
// }
