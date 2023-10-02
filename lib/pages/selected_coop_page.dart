import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/widgets/display_logo.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
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
      final _formKey = GlobalKey<FormState>();

    final storageRef = FirebaseStorage.instance.ref();
    final cooperativesStream = FirebaseFirestore.instance
        .collection('cooperatives')
        .doc(widget.coopId);

    return Scaffold(
      body: FutureBuilder(
        future: cooperativesStream.get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
               if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
              snapshot.data?.data() as Map<String, dynamic>;
          return Column(
            children: [
              DisplayLogo(
                storageRef: storageRef,
                widget: widget,
                data: data,
              ),
              Row(
                children: [
                  DisplayProfilePicture(
                      storageRef: storageRef, widget: widget, data: data),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize),
                        ),
                        StreamBuilder(
                          stream: cooperativesStream
                              .collection('members')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            final docs = snapshot.data?.docs;
                            return Text(
                              '${docs?.length}' ' members',
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      await showDialog<void>(context: context,
                      builder: (context) => AlertDialog(
                        content: Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Positioned(
                              right: -40,
                              top: -40,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.close),
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ElevatedButton(
                                      child: const Text('Submitß'),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )));
                    },
                    child: const Text("Join"),
                  )
                ],
              )
            ],
          );
               }        
        return Text('Loading');
        } 
      ),
    );
  }
}
