import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/comment.dart';

class CommentRepository {
  final CollectionReference reviewsCollection =
      FirebaseFirestore.instance.collection('posts');

  // Get all Reviews from Firestore
  Stream<List<CommentModel>> getAllPostComments(String id) {
    return reviewsCollection
        .doc(id)
        .collection('comments')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CommentModel.fromJson(doc.id, doc.data());
      }).toList();
    });
  }
}
