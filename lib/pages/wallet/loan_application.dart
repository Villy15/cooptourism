import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoanApplicationPage extends ConsumerStatefulWidget {
  const LoanApplicationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoanApplicationPageState();
}

class _LoanApplicationPageState extends ConsumerState<LoanApplicationPage> {
  double _loanAmount = 50000.0;
  String _selectedDuration = '6 Months';
  String _selectedReason = 'Replenish Supply';
  final TextEditingController _detailedReasonController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Loans'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              loanSlider(),

              durationDropDown(),
              const SizedBox(height: 16.0),

              loanSummaryReason(),
              const SizedBox(height: 16.0),

              loanDetailedReason(),
              const SizedBox(height: 16.0),

              loanDetails(),

              // ... Add more fields for Duration, Loan Reason, Detailed Reason, etc. ...
              continueBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Padding continueBtn() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Trigger loan application submission
          },
          child: const Text('Continue'),
        ),
      ),
    );
  }

  Padding loanDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Interest per Month'),
                Text('0%'),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fees'),
                Text('₱100.00'),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration'),
                Text('12 Months'),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Amount Due'),
                Text('₱5,000.00'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextFormField loanDetailedReason() {
    return TextFormField(
      controller: _detailedReasonController,
      decoration: const InputDecoration(
        labelText: 'Detailed Reason (optional)',
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
      ),
      maxLines: 3,
    );
  }

  DropdownButtonFormField<String> loanSummaryReason() {
    return DropdownButtonFormField<String>(
      value: _selectedReason,
      decoration: const InputDecoration(
        labelText: 'Loan Reason',
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
      ),
      items: <String>[
        'Replenish Supply',
        'Expand Business',
        'Personal Use',
        'Other'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedReason = newValue!;
        });
      },
    );
  }

  DropdownButtonFormField<String> durationDropDown() {
    return DropdownButtonFormField<String>(
      value: _selectedDuration,
      decoration: const InputDecoration(
        labelText: 'Duration',
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
      ),
      items: <String>['6 Months', '12 Months', '18 Months', '24 Months']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedDuration = newValue!;
        });
      },
    );
  }

  Column loanSlider() {
    return Column(
      children: [
        ListTile(
          title: const Text("Loan Amount"),
          subtitle: Text("₱ ${_loanAmount.toStringAsFixed(2)}"),
          trailing: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("₱ 1,000 min"),
              Text("₱ 250,000 max"),
            ],
          ),
        ),
        Slider(
          value: _loanAmount,
          min: 1000,
          max: 250000,
          divisions: 249,
          label: _loanAmount.round().toString(),
          onChanged: (double value) {
            setState(() {
              _loanAmount = value;
            });
          },
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      // Assuming primaryColor is defined in your dark_theme.dart
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            child: IconButton(
              onPressed: () {
                // Settings or additional action
              },
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
