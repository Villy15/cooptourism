import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  String? listingOwner;
  String? listingTitle;
  String? listingDescription;
  int? listingPrice;
  String? listingType;
  Timestamp? listingPostDate;
  List<String>? listingImages;
  int? listingVisits;

  ListingModel({
    this.listingOwner,
    this.listingTitle,
    this.listingDescription,
    this.listingPrice,
    this.listingType,
    this.listingPostDate,
    this.listingImages,
    this.listingVisits,
  });

  Map<String, dynamic> toJson() {
    return {
      'listingOwner': listingOwner,
      'listingTitle': listingTitle,
      'listingDescription': listingDescription,
      'listingPrice': listingPrice,
      'listingType': listingType,
      'listingPostDate': listingPostDate,
      'listingImages': listingImages,
      'listingVisits': listingVisits,
    };
  }

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      listingOwner: json['listingOwner'],
      listingTitle: json['listingTitle'],
      listingDescription: json['listingDescription'],
      listingPrice: json['listingPrice'],
      listingType: json['listingType'],
      listingPostDate: json['listingPostDate'] as Timestamp,
      listingImages: List<String>.from(json['listingImages'] as List<dynamic>),
      listingVisits: json['listingVisits'],
    );
  }
}
