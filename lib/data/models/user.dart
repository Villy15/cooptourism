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
  String? monthlySales;
  String? annualProfit;
  String? totalSales;

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
    this.monthlySales,
    this.annualProfit,
    this.totalSales
  });

  factory UserModel.fromJson(String docId, Map<String, dynamic> json) {
    return UserModel(
      uid: docId,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      status: json['status'] ?? '',
      userAccomplishment: json['user_accomplishment'] ?? '',
      userRating: json['user_rating'] ?? '',
      userTrust: json['user_trust'] ?? '',
      role: json['role'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      location: json['location'] ?? '',
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      featuredImgs: json['featured'] != null ? List<String>.from(json['featured']) : [],
      dateJoined: json['date_joined'] ?? '',
      bio: json['bio'] ?? '',
      memberType: json['memberType'] ?? '',
      currentListings: json['currentListings'] != null ? List<String>.from(json['currentListings']) : [],
      monthlySales: json['monthlySales'] ?? '',
      annualProfit: json['annualProfit'] ?? '',
      totalSales: json['totalSales'] ?? ''
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
      'monthlySales': monthlySales ?? '',
      'annualProfit': annualProfit ?? '',
      'totalSales': totalSales ?? ''
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
    monthlySales = user.monthlySales;
    annualProfit = user.annualProfit;
    totalSales = user.totalSales;
  }

  // Generate toString
  @override
  String toString() {
    return 'UserModel{uid: $uid, email: $email, firstName: $firstName, lastName: $lastName, status: $status, userAccomplishment: $userAccomplishment, userRating: $userRating, userTrust: $userTrust, role: $role, profilePicture: $profilePicture, location: $location, skills: $skills, featuredImgs: $featuredImgs, dateJoined: $dateJoined, bio: $bio, memberType: $memberType, currentListings: $currentListings, monthlySales: $monthlySales, annualProfit: $annualProfit, totalSales: $totalSales}';
  }
}
