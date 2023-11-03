import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/locations.dart';
import 'package:cooptourism/data/repositories/location_repository.dart';
import 'package:cooptourism/pages/customer/city_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

final LocationRepository locationRepository = LocationRepository();

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

  @override
  void initState() {
    super.initState();
    // locationRepository.deleteAllLocation();
    // locationRepository.addLocationManually();
  }

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

              browseLocations(),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Browse"),
              ),


              browseLocations(),

              const SizedBox(height: 70.0)

        
            ],
          ),
        ));
  }

  FutureBuilder<List<LocationModel>> browseLocations() {
    return FutureBuilder(
              future: locationRepository.getAllLocationFuture(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // show a loader while waiting for data
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No Events available');
                } else {
                  List<LocationModel> locationList = snapshot.data!;


                  return SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: locationList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // context.go('/customer_home_page/${locationList[index].uid}');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CityPage(locationModel: locationList[index]),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                        
                                // If no image, Add a square container for the image that has a primary color
                                // Container(
                                //   height: 150.0,
                                //   width: 120.0,
                                //   color: primaryColor,
                                // ),

                                // Else add the image from firestore
                                if (locationList[index].images != null && locationList[index].images!.isNotEmpty)
                                locationImage(context, locationList[index]),
                                
                               
                                
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(locationList[index].province, style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
                                ),
                        
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(locationList[index].city, style: const TextStyle(fontSize: 12.0)),
                                ),
                              ],
                            ),
                          ),
                        );
                        
                      },
                          
                    ),
                  );
                }
              },

            );
  }

  FutureBuilder locationImage(BuildContext context, LocationModel location) {
    final storageRef = FirebaseStorage.instance.ref();
    String imagePath = "locations/images/${location.images?[0]}";

    return FutureBuilder (
      future: storageRef.child(imagePath).getDownloadURL(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // show a loader while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No Events available');
        } else {
          String imageUrl = snapshot.data as String;
          return Container(
            height: 150.0,
            width: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
        }
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
