import 'package:cooptourism/data/models/manager_dashboard.dart/sales.dart';
import 'package:cooptourism/data/repositories/listing_repository.dart';
import 'package:cooptourism/data/repositories/manager_dashboard/sales_repository.dart';
import 'package:cooptourism/pages/wallet/loan_application.dart';
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
    final user = ref.watch(userModelProvider);

    // remove all tabTitles if role is Customer
    return Scaffold(
      appBar: _appBar(context, "Finance"),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (user?.role == 'Member' || user?.role == 'Manager') ...[
              listFilter(),
              const SizedBox(height: 10),
              _selectedIndex == 0
                  ? _buildWalletsContent()
                  : _selectedIndex == 1
                      ? _buildLoansContent()
                      : _buildDonateContent(),
            ] else ...[
              _buildWalletsContent()
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWalletsContent() {
    final user = ref.watch(userModelProvider);
    return StreamBuilder<Object>(
        stream: user?.role! == 'Customer'
            ? salesRepository.getAllSalesByCustomerId(user!.uid!)
            : user?.role! == 'Member'
                ? salesRepository.getAllSalesByOwnerId(user!.uid!)
                : salesRepository
                    .getAllSalesByCooperativeId("sslvO5tgDoCHGBO82kxq"),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: transactionHeading(),
              ),
              listTransactions(transactions),
            ],
          );
        });
  }

  Widget _buildLoansContent() {
    double maxLoan = 250000.00;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: loansWidget(context, maxLoan),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: _buildScrollableTerms(),
        ),
        const SizedBox(height: 10),
        // Add a Start button that expands to the full width
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoanApplicationPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.background,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text("Start Application",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableTerms() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      // Use a ConstrainedBox to limit the height of the SingleChildScrollView
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          // Set a max height for the scrollable area
          maxHeight: 280.0,
        ),
        child: const Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Loan terms and conditions\n',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'The terms and conditions upon which each loan shall be granted and repaid shall include but not be limited to the following—\n\n'
                  'a. every application for a loan shall be accompanied by such information about the financial position and income of the borrower as the Credit Committee or loans officer may require;\n\n'
                  'b. no society shall make a loan to an unincorporated organization. Where such a loan is contemplated, it shall be made to one or more of the members or officers of the organisation provided, however; that the society shall, in any such particular case, require such additional security by way of endorsement of the promissory note as may be deemed desirable;\n\n'
                  'c. no loan shall be made to a member if it would cause the total indebtedness of the member to the credit union to exceed 10 percent of the paid-up capital and deposits of the credit union;\n\n'
                  'd. the total of all loans made to associations, organizations or corporations, shall not, at any time, exceed 25 percent of the total shares and deposits of the credit union;\n\n'
                  'e. no loan shall be made to a company unless such loan is personally guaranteed by shareholders of the company holding a majority of the shares in value and in voting rights provided that such personal guarantee shall not be required where the loan is guaranteed by an organization or agency of Government;\n\n'
                  'f. no loan shall be made by a society to a corporation if a majority of the shares of the corporation are held by the officers and directors of the credit union unless the application has been approved by the Registrar;\n\n'
                  'g. transactions in the loan account of a member shall be shown by the necessary entries in a passbook or statement to be delivered to each member;\n\n'
                  'h. where a mortgage on land or building is taken as security for a loan, the amount loaned shall not exceed 90 percent of the market value of the land or buildings;\n\n'
                  'i. before such a loan is made, the Credit Committee or loan officer shall require that an appraisal of the market value of the property be made by an appraiser whom they believe to be competent and who is instructed and employed by the Credit Union independently of any owner of the property on a form approved by the Registrar;\n\n'
                  'j. the expenses, if any, of any appraiser employed pursuant to subparagraph (i) may be borne by the applicant for the loan.\n',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
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
          title: FutureBuilder(
              future: listingRepository.getListingTitle(sale.listingId!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final listingTitle = snapshot.data as String;
                return Text(listingTitle,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold));
              }),
          subtitle: Text(formattedDate,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
          trailing: Text(
              user?.role == 'Member' || user?.role == 'Manager'
                  ? "${sale.sales >= 0 ? '+' : '-'}₱${sale.sales.abs().toStringAsFixed(2)} "
                  : "${sale.sales <= 0 ? '+' : '-'}₱${sale.sales.abs().toStringAsFixed(2)} ",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
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
      height: 164, // Adjust the height as needed
      width: double.infinity, // This will take the full width available
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Max Loan Amount",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text("₱${NumberFormat('#,##0.00', 'en_US').format(maxLoan)}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(height: 24), // Space between amount and terms
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Payable in\n6-12 months", style: TextStyle(fontSize: 14)),
                Text("Interest Rate\n0% per month",
                    style: TextStyle(fontSize: 14)),
                Text("Fees\n2% one-time", style: TextStyle(fontSize: 14)),
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
                      : Theme.of(context).colorScheme.background,
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
      title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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
