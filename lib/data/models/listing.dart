// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  String? id;
  String? owner;
  String? title;
  String? description;
  num? rating;
  Map? amenities;
  num? price;
  String? type;
  Timestamp? postDate;
  List<String>? images;
  num? visits;

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
  });

  Map<String, dynamic> toJson() {
    return {
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
    };
  }

  factory ListingModel.fromJson(String id, Map<String, dynamic> json) {
    return ListingModel(
      id: id,
      owner: json['owner'],
      title: json['title'],
      description: json['description'],
      rating: json['rating'],
      amenities: json['amenities'],
      price: json['price'],
      type: json['type'],
      postDate: json['postDate'] as Timestamp,
      images: List<String>.from(json['images'] as List<dynamic>),
      visits: json['visits'],
    );
  }

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
    num? visits,
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
    );
  }
}
