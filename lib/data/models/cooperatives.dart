// import 'package:cooptourism/data/models/listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CooperativesModel {
  String? uid;
  String? name;
  String? profileDescription;
  String? profilePicture;
  String? province;
  String? city;
  String? logo;
  List<DocumentReference>? managers;
  String? cooperativeType;
  List<dynamic>? memberRequirements;
  num? membershipFee;



  CooperativesModel ({
    this.uid,
    this.name,
    this.profileDescription,
    this.profilePicture,
    this.province,
    this.city,
    this.logo,
    this.managers,
    this.cooperativeType,
    this.memberRequirements,
    this.membershipFee
  });

  factory CooperativesModel.fromJson(String docId, Map<String, dynamic> json) {
    return CooperativesModel(
      uid: docId,
      name: json['name'],
      profileDescription: json['profileDescription'],
      profilePicture: json['profilePicture'],
      province: json['province'],
      city: json['city'],
      logo: json['logo'],
      managers: json['managers'],
      cooperativeType: json['cooperativeType'],
      memberRequirements: json['memberRequirements'],
      membershipFee: json['membershipFee']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profileDescription': profileDescription,
      'profilePicture': profilePicture,
      'province': province,
      'city': city,
      'logo': logo,
      'managers': managers,
      'cooperativeType': cooperativeType,
      'memberRequirements': memberRequirements,
      'membershipFee': membershipFee
    };
  }
}
