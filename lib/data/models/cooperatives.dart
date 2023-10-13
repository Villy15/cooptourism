class CooperativesModel {
  String? name;
  String? profileDescription;
  String? profilePicture;
  String? province;
  String? city;
  String? logo;


  CooperativesModel ({
    this.name,
    this.profileDescription,
    this.profilePicture,
    this.province,
    this.city,
    this.logo,
  });

  factory CooperativesModel.fromJson(Map<String, dynamic> json) {
    return CooperativesModel(
      name: json['name'],
      profileDescription: json['profileDescription'],
      profilePicture: json['profilePicture'],
      province: json['province'],
      city: json['city'],
      logo: json['logo'],
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
    };
  }
}
