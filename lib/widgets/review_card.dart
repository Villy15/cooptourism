import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/controller/post_provider.dart';
import 'package:cooptourism/data/models/review.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


class ReviewCard extends StatefulWidget {
  final ReviewModel? reviewModel;

  const ReviewCard({super.key, 
    this.reviewModel
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  String getTimeDifference() {
    final now = Timestamp.now().toDate();
    final postTime = widget.reviewModel?.reviewDate!.toDate();
    final difference = now.difference(postTime!);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      final formatter = DateFormat.yMd().add_jm();
      return formatter.format(postTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();

    final cooperativeRepository = CooperativesRepository();
    final cooperative =
        cooperativeRepository.getCooperative(widget.reviewModel?.id ?? "");
    return const Text("This works for sure");
  }
}