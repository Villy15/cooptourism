class CommentModel {
  String? uid;
  String? userId;
  String? content;

  CommentModel({
    this.uid,
    this.userId,
    this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userId': userId,
      'content': content,
    };
  }

  factory CommentModel.fromJson(String uid, Map<String, dynamic> json) {
    return CommentModel(
      uid: uid,
      userId: json['userId'],
      content: json['content'],
    );
  }
}

