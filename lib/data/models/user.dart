// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? status;
  String? userAccomplishment;
  String? userRating;
  String? userTrust;
  String? role;
  String? profilePicture;
  String? bio;
  String? location;
  List<String>? skills;
  List<String>? featuredImgs;
  String? dateJoined;
  String? memberType;
  List<String>? currentListings;
  // for testing purposes
  Timestamp? joinedAt;
  List<String>? cooperativesJoined;
  String? emailStatus;
  List<CooperativePosition>? cooperativePositions;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.status,
    this.userAccomplishment,
    this.userRating,
    this.userTrust,
    this.role,
    this.profilePicture,
    this.location,
    this.skills,
    this.featuredImgs,
    this.dateJoined,
    this.bio,
    this.memberType,
    this.currentListings,
    this.joinedAt,
    this.cooperativesJoined,
    this.emailStatus,
    this.cooperativePositions,
  });

  factory UserModel.fromJson(String docId, Map<String, dynamic> json) {
    return UserModel(
      uid: docId,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      status: json['status'] ?? '',
      userAccomplishment: json['user_achievement'] ?? '',
      userRating: json['user_rating'] ?? '',
      userTrust: json['user_trust'] ?? '',
      role: json['role'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      location: json['location'] ?? '',
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      featuredImgs:
          json['featured'] != null ? List<String>.from(json['featured']) : [],
      dateJoined: json['date_joined'] ?? '',
      bio: json['bio'] ?? '',
      memberType: json['memberType'] ?? '',
      currentListings: json['currentListings'] != null
          ? List<String>.from(json['currentListings'])
          : [],
      joinedAt:
          json['joined_at'] != null ? json['joined_at'] as Timestamp : null,
      cooperativesJoined: json['cooperativesJoined'] != null
          ? List<String>.from(json['cooperativesJoined'])
          : [],
      emailStatus: json['emailStatus'] ?? '',
      cooperativePositions: json['cooperativePositions'] != null
          ? List<CooperativePosition>.from(json['cooperativePositions'].map(
              (x) => CooperativePosition.fromMap(x as Map<String, dynamic>)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'status': status,
      'user_accomplishment': userAccomplishment,
      'user_rating': userRating,
      'user_trust': userTrust,
      'role': role,
      'profilePicture': profilePicture ?? '',
      'location': location ?? '',
      'skills': skills ?? [],
      'featuredImgs': featuredImgs ?? [],
      'dateJoined': dateJoined ?? '',
      'bio': bio ?? '',
      'memberType': memberType ?? '',
      'currentListings': currentListings ?? [],
      'joinedAt': joinedAt,
      'cooperativesJoined': cooperativesJoined ?? [],
      'emailStatus': emailStatus ?? '',
      'cooperativePositions': cooperativePositions != null
          ? cooperativePositions!.map((x) => x.toMap()).toList()
          : [],
    };
  }

  void map(Function(dynamic value) function) {
    final json = toJson();
    json.forEach((key, value) {
      json[key] = function(value);
    });
    final user = UserModel.fromJson("", json);
    email = user.email;
    firstName = user.firstName;
    lastName = user.lastName;
    status = user.status;
    userAccomplishment = user.userAccomplishment;
    userRating = user.userRating;
    userTrust = user.userTrust;
    role = user.role;
    profilePicture = user.profilePicture;
    location = user.location;
    skills = user.skills;
    featuredImgs = user.featuredImgs;
    dateJoined = user.dateJoined;
    bio = user.bio;
    memberType = user.memberType;
    currentListings = user.currentListings;
    joinedAt = user.joinedAt;
    cooperativesJoined = user.cooperativesJoined;
    emailStatus = user.emailStatus;
    cooperativePositions = user.cooperativePositions;
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, firstName: $firstName, lastName: $lastName, status: $status, userAccomplishment: $userAccomplishment, userRating: $userRating, userTrust: $userTrust, role: $role, profilePicture: $profilePicture, bio: $bio, location: $location, skills: $skills, featuredImgs: $featuredImgs, dateJoined: $dateJoined, memberType: $memberType, currentListings: $currentListings,  joinedAt: $joinedAt, cooperativesJoined: $cooperativesJoined, emailStatus: $emailStatus cooperativePositions: $cooperativePositions)';
  }
}

class CooperativePosition {
  String? cooperativeid;
  String? coopName;
  String? position;
  String? positionType;
  CooperativePosition({
    this.cooperativeid,
    this.coopName,
    this.position,
    this.positionType,
  });

  CooperativePosition copyWith({
    String? cooperativeid,
    String? coopName,
    String? position,
    String? positionType,
  }) {
    return CooperativePosition(
      cooperativeid: cooperativeid ?? this.cooperativeid,
      coopName: coopName ?? this.coopName,
      position: position ?? this.position,
      positionType: positionType ?? this.positionType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cooperativeid': cooperativeid,
      'coopName': coopName,
      'position': position,
      'positionType': positionType,
    };
  }

  factory CooperativePosition.fromMap(Map<String, dynamic> map) {
    return CooperativePosition(
      cooperativeid:
          map['cooperativeid'] != null ? map['cooperativeid'] as String : null,
      coopName: map['coopName'] != null ? map['coopName'] as String : null,
      position: map['position'] != null ? map['position'] as String : null,
      positionType:
          map['positionType'] != null ? map['positionType'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CooperativePosition.fromJson(String source) =>
      CooperativePosition.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CooperativePosition(cooperativeid: $cooperativeid, coopName: $coopName, position: $position, positionType: $positionType)';
  }

  @override
  bool operator ==(covariant CooperativePosition other) {
    if (identical(this, other)) return true;

    return other.cooperativeid == cooperativeid &&
        other.coopName == coopName &&
        other.position == position &&
        other.positionType == positionType;
  }

  @override
  int get hashCode {
    return cooperativeid.hashCode ^
        coopName.hashCode ^
        position.hashCode ^
        positionType.hashCode;
  }
}
