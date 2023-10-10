import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  String? owner;
  String? title;
  String? description;
  int? price;
  String? type;
  Timestamp? postDate;
  List<String>? images;
  int? visits;

  ListingModel({
    this.owner,
    this.title,
    this.description,
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
      'price': price,
      'type': type,
      'postDate': postDate,
      'images': images,
      'visits': visits,
    };
  }

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      owner: json['owner'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      type: json['type'],
      postDate: json['postDate'] as Timestamp,
      images: List<String>.from(json['images'] as List<dynamic>),
      visits: json['visits'],
    );
  }
}
