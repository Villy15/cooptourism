import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<String> _tabTitles = ['Business', 'Cooperative'];
  int _selectedIndex = 0;

  final List<String> _filterTypes = ['Day', 'Week', 'Month', 'Year'];
  String _selectedFilterType = 'Month';
  DateTime _selectedDate = DateTime.now();
  PickerDateRange _selectedDateRange = PickerDateRange(DateTime.now(), DateTime.now().add(const Duration(days: 7)));

  final List<SalesData> chartData = [
    SalesData(DateTime(2023, 11, 5, 15, 30), 4000),
    SalesData(DateTime(2023, 11, 3, 16, 40), 7000),
    SalesData(DateTime(2023, 11, 4, 10, 30), 6000),
    SalesData(DateTime(2023, 11, 5, 10, 30), 5000),
    SalesData(DateTime(2023, 11, 8, 16, 30), 10000),
    SalesData(DateTime(2023, 11, 8, 19, 30), 2000),
  ];

  final List<SalesData> chartData2 = [
    // SalesData(DateTime(2023, 5, 1), 6000),
    // SalesData(DateTime(2023, 6, 1), 4000),
    // SalesData(DateTime(2023, 7, 1), 1000),
    // SalesData(DateTime(2023, 8, 1), 14000),
    // SalesData(DateTime(2023, 9, 1), 12000)
  ];

  final List<SalesData> chartData3 = [
    // SalesData(DateTime(2023, 5, 1), 1500),
    // SalesData(DateTime(2023, 6, 1), 7000),
    // SalesData(DateTime(2023, 7, 1), 4000),
    // SalesData(DateTime(2023, 8, 1), 2000),
    // SalesData(DateTime(2023, 9, 1), 1000)
  ];

  final List<SalesData> chartData4 = [
    // SalesData(DateTime(2023, 5, 1), 4000),
    // SalesData(DateTime(2023, 6, 1), 500),
    // SalesData(DateTime(2023, 7, 1), 13000),
    // SalesData(DateTime(2023, 8, 1), 7000),
    // SalesData(DateTime(2023, 9, 1), 6000)
  ];

  final List<SalesData> chartData5 = [
    // SalesData(DateTime(2023, 5, 1), 3000),
    // SalesData(DateTime(2023, 6, 1), 4000),
    // SalesData(DateTime(2023, 7, 1), 9500),
    // SalesData(DateTime(2023, 8, 1), 11000),
    // SalesData(DateTime(2023, 9, 1), 20000)
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDropdownButton(),
                Row(
                  children: [
                    // Add Icon of date
                    const Icon(Icons.calendar_today, color: primaryColor),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(_selectedFilterType == 'Week'
                          ? '${DateFormat('MM/dd/yyyy').format(_selectedDate)} - ${DateFormat('MM/dd/yyyy').format(_selectedDate.add(const Duration(days: 7)))}'
                          : _selectedFilterType == 'Month'
                              ? DateFormat.yMMM().format(_selectedDate)
                              : _selectedFilterType == 'Year'
                                  ? DateFormat.y().format(_selectedDate)
                                  : DateFormat.yMd().format(_selectedDate)),
                    ),
                  ],
                ),
              ],
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

    // Filter the data based on _selectedFilterType
    chartDataMap = chartDataMap.map((key, value) {
      List<SalesData> filteredData = [];
      switch (_selectedFilterType) {
        case 'Day':
      filteredData = value
          .where((element) =>
              element.year.day == _selectedDate.day &&
              element.year.month == _selectedDate.month &&
              element.year.year == _selectedDate.year)
              .toList();
          break;
        case 'Week':
          DateTime startWeek = _selectedDate;
          DateTime endWeek = _selectedDate.add(const Duration(days: 7));
          filteredData = value
              .where((element) =>
                  (element.year.isAtSameMomentAs(startWeek) ||
                      element.year.isAfter(startWeek)) &&
                  element.year.isBefore(endWeek))
              .toList();
          break;
        case 'Month':
          filteredData = value
              .where((element) =>
                  element.year.month == _selectedDate.month &&
              element.year.year == _selectedDate.year)
          .toList();
      break;
    case 'Year':
      filteredData = value
          .where((element) => element.year.year == _selectedDate.year)
          .toList();
      break;
      }
      // Sort the filtered data by date in ascending order
      filteredData.sort((a, b) => a.year.compareTo(b.year));
      return MapEntry(key, filteredData);
    });

    List<LineSeries<SalesData, DateTime>> createSeries() {
      return chartDataMap.entries.map((entry) {
        return LineSeries<SalesData, DateTime>(
          dataSource: entry.value,
          xValueMapper: (SalesData sales, _) => sales.year,
          yValueMapper: (SalesData sales, _) => sales.sales,
          color: colorMap[entry.key],
          legendItemText: entry.key,
          markerSettings: const MarkerSettings(isVisible: true),
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
      primaryXAxis: DateTimeAxis(
        dateFormat: _selectedFilterType == 'Week' ? DateFormat.MMMd() : null,
      ),
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

  void _selectDateMonthYear(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      initialDatePickerMode: _selectedFilterType == 'Month'
          ? DatePickerMode.year
          : _selectedFilterType == 'Year'
              ? DatePickerMode.year
              : DatePickerMode.day,
    );
    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked!;
      });
    }
  }

  void _selectDate(BuildContext context) {
    DateTime tempDate = _selectedDate;
    PickerDateRange tempDateRange = _selectedDateRange;
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          height: 350, // Increase the height to accommodate the buttons
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  tempDateRange = args.value as PickerDateRange;
                  tempDate = tempDateRange.startDate!;
                } else if (args.value is DateTime) {
                  tempDate = args.value as DateTime;
                }
              },
              // selectionMode: DateRangePickerSelectionMode.range,
              selectionMode: DateRangePickerSelectionMode.single,
              view: _selectedFilterType == 'Day'
                  ? DateRangePickerView.month
                  : _selectedFilterType == 'Week'
                      ? DateRangePickerView.month
                      : _selectedFilterType == 'Month'
                          ? DateRangePickerView.month
                          : DateRangePickerView.year,
              showActionButtons: true, // Enable the confirm and cancel buttons
              onSubmit: (Object? value) {
                setState(() {
                  _selectedDate = tempDate;
                  _selectedDateRange = tempDateRange;
                });
                Navigator.pop(context);
              },
              onCancel: () {
                // Pop the dialog without updating _selectedDate
                Navigator.pop(context);
              },
            ),
          ),
        ),
      );
    },
  );
}


  DropdownButton<String> _buildDropdownButton() {
    return DropdownButton<String>(
      value: _selectedFilterType,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: primaryColor),
      underline: Container(
        height: 2,
        color: primaryColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedFilterType = newValue!;
        });
      },
      items: _filterTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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
