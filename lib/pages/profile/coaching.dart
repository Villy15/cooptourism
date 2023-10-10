import 'package:flutter/material.dart';

class ProfileCoaching extends StatefulWidget {
  const ProfileCoaching({super.key});

  @override
  State<ProfileCoaching> createState() => _ProfileCoachingState();
}

class _ProfileCoachingState extends State<ProfileCoaching> {
  final List<String> _improvements = [
    'Honoring commitmnents and delivering on promises.',
    'Being transparent and honest in your interactions.',
    'Maintaining open and clear communication.',
    'Resolving conflicts and addressing concerns professionally.',
    'Building a track record of reliability and dependability.',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Need help in improving that trust rating?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary),
                  children: const [
                    TextSpan(
                      text: 'Q: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'What is a trust rating?',
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                'A trust rating is a measure of credibility and reliability that is assigned to individuals or entities based on their past actions, behavior, and reputation.',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary),
                  children: const [
                    TextSpan(
                      text: 'Q: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Why is a trust rating important?',
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                'A trust rating is important because it affects how others perceive and interact with you. It can influence the willingness to engage in transactions, collaborations, or partnerships of others with you.',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary),
                  children: const [
                    TextSpan(
                      text: 'Q: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'How can I improve my trust rating?',
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                'A trust rating is important because it affects how others perceive and interact with you. It can influence the willingness to engage in transactions, collaborations, or partnerships of others with you. Some ways to improve your trust rating include:',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            // ListView of improvements
            ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: SizedBox(
                    width: 50, // set the width of the SizedBox
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle, 
                          size: 10,
                          color: Theme.of(context).colorScheme.primary
                          ),
                        const SizedBox(width: 7), // add some spacing
                        Text(
                          _improvements[index],
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.primary
                            ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: _improvements.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
            Container(
              height: 50,
              width: 50,
              color: Colors.black
            )
          ],
        ),
      ],
    );
  }
}
