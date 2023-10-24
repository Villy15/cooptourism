import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatelessWidget {
  const MyPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    const double fullPercentage = 100.0;
    return PieChart(
      
      PieChartData(
        sections: [
          PieChartSectionData(
            value: fullPercentage,
            color: Colors.white,
            radius: 25,
          ),
          PieChartSectionData(
            value: 100,
            color: Theme.of(context).colorScheme.primary,
            radius: 25,
          )
        ]
      )
    );
  }
}