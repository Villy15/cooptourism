import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<String> _tabTitles = ['Cooperative', 'Business'];
  int _selectedIndex = 0;

  final List<SalesData> chartData = [
    SalesData(DateTime(2023, 5), 10000),
    SalesData(DateTime(2023, 6), 2000),
    SalesData(DateTime(2023, 7), 4000),
    SalesData(DateTime(2023, 8), 6000),
    SalesData(DateTime(2023, 9), 5000)
  ];

  final List<SalesData> chartData2 = [
    SalesData(DateTime(2023, 5), 6000),
    SalesData(DateTime(2023, 6), 4000),
    SalesData(DateTime(2023, 7), 1000),
    SalesData(DateTime(2023, 8), 14000),
    SalesData(DateTime(2023, 9), 12000)
  ];

  final List<SalesData> chartData3 = [
    SalesData(DateTime(2023, 5), 1500),
    SalesData(DateTime(2023, 6), 7000),
    SalesData(DateTime(2023, 7), 4000),
    SalesData(DateTime(2023, 8), 2000),
    SalesData(DateTime(2023, 9), 1000)
  ];

  final List<SalesData> chartData4 = [
    SalesData(DateTime(2023, 5), 4000),
    SalesData(DateTime(2023, 6), 500),
    SalesData(DateTime(2023, 7), 13000),
    SalesData(DateTime(2023, 8), 7000),
    SalesData(DateTime(2023, 9), 6000)
  ];

  final List<SalesData> chartData5 = [
    SalesData(DateTime(2023, 5), 3000),
    SalesData(DateTime(2023, 6), 4000),
    SalesData(DateTime(2023, 7), 9500),
    SalesData(DateTime(2023, 8), 11000),
    SalesData(DateTime(2023, 9), 20000)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Dashboard"),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            // Lists Filter
            SizedBox(
              height: 40,
              child: listViewFilter(),
            ),

            // Sales Dashboard
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Change this color to match your design
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(
                          0.2), // Change this color to match your design
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: lineChart(),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  SfCartesianChart lineChart() {
    Map<String, List<SalesData>> chartDataMap = {
      'Accomodation': chartData,
      'Transportation': chartData2,
      'Food Service': chartData3,
      'Entertainment': chartData4,
      'Touring': chartData5,
    };

    Map<String, Color> colorMap = {
      'Accomodation': primaryColor,
      'Transportation': Colors.red,
      'Activities': Colors.green,
      'Food Service': Colors.blue,
      'Touring': Colors.purple,
    };

    List<LineSeries<SalesData, DateTime>> createSeries() {
      return chartDataMap.entries.map((entry) {
        return LineSeries<SalesData, DateTime>(
          dataSource: entry.value,
          xValueMapper: (SalesData sales, _) => sales.year,
          yValueMapper: (SalesData sales, _) => sales.sales,
          color: colorMap[entry.key],
          legendItemText: entry.key,
          // markerSettings: const MarkerSettings(isVisible: true),
        );
      }).toList();
    }

    return SfCartesianChart(
      title: ChartTitle(
          text: 'Sales from Services',
          textStyle: const TextStyle(
              color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
      plotAreaBorderColor: Colors.transparent,
      legend: const Legend(
          isVisible: true,
          alignment: ChartAlignment.center,
          position: LegendPosition.bottom),
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat('₱#,##0'),
        // in maximum, get the maximum of the all SalesData in chartDatas
        maximum: [...chartData, ...chartData2, ...chartData3]
            .reduce((curr, next) => curr.sales > next.sales ? curr : next)
            .sales,
        interval: 1000,
        // in minimum, get the minimum of the all SalesData in chartDatas
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        canShowMarker: false,
        format: 'point.x : point.y',
      ),
      series: createSeries(),
    );
  }

  ListView listViewFilter() {
    return ListView.builder(
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
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                // showAddPostPage(context);
              },
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}
