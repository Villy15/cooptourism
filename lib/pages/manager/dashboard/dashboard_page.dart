import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:cooptourism/data/models/manager_dashboard.dart/sales.dart';
import 'package:cooptourism/data/repositories/manager_dashboard/sales_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

final SalesRepository salesRepository = SalesRepository();

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

  @override
  void initState() {
    super.initState();
    // salesRepository.addSaleManually();
  }

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

            dashBoardFunctions(context),

            if (_selectedIndex == 0) ...[
              // Business
              businessDashboard(),
            ] else if (_selectedIndex == 1) ...[
              // Cooperative
              const Text('Cooperative Dashboard'),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  StreamBuilder<List<SalesData>> businessDashboard() {
    return StreamBuilder(
      stream: salesRepository.getAllSales(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<SalesData> sales = snapshot.data as List<SalesData>;

        // Filtered sales
        final filteredSales = sales
            .where((element) => filterDataBasedOnSelection(element))
            .toList();

        // Total sales
        final totalSales = filteredSales.fold<num>(
            0, (previousValue, element) => previousValue + element.sales);

        // Average sales
        final averageSales = totalSales / filteredSales.length;

        return Column(
          children: [
            // Summary Cards
            _buildSummaryCards(totalSales, averageSales),

            // Line Chart
            lineChartContainer(sales),

            // Pie Chart
            pieChartContainer(sales),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCards(num totalSales, double averageSales) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryCard('Total Sales', '₱${totalSales.toStringAsFixed(2)}'),
          _buildSummaryCard(
              'Average Sales', '₱${averageSales.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(color: primaryColor)),
            ],
          ),
        ),
      ),
    );
  }

  Padding pieChartContainer(List<SalesData> sales) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Change this color to match your design
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey
                  .withOpacity(0.2), // Change this color to match your design
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: pieChart(sales),
        ),
      ),
    );
  }

  Padding lineChartContainer(List<SalesData> sales) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Change this color to match your design
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey
                  .withOpacity(0.2), // Change this color to match your design
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: lineChart(sales),
        ),
      ),
    );
  }

  Row dashBoardFunctions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildDropdownButton(),
            // Add a today button
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedDate = DateTime.now();
                });
              },
              child: const Text('Today?'),
            ),
          ],
        ),
        Row(
          children: [
            // Add Icon of date
            const Icon(Icons.calendar_today, color: primaryColor),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(_selectedFilterType == 'Week'
                  ? '${DateFormat('MM/dd/yyyy').format(_selectedDate)} - ${DateFormat('MM/dd/yyyy').format(_selectedDate.add(const Duration(days: 6)))}'
                  : _selectedFilterType == 'Month'
                      ? DateFormat.yMMM().format(_selectedDate)
                      : _selectedFilterType == 'Year'
                          ? DateFormat.y().format(_selectedDate)
                          : DateFormat.yMd().format(_selectedDate)),
            ),
          ],
        ),
      ],
    );
  }

  SfCartesianChart lineChart(List<SalesData> sales) {
    // Filter the data based on selection.
    final filteredSales =
        sales.where((element) => filterDataBasedOnSelection(element)).toList();

    // Group the filtered data by category.
    final chartDataByCategory = filteredSales
        .fold<Map<String, List<SalesData>>>({}, (previousValue, element) {
      if (previousValue.containsKey(element.category)) {
        previousValue[element.category]!.add(element);
      } else {
        previousValue[element.category] = [element];
      }
      return previousValue;
    });

    // Create a line series for each category.
    List<LineSeries<SalesData, DateTime>> createSeries() {
      return chartDataByCategory.entries.map((entry) {
        return LineSeries<SalesData, DateTime>(
          dataSource: entry.value,
          xValueMapper: (SalesData sales, _) => sales.date,
          yValueMapper: (SalesData sales, _) => sales.sales,
          name: entry.key, // Use the category name here.
          color: getColorForCategory(entry.key),
          markerSettings: const MarkerSettings(isVisible: true),
        );
      }).toList();
    }

    // Get the maximum sales value from all categories.
    num maxSales = chartDataByCategory.values
        .expand((i) => i)
        .reduce((curr, next) => curr.sales > next.sales ? curr : next)
        .sales;

    return SfCartesianChart(
      title: ChartTitle(
          text: 'Sales Trend by Service Category',
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
        maximum: maxSales.toDouble(),
        interval: 1000,
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

  SfCircularChart pieChart(List<SalesData> sales) {
    // Filter the data based on selection.
    final filteredSales =
        sales.where((element) => filterDataBasedOnSelection(element)).toList();

    // Aggregate the filtered data by category.
    final aggregatedChartData =
        filteredSales.fold<Map<String, num>>({}, (previousValue, element) {
      if (previousValue.containsKey(element.category)) {
        previousValue[element.category] =
            previousValue[element.category]! + element.sales;
      } else {
        previousValue[element.category] = element.sales;
      }
      return previousValue;
    });

    List<PieSeries<SalesData, String>> createSeries() {
      return [
        PieSeries<SalesData, String>(
          dataSource: aggregatedChartData.entries.map((entry) {
            return SalesData(
              date: DateTime.now(),
              sales: entry.value,
              category: entry.key,
            );
          }).toList(),
          xValueMapper: (SalesData data, _) => data.category,
          yValueMapper: (SalesData data, _) => data.sales,
          dataLabelMapper: (SalesData data, _) =>
              '₱${data.sales.toStringAsFixed(2)}',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            connectorLineSettings:
                ConnectorLineSettings(type: ConnectorType.line),
            textStyle: TextStyle(color: primaryColor, fontSize: 12),
            labelIntersectAction: LabelIntersectAction.shift,
          ),
          pointColorMapper: (SalesData data, _) =>
              getColorForCategory(data.category),
          // Position the legends to the bottom
        )
      ];
    }

    return SfCircularChart(
      title: ChartTitle(
          text: 'Sales Participation by Service Category',
          textStyle: const TextStyle(
              color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
      legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom),
      series: createSeries(),
    );
  }

  bool filterDataBasedOnSelection(SalesData data) {
    switch (_selectedFilterType) {
      case 'Day':
        return data.date.day == _selectedDate.day &&
            data.date.month == _selectedDate.month &&
            data.date.year == _selectedDate.year;
      case 'Week':
        DateTime startWeek =
            _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
        DateTime endWeek = startWeek.add(const Duration(days: 7));
        return data.date.isAfter(startWeek) &&
            data.date.isBefore(endWeek.add(const Duration(days: 1)));
      case 'Month':
        return data.date.month == _selectedDate.month &&
            data.date.year == _selectedDate.year;
      case 'Year':
        return data.date.year == _selectedDate.year;
      default:
        return true;
    }
  }

// Helper function to get color for category.
  Color getColorForCategory(String category) {
    // Define your color mapping here
    Map<String, Color> colorMap = {
      'Accomodation': Colors.blue.shade200,
      'Transportation': Colors.red.shade200,
      'Food Service': Colors.green.shade200,
      'Entertainment': Colors.yellow.shade200,
      'Touring': Colors.purple.shade200,
    };
    return colorMap[category] ?? Colors.black; // Default color if not found.
  }

  void _selectDate(BuildContext context) {
    DateTime tempDate = _selectedDate;

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
                  if (args.value is DateTime) {
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
                showActionButtons:
                    true, // Enable the confirm and cancel buttons
                onSubmit: (Object? value) {
                  setState(() {
                    _selectedDate = tempDate;
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
          updateSelectedDate();
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

  void updateSelectedDate() {
    if (_selectedFilterType == 'Week') {
      setState(() {
        _selectedDate = DateTime.now().subtract(const Duration(days: 7));
      });
    } else if (_selectedFilterType == 'Day') {
      setState(() {
        _selectedDate = DateTime.now();
      });
    } else if (_selectedFilterType == 'Month') {
      setState(() {
        _selectedDate = DateTime.now();
      });
    } else if (_selectedFilterType == 'Year') {
      setState(() {
        _selectedDate = DateTime.now();
      });
    }
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
