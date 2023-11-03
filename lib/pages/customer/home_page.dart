import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/pages/customer/city_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  final destinations = [
    {'icon': Icons.beach_access, 'text': 'Beach'},
    {'icon': Icons.location_city, 'text': 'City'},
    {'icon': Icons.landscape, 'text': 'Wilderness'},

    {'icon': Icons.beach_access, 'text': 'Beach'},
    {'icon': Icons.location_city, 'text': 'City'},
    {'icon': Icons.landscape, 'text': 'Wilderness'},
    // Add more destinations as needed
  ];

  final locations = [
  {'city': 'Puerto Prinsesa', 'province': 'Palawan'},
  {'city': 'Tagbilaran', 'province': 'Bohol'},
  {'city': 'Cebu City', 'province': 'Cebu'},
  {'city': 'Davao City', 'province': 'Davao del Sur'},
  {'city': 'Baguio', 'province': 'Benguet'},
  {'city': 'Vigan', 'province': 'Ilocos Sur'}
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context, "lakbay"),
        backgroundColor: Colors.white,
        body:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Where do you want to go?"),
              ),
        
              // Create a search bar with search icon on the left and a voice on the right
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(color: primaryColor),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.mic),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                ),
              ),
        
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Itenerary Ideas"),
              ),
        
              SizedBox(height: 100.0 ,child: listIteneraryIdeas()),
        
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Browse"),
              ),

              SizedBox(
                  height: 200.0,
                  child: GestureDetector(
                    onTap: () {
                      context.go('/customer_home_page/Palawan');
                    },
                    child: listLocations()
                  )),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Browse 2"),
              ),

              SizedBox(
                  height: 200.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CityPage(cityId: "City Info",)),
                      );
                    },
                    child: listLocations()
                  )),

              const SizedBox(height: 70.0)

        
            ],
          ),
        ));
  }

  ListView listLocations() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Add a square container for the image that has a primary color
              Container(
                height: 150.0,
                width: 120.0,
                color: primaryColor,
              ),
              
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(locations[index]['province'] as String, style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(locations[index]['city'] as String, style: const TextStyle(fontSize: 12.0)),
              ),
            ],
          ),
        );
        
      },
          
    );
  }

  ListView listIteneraryIdeas() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: primaryColor,
                radius: 30.0,
                child: Icon(destinations[index]['icon'] as IconData?, size: 32.0, color: Colors.white,),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(destinations[index]['text'] as String, style: const TextStyle(fontSize: 14.0)),
              ),
            ],
          ),
        );
        
      },
          
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 28,
            color: Colors.orange.shade700,
            fontWeight: FontWeight.bold),
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(right: 16.0),
      //     child: CircleAvatar(
      //         backgroundColor: Colors.grey.shade300,
      //         child: IconButton(
      //           onPressed: () {
      //             // context.push('/market_page/add_listing');
      //           },
      //           icon: const Icon(Icons.add, color: Colors.white),
      //         ),
      //       ),
      //   ),
      // ],
    );
  }
}
