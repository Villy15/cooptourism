class UserModel {
  final String uid;
  final String name;
  final String email;
  final String image;

  const UserModel({
  required this.uid,
  required this.name,
  required this.email,
  required this.image,
});

  Map<String, dynamic> toJson() => {
      'uid': uid,
      'email': email,
      'name': name,
      'image': image,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      uid: json['uid'] ?? '',
    );
  }



}

  