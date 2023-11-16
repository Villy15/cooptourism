import 'package:cooptourism/data/models/manager_dashboard.dart/sales.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/manager_dashboard/sales_repository.dart';
import 'package:cooptourism/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final SalesRepository salesRepository = SalesRepository();
final ListingRepository listingRepository = ListingRepository();

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final List<String> _tabTitles = ['Transactions', 'Loans', 'Donate'];
  int _selectedIndex = 0;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Finance"),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            listFilter(),
            const SizedBox(height: 10),
            _selectedIndex == 0
                ? _buildWalletsContent()
                : _selectedIndex == 1
                    ? _buildLoansContent()
                    : _buildDonateContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletsContent() {
    final user = ref.watch(userModelProvider);
    return StreamBuilder<Object>(
      stream: user?.role! == 'Customer' ? salesRepository.getAllSalesByCustomerId(user!.uid!) : salesRepository.getAllSalesByOwnerId(user!.uid!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } 

        final transactions = snapshot.data as List<SalesData>;
        // Sort transactions by date
        transactions.sort((a, b) => b.date.compareTo(a.date));

        return Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            //   child: walletWidget(context, name, money),
            // ),
            // const SizedBox(height: 10),
        
            // ListsView Builder of transactions table
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: transactionHeading(),
            ),
            listTransactions(transactions),
          ],
        );
      }
    );
  }

  Widget _buildLoansContent() {
    double maxLoan = 50000.00;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: loansWidget(context, maxLoan),
    );
  }

  Widget _buildDonateContent() {
    // Content for the 'Donate' tab
    return const Text('Donate Content');
  }
  
  Row transactionHeading() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Transactions",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),

        //  See all underline
        // Text("See All",
        //     style: TextStyle(
        //         decoration: TextDecoration.underline, fontSize: 16.0)),
      ],
    );
  }

  ListView listTransactions(List<SalesData> sales) {
    final user = ref.watch(userModelProvider);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sales.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final sale = sales[index];
        final formattedDate =
            DateFormat('MMM dd yyyy | hh:mm a').format(sale.date);
        return ListTile(
          leading: const Icon(Icons.payment),
          title: FutureBuilder (
            future: listingRepository.getListingTitle(sale.listingId!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } 
              final listingTitle = snapshot.data as String;
              return Text(listingTitle,
                style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold));
            }
          ),
          subtitle: Text(formattedDate,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w400)),
          trailing: Text(
              user?.role == 'Member' ||  user?.role ==  'Manager' ? "${sale.sales >= 0 ? '+' : '-'}₱${sale.sales.abs().toStringAsFixed(2)} " 
                : "${sale.sales <= 0 ? '+' : '-'}₱${sale.sales.abs().toStringAsFixed(2)} ",
              style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w400)),
        );
      },
    );
  }

  Container walletWidget(BuildContext context, String name, double money) {
    return Container(
      height: 194,
      width: 600,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$name Wallet Balance"),
            // Money
            // To 2 decimal places
            const SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₱${money.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 40)),

                // Add a QR code icon
                const SizedBox(width: 10),

                GestureDetector(
                  onTap: () {
                    // Add your onTap logic here
                  },
                  child: Transform.scale(
                    scale: 1.5,
                    child: Icon(Icons.qr_code,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),

            // Two buttons Add Money and Transfer

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  // Make the size bigger
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 9.0),
                  ),
                  child: const Row(
                    children: [
                      Text("Add Money",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16)),
                      SizedBox(width: 10),
                      Icon(Icons.add, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  // Add style seconday color
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 9.0),
                  ),
                  child: Row(
                    children: [
                      Text("Transfer",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16)),
                      const SizedBox(width: 10),
                      Icon(Icons.arrow_forward,
                          color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                ),
              ],
            )
            // Add Money

            // Transfer
          ],
        ),
      ),
    );
  }

Container loansWidget(BuildContext context, double maxLoan) {
  return Container(
    height: 300, // Adjust the height as needed
    width: 600,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Max Loan Amount"),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₱${maxLoan.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 40)),
            ],
          ),

          // Additional Content Section
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text 1
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Payable in: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  VerticalDivider(
                    width: 10,
                    thickness: 2, // Adjust the thickness as needed
                    color: Colors.grey,
                  ),
                ],
              ),

              // Text 2
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Interest Rate",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  VerticalDivider(
                    width: 80,
                    thickness: 2, // Adjust the thickness as needed
                    color: Colors.black,
                  ),
                ],
              ),

              // Text 3
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fees",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  VerticalDivider(
                    width: 10,
                    thickness: 8, // Adjust the thickness as needed
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}





  SizedBox listFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabTitles.length,
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
          );
        },
      ),
    );
  }

  

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title, style: TextStyle(fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(right: 16.0),
      //     child: CircleAvatar(
      //         backgroundColor: Colors.grey.shade300,
      //         child: IconButton(
      //           onPressed: () {
      //             // showAddPostPage(context);
      //           },
      //           icon: const Icon(Icons.add, color: Colors.white),
      //         ),
      //       ),
      //   ),
      // ],
    );
  }
}

