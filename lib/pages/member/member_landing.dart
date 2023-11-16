//import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/manager_dashboard.dart/sales.dart';
import 'package:cooptourism/data/models/post.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/post_repository.dart';
import 'package:cooptourism/pages/market/listing_messages.dart';
import 'package:cooptourism/pages/tasks/tasks_page.dart';
import 'package:cooptourism/providers/user_provider.dart';
//import 'package:cooptourism/widgets/listing_card.dart';
import 'package:cooptourism/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cooptourism/data/repositories/manager_dashboard/sales_repository.dart';
import 'package:intl/intl.dart';

final PostRepository _postRepository = PostRepository();
final ListingRepository listingRepository = ListingRepository();
final SalesRepository salesRepository = SalesRepository();

class MemberDashboardPage extends ConsumerStatefulWidget {
  const MemberDashboardPage({super.key});

  @override
  ConsumerState<MemberDashboardPage> createState() => _MemberDashboardPageState();
}

class _MemberDashboardPageState extends ConsumerState<MemberDashboardPage> {
  final List<String> _tabTitles = ['Tasks', 'Services', 'Announcements'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);
    
    return Scaffold(
        appBar: _appBar(context, "Home"),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: listViewFilter(),
              ),
              if (_selectedIndex == 0) ...[
                const TasksPage(),
              ] else if (_selectedIndex == 1) ...[
                servicesMethod(user!),
              ] else if (_selectedIndex == 2) ...[
                announcementsMethod(),
              ]
            ],
          ),
        ));
  }

StreamBuilder<List<SalesData>> servicesMethod(UserModel user) {
  return StreamBuilder<List<SalesData>>(
    stream: salesRepository.getAllSalesByOwnerId(user.uid!),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      final listings = snapshot.data!;
      final todayListings = listings.where((listing) =>
          listing.startDate?.isBefore(DateTime.now()) == true &&
          listing.endDate?.isAfter(DateTime.now()) == true).toList();

      final tomorrowListings = listings.where((listing) =>
          listing.startDate?.isAfter(DateTime.now()) == true &&
          listing.startDate?.isBefore(DateTime.now().add(const Duration(days: 1))) == true).toList();

      final today = DateTime.now();
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1)); 
      final endOfWeek = startOfWeek.add(const Duration(days: 6)); 

      final thisWeekListings = listings.where((listing) =>
        listing.startDate?.isAfter(startOfWeek) == true &&
        listing.startDate?.isBefore(endOfWeek) == true &&
        listing.startDate?.isAfter(DateTime.now().add(const Duration(days: 1))) == true).toList();

      final thisMonthListings = listings.where((listing) =>
          listing.startDate?.isAfter(DateTime.now().add(const Duration(days: 7))) == true &&
          listing.startDate?.isBefore(DateTime(DateTime.now().year, DateTime.now().month + 1, 1)) == true).toList();

      final nextMonthListings = listings.where((listing) =>
          listing.startDate?.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 1, 1)) == true &&
          listing.startDate?.isBefore(DateTime(DateTime.now().year, DateTime.now().month + 2, 1)) == true).toList();

      if (todayListings.isEmpty && tomorrowListings.isEmpty && thisWeekListings.isEmpty && thisMonthListings.isEmpty && nextMonthListings.isEmpty) {
        return const Center(
          child: Text(
            'No listings found',
            style: TextStyle(fontSize: 20),
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (todayListings.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 30.0),
                      child: Text('Today', style: TextStyle(fontSize: 20)),
                    ),
                    showListing(todayListings),
                  ],
                ),
              if (tomorrowListings.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text('Tomorrow', style: TextStyle(fontSize: 20)),
                    ),
                    showListing(tomorrowListings),
                  ],
                ),
              if (thisWeekListings.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text('This Week', style: TextStyle(fontSize: 20)),
                    ),
                    showListing(thisWeekListings),
                  ],
                ),
              if (thisMonthListings.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text('This Month', style: TextStyle(fontSize: 20)),
                    ),
                    showListing(thisMonthListings),
                  ],
                ),
              if (nextMonthListings.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text('Next Month', style: TextStyle(fontSize: 20)),
                    ),
                    showListing(nextMonthListings),
                  ],
                ),
              const SizedBox(height: 100
                      ,)
            ],
          ),
        );
      }
    },
  );
}


Widget showListing(List<SalesData> listings) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    itemCount: listings.length,
    itemBuilder: (context, index) {
      final startDateFormatted =
          DateFormat('MMMM d').format(listings[index].startDate!);
      final endDateFormatted =
          DateFormat('MMMM d').format(listings[index].endDate!);
      final numberOfGuests = listings[index].numberOfGuests ?? 0;

      // Ensure that the listingId and customerId are not null
      final listingId = listings[index].listingId;
      final customerId = listings[index].customerid;

      if (listingId == null || customerId == null) {
        // Handle the case where listingId or customerId is null
        return Container(); // or another appropriate widget
      }

      return Container(
        // border color
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          title: Text(
            listings[index].listingName!,
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            '$startDateFormatted - $endDateFormatted | Guests: $numberOfGuests',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListingMessages(
                    listingId: listingId,
                    docId: customerId, // Using customerId as docId
                  ),
                ),
              );
            },
            child: IconButton(
              icon: const Icon(Icons.message, color: primaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListingMessages(
                      listingId: listingId,
                      docId: customerId, // Using customerId as docId
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}



  StreamBuilder<List<dynamic>> announcementsMethod() {
    return StreamBuilder<List<PostModel>>(
      stream: _postRepository.getAllPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final posts = snapshot.data!;

        debugPrint("Posts: $posts.toString()");

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostCard(
              postModel: posts[index],
            );
          },
        );
      },
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(right: 16.0),
      //     child: CircleAvatar(
      //       backgroundColor: Colors.grey.shade300,
      //       child: IconButton(
      //         onPressed: () {
      //           // showAddPostPage(context);
      //         },
      //         icon: const Icon(Icons.settings, color: Colors.white),
      //       ),
      //     ),
      //   ),
      // ],
    );
  }

  ListView listViewFilter() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _tabTitles.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Padding(
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
                      _tabTitles[index],
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
            ),

            // Only show the notification badge on the "Announcements" tab
          if (_tabTitles[index] == "Announcements" || _tabTitles[index] == "Services")
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '1', // Replace with the actual number of announcements
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
