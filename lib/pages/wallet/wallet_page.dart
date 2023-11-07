import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final List<String> _tabTitles = ['Wallets', 'Loans', 'Donate'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    String name = "Adrian";
    double money = 1000.00;

    // Create a sample of a transactions where it has product, timestamp, amount
    List<Transaction> transactions = [
      Transaction(product: 'Item 1', timestamp: DateTime.now(), amount: 10.0),
      Transaction(product: 'Item 2', timestamp: DateTime.now(), amount: 20.0),
      Transaction(product: 'Item 3', timestamp: DateTime.now(), amount: 30.0),
      Transaction(product: 'Item 1', timestamp: DateTime.now(), amount: 10.0),
      Transaction(product: 'Item 2', timestamp: DateTime.now(), amount: 20.0),
      Transaction(product: 'Item 3', timestamp: DateTime.now(), amount: 30.0),
      Transaction(product: 'Item 1', timestamp: DateTime.now(), amount: 10.0),
      Transaction(product: 'Item 2', timestamp: DateTime.now(), amount: 20.0),
      Transaction(product: 'Item 3', timestamp: DateTime.now(), amount: 30.0),
    ];

    return Scaffold(
      appBar: _appBar(context, "Wallet"),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            listFilter(),
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: walletWidget(context, name, money),
            ),
            const SizedBox(height: 10),
    
            // ListsView Builder of transactions table
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: transactionHeading(),
            ),
            listTransactions(transactions)
          ],
        ),
      ),
    );
  }

  Row transactionHeading() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Transactions",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),

        //  See all underline
        Text("See All",
            style: TextStyle(
                decoration: TextDecoration.underline, fontSize: 16.0)),
      ],
    );
  }

  ListView listTransactions(List<Transaction> transactions) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: transactions.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final formattedDate =
            DateFormat('MMM dd yyyy | hh:mm a').format(transaction.timestamp);
        return ListTile(
          leading: const Icon(Icons.payment),
          title: Text(transaction.product,
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold)),
          subtitle: Text(formattedDate,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w400)),
          trailing: Text(
              "${transaction.amount >= 0 ? '+' : '-'}${transaction.amount.abs().toStringAsFixed(2)} ",
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: IconButton(
                onPressed: () {
                  // showAddPostPage(context);
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ),
        ),
      ],
    );
  }
}

class Transaction {
  final String product;
  final DateTime timestamp;
  final double amount;

  Transaction(
      {required this.product, required this.timestamp, required this.amount});
}
