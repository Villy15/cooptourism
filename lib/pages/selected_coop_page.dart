import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/widgets/display_logo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SelectedCoopPage extends StatefulWidget {
  final String coopId;
  const SelectedCoopPage({super.key, required this.coopId});

  @override
  State<SelectedCoopPage> createState() => _SelectedCoopPageState();
}

class _SelectedCoopPageState extends State<SelectedCoopPage> {
  @override
  Widget build(BuildContext context) {
    final storageRef = FirebaseStorage.instance.ref();
    final cooperativesStream = FirebaseFirestore.instance
        .collection('cooperatives')
        .doc(widget.coopId);

    return FutureBuilder<DocumentSnapshot>(
      future: cooperativesStream.get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Column(children: [
              DisplayLogo(storageRef: storageRef, widget: widget, data: data),
              // Text(data)
            ]),
          );
      },
    );
  }
}


