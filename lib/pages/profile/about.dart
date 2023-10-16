import 'package:flutter/material.dart';

class ProfileAbout extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfileAbout({Key? key, required this.userData}) : super(key: key);

  @override
  State<ProfileAbout> createState() => _ProfileAboutState();
}

class _ProfileAboutState extends State<ProfileAbout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        userDetails(context, widget.userData),
        const SizedBox(height: 25),
        const Divider(
          color: Color(0xff68707E),
          thickness: 1.5,
        ),
        const SizedBox(height: 15),
        userSkills(context, widget.userData),
        const Divider(
          color: Color(0xff68707E),
          thickness: 1.5,
        ),
        const SizedBox(height: 15),
        userServices(context, widget.userData)
      ],
    );

   
  }


 Column userServices(BuildContext context, Map<String, dynamic> userData) {
  final services = userData['services'] as List<dynamic>?;
  
  if (services == null) {
    // Return an empty column if skills is null
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            'My Skills',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text('No available services'),
        )
      ],
    );
  }
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text('My Services',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: userData['services'].length,
            padding: const EdgeInsets.only(left: 15, right: 15),
            separatorBuilder: (((context, index) => const SizedBox(width: 15))),
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      Icon(_getIconForService(userData['services'][index])),
                      Text(
                        userData['services'][index],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        )
        
    ],
  );
 }

 IconData _getIconForService(String service) {
  switch (service) {
    case 'Tour Guide':
      return Icons.flag;
    case 'Driver':
      return Icons.car_rental;
    case 'Credit Loan':
      return Icons.attach_money;
    default:
      return Icons.help_outline;
  }
}

  Column userSkills(BuildContext context, Map<String, dynamic> userData) {
  final skills = userData['skills'] as List<dynamic>?;
  if (skills == null) {
    // Return an empty column if skills is null
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            'My Skills',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text('No skills added yet'),
        )
      ],
    );
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Text(
          'My Skills',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      SizedBox(
        height: 190, // specify a height
        child: GridView.count(
          crossAxisCount: 2,
          scrollDirection: Axis.horizontal,
          childAspectRatio: (CircularProgressIndicator.strokeAlignOutside / 2),
          children: List.generate(
            skills.length,
            (index) => Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 17,
                    color: Theme.of(context).colorScheme.primary,
                    ), // add an icon
                  const SizedBox(width: 6), // add some spacing
                  Text(
                    skills[index] ?? 'Skill',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ],
  );
}

  Column userDetails(context,Map<String, dynamic> userData ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(widget.userData['location'] ?? 'Location',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const Text(' | '),
          Text(widget.userData['date_joined'] ?? 'Date Joined')
        ]),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.userData['bio'] ?? 'User Bio',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
              )),
        ),
      ],
    );
  }
}
