import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CoopsPage extends StatefulWidget {
  const CoopsPage({super.key});

  @override
  State<CoopsPage> createState() => _CoopsPageState();
}

class _CoopsPageState extends State<CoopsPage> {
  final storageRef = FirebaseStorage.instance.ref();
  final Stream<QuerySnapshot> _cooperatives =
      FirebaseFirestore.instance.collection('cooperatives').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.5),
        child: StreamBuilder<QuerySnapshot>(
          stream: _cooperatives,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final cooperatives = snapshot.data!.docs;
            return GridView.builder(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 200,
                  ),
              itemCount: cooperatives.length,
              itemBuilder: (_, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(width: 1.0, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                        child: FutureBuilder<String>(
                          future: storageRef
                              .child("iwahori.png")
                              .getDownloadURL(), // Await here
                          builder: (context, urlSnapshot) {
                            if (urlSnapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (urlSnapshot.hasError) {
                              return Text('Error: ${urlSnapshot.error}');
                            }
                            
                            final imageUrl = urlSnapshot.data;

                            return Image.network(
                              imageUrl!,
                              height: 170,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
