import 'package:cooptourism/data/models/user_chart.dart';
import 'package:flutter/material.dart';
import 'package:cooptourism/widgets/user_item.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  


  final userData = [
    const UserModel(
      uid: '101',
      name: 'Jaz Campanilla',
      email: 'jaz@gmail.com',
      image:
          'https://www.mmaweekly.com/.image/ar_16:9%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cg_xy_center%2Cq_auto:good%2Cw_620%2Cx_755%2Cy_550/MTk5NzMyNDM0MDg5MDI2NjYz/conor-mcgregor-ufc-weigh-in.jpg',
    ), //UserModel
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: _appBar(context, "Inbox"),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: userData.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => UserItem(user: userData[index]),
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title, style: TextStyle(fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: IconButton(
                onPressed: () {
                  // showAddPostPage(context);
                },
                icon: const Icon(Icons.message, color: Colors.white),
              ),
            ),
        ),
      ],
    );
  }
}

