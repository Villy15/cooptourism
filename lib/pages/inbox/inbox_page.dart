import 'package:cooptourism/data/models/userChat.dart';
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
      name: 'Jaz Kaboom',
      email: 'jaz@gmail.com',
      image:
          'https://www.mmaweekly.com/.image/ar_16:9%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cg_xy_center%2Cq_auto:good%2Cw_620%2Cx_755%2Cy_550/MTk5NzMyNDM0MDg5MDI2NjYz/conor-mcgregor-ufc-weigh-in.jpg',
    ), //UserModel
  ];
  
  @override
  Widget build(BuildContext context) {
  return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: userData.length, 
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => UserItem(user: userData[index]),
      );
    }
}

