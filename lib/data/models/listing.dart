import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  String? id;
  String? owner;
  String? title;
  String? description;
  double? rating;
  Map? amenities;
  int? price;
  String? type;
  Timestamp? postDate;
  List<String>? images;
  int? visits;

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
      'id': id,
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
}
