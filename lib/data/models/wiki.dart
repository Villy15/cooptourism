class WikiModel {
  String? uid;
  String? title;
  String? description;
  String? image;
  String? content;

  WikiModel({
    this.uid,
    this.title,
    this.description,
    this.image,
    this.content,
  });

  factory WikiModel.fromJson(String id, Map<String, dynamic> json) {
    return WikiModel(
      uid: id,
      title: json['title'],
      description: json['description'],
      image: json['image'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'image': image,
        'content': content,
      };
}
