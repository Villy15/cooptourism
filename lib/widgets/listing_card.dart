import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ListingCard extends StatelessWidget {
  final String id;
  final String owner;
  final String title;
  final String description;
  final int price;
  final String type;
  final List<dynamic> images;
  final int visits;
  final Timestamp postDate;

  const ListingCard({
    required Key key,
    required this.id,
    required this.owner,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.images,
    required this.visits,
    required this.postDate,
  }) : super(key: key);

  String getTimeDifference() {
    final now = Timestamp.now().toDate();
    final postTime = postDate.toDate();
    final difference = now.difference(postTime);

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
    final CooperativesRepository cooperativeRepository =
        CooperativesRepository();
    final Future<CooperativesModel> cooperative =
        cooperativeRepository.getCooperative(owner);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
          onTap: () {
            return context.go('/market_page/$id');
          },
          child: Column(
            children: [
              DisplayImage(
                path: "$owner/listingImages/${images[0]}",
                height: 175,
                width: double.infinity,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DisplayText(
                          text: title,
                          lines: 2,
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.fontSize),
                        ),
                        DisplayText(
                          text: "₱$price",
                          lines: 1,
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.fontSize),
                        ),
                      ],
                    ),
                    FutureBuilder(
                      future: cooperative,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final cooperative = snapshot.data!;

                        return DisplayText(
                          text: cooperative.name!,
                          lines: 1,
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.fontSize),
                        );
                      },
                    ),
                    DisplayText(
                        text: description,
                        lines: 2,
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.fontSize)),
                  ],
                ),
              )
            ],
          )),
    );
  }
}