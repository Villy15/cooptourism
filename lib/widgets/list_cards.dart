import 'package:flutter/material.dart';

class ListCards extends StatelessWidget {
  const ListCards({
    super.key,
    required this.cards,
    required this.returnWidget,
  });

  final List<dynamic> cards;
  final dynamic returnWidget;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];

        return returnWidget(
          card,
        );
      },
    );
  }
}