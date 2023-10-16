class CommentModel {
  String? uid;
  String? userId;
  String? content;
  DateTime? timestamp;

  CommentModel({
    this.uid,
    this.userId,
    this.content,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory CommentModel.fromJson(String uid, Map<String, dynamic> json) {
    return CommentModel(
      uid: uid,
      userId: json['userId'],
      content: json['content'],
      timestamp: json['timestamp']?.toDate(),
    );
  }
}

