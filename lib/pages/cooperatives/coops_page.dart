import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/widgets/display_image.dart';
// import 'package:cooptourism/widgets/list_filter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';

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
      appBar: _appBar(context, "Cooperatives"),
      body: Column(
        children: [
          // const ListFilter(list: ["Location", "Cooperatives"]),
          Expanded(
            child: Padding(
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
                      mainAxisExtent: 230,
                    ),
                    itemCount: cooperatives.length,
                    itemBuilder: (_, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          // color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(width: 1.0, style: BorderStyle.solid),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            var coopId = cooperatives[index].id;
                            return context.go('/coops_page/$coopId');
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                                child: DisplayImage(
                                  path:
                                      "${cooperatives[index].get('name')}/images/${cooperatives[index].get('logo')}",
                                  width: 200,
                                  height: 110,
                                  radius: BorderRadius.circular(16.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${cooperatives[index].get('name')}",
                                        style: const TextStyle(fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      ),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "${cooperatives[index].get('province')}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                    ]),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      actions: [
        // add search
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            child: IconButton(
              onPressed: () {
                // showAddPostPage(context);
              },
              icon: const Icon(Icons.search),
            ),
          ),
        ),
      ],
    );
  }
}
