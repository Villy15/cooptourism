import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:cooptourism/widgets/display_profile_picture.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ManagerProfileView extends StatefulWidget {
  const ManagerProfileView({Key? key, required this.memberId}) : super(key: key);

  final String memberId;

  @override
  State<ManagerProfileView> createState() => _ManagerProfileViewState();
}

class _ManagerProfileViewState extends State<ManagerProfileView> {
  bool isSwitched = false;
  int _selectedIndex = 0;
  final userRepository = UserRepository();
  final List<String> _titles = [
    'Performance',
    'Tasks',
    'Features'
  ];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: userRepository.getUser(widget.memberId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return Scaffold(
            appBar: _appBar(context, 'Member Profile'),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                });
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    memberProfile(user, _selectedIndex),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 40,
                      child: listViewFilter()
                    ),

                    const SizedBox(height: 15),
                    if (_selectedIndex == 0)
                      performanceSection(context, user, widget.memberId)
                    else if (_selectedIndex == 1)
                      const Text('Tasks')
                    else if (_selectedIndex == 2)
                      ListView(shrinkWrap:true, children: [featuresSection(context, user, widget.memberId)])
                  ]
                )
              )
            )
          );
        }
        else if (snapshot.hasError) {
          return const Text('Error loading data');
        }
        else {
          return const CircularProgressIndicator();
        }
      }
    );

  }

  ListView listViewFilter() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _titles.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: Container(
              decoration: BoxDecoration(
                color: _selectedIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28.0, vertical: 10.0),
                child: Text(
                  _titles[index],
                  style: TextStyle(
                    color: _selectedIndex == index
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: _selectedIndex == index
                        ? FontWeight.bold
                        : FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  StreamBuilder<UserModel> memberProfile(UserModel user, int selectedIndex) {
    return StreamBuilder(
      stream: userRepository.getUser(widget.memberId).asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data;

          return profile(context, userData!, widget.memberId);
        }
        if (snapshot.hasError) {
          return const Text('Error loading data');
        }
        else {
          return const CircularProgressIndicator();
        }        
      }
    );
  }

    Container profile(BuildContext context, UserModel user, String userUID) {
    Color borderColor = Theme.of(context).colorScheme.secondary; 

    debugPrint(user.memberType);

    switch (user.memberType) {
      case 'Bronze' 
        : borderColor = const Color(0xffCD7F32);
        break;
      case 'Gold'
        : borderColor = const Color(0xffFFD700);
        break;

      case 'Silver'
        : borderColor = const Color(0xffC0C0C0);
        break;

      case 'Platinum'
        : borderColor = const Color(0xffA0B2c6);
        break;

      case 'Diamond'
        : borderColor = const Color(0xffB9F2FF);
        break;

      default : Theme.of(context).colorScheme.secondary;
      
    }
    return Container(
      height: 290,
      width: 400,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,  
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: borderColor,
                      width: 3.5
                    )
                  ),
                  child: user.profilePicture != null && user.profilePicture!.isNotEmpty ? DisplayProfilePicture(
                    storageRef: FirebaseStorage.instance.ref(), 
                    coopId: userUID, 
                    data: user.profilePicture,
                    height: 70, 
                    width:70  
                  ) : Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.secondary),
                  
                ),
              ),

               const SizedBox(height: 7),
               Padding(
                 padding: const EdgeInsets.only(top: 8.0),
                 child: Text(
                  '${user.firstName} ${user.lastName}', 
                  style: TextStyle(
                    fontSize: 22, 
                    color: Theme.of(context).colorScheme.secondary, 
                    fontWeight: FontWeight.bold
                    )
                  ),
               ),
              
              const SizedBox(height: 15),
              rowData(Icons.calendar_month, 'Joined: ', user.dateJoined),
              const SizedBox(height: 5),
              rowData(Icons.cases_outlined, 'Role: ', user.role),
              const SizedBox(height: 5),
              rowData(Icons.location_on_outlined, 'Location: ', user.location),

              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: () {
                        GoRouter.of(context).go('/inbox_page/$userUID');
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Icon(
                          Icons.message,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ),
                    ),
                  )
                ],
              )
            ],
          )
    );
  }

  Row rowData(IconData icon, String description, String? userData) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 8.0),
                    child: Icon(
                      icon,
                      color: Theme.of(context).colorScheme.secondary
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15, 
                      color: Theme.of(context).colorScheme.secondary, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Text(
                    userData!.isNotEmpty ? userData : 'Unavailable info.',
                    style: TextStyle(
                      fontSize: 15, 
                      color: Theme.of(context).colorScheme.secondary, 
                    )
                  )
                ],
              );
  }

  Column performanceSection(BuildContext context, UserModel user, String userUID) {
    final List<String> profileTiles = [
      'Monthly Sales',
      'Annual Profit',
      'Total Sales',
      'Trust Rating'
    ];
    final List<String> tempData = [
      user.monthlySales!,
      user.annualProfit!,
      user.totalSales!,
      user.userRating!
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Performance',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
            )
          ),
        ),
        const SizedBox(height: 15),

        GridView.builder(
          shrinkWrap: true, 
          itemCount: profileTiles.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 300,
            childAspectRatio: 1
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                profileTiles[index],
                                style: TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary
                                )
                              ),
                              const SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: CircularPercentIndicator(
                                  radius: 40,
                                  lineWidth: 10,
                                  percent: 0.85,
                                  progressColor: Theme.of(context).colorScheme.primary,
                                  center: const Text('85%')
                                ),
                              ),
                              const SizedBox(height: 15),
                              

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                  'Current: '
                                  ),
                                  Text(
                                    tempData[index],
                                    style: TextStyle(
                                      fontSize: 20, 
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary
                                    )
                                  )
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                    child: Text('Goal: '),
                                  ),
                                  Text(
                                    '100,000',
                                    style: TextStyle(
                                      fontSize: 20, 
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary
                                    )
                                  )
                                ],
                              ),
                              
                              
                            ],
                          )
                            
                        ],
                      ),
                    ),
            );
          }
        ),

        const SizedBox(height: 45),

        
      ],
    );
  }

  Column featuresSection(BuildContext context, UserModel user, String userUID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Account',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
            ),
          ),
        ),
        const SizedBox(height: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500
                    )
                  ),
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Edit details in their profile',
                style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                    )
              ),
            ),
            
            const SizedBox(height: 10)
          ],
        ),
        Divider(
          color: Theme.of(context).colorScheme.primary,
          thickness: 1,
        ),

        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Join Communities',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500
                    )
                  ),
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Allow to join any communities within the co-op',
                style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    )
              ),
            ),
            
            const SizedBox(height: 10)
          ],
        ),

        Divider(
          color: Theme.of(context).colorScheme.primary,
          thickness: 1,
        ),

        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Max Loan Amount',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500
                    )
                  ),
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Adjust the maximum amount they can loan',
                style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    )
              ),
            ),
            
            const SizedBox(height: 10)
          ],
        ),

        Divider(
          color: Theme.of(context).colorScheme.primary,
          thickness: 1,
        ),

        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Max Loan Amount',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500
                    )
                  ),
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Adjust the maximum amount they can loan',
                style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    )
              ),
            ),
            
            const SizedBox(height: 100)
          ],
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title, style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
    );
  }
}