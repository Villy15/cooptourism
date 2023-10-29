import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimeDifferenceCalculator {
  final Timestamp postTime;

  TimeDifferenceCalculator(this.postTime);

  String getTimeDifference() {
    final now = DateTime.now();
    final postDate = postTime.toDate();
    final difference = now.difference(postDate);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      final formatter = DateFormat.yMd().add_jm();
      return formatter.format(postDate);
    }
  }
}
