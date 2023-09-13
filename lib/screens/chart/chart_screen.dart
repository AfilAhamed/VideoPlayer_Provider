import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:videoplayer_miniproject/model/chart_model/chart_model.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  StatisticsPageState createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  String selectedPeriod = 'Day'; // Default selection

  @override
  Widget build(BuildContext context) {
    final statisticsBox = Hive.box<VideoStatistics>('statistics');
    final data = statisticsBox.values.toList();

    final filteredData = data.where((statistics) {
      final today = DateTime.now();
      final statisticsDate = DateTime.parse(statistics.period);

      if (selectedPeriod == 'Day') {
        return statisticsDate.isAfter(today.subtract(const Duration(days: 1)));
      } else if (selectedPeriod == 'Week') {
        return statisticsDate.isAfter(today.subtract(const Duration(days: 7)));
      } else if (selectedPeriod == 'Month') {
        return statisticsDate.isAfter(today.subtract(const Duration(days: 30)));
      }

      return false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Video Statistics'),
        actions: [
          DropdownButton<String>(
            iconEnabledColor: Colors.orange,
            dropdownColor: Colors.black,
            iconSize: 27,
            style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 17,
                fontWeight: FontWeight.bold),
            value: selectedPeriod,
            onChanged: (newValue) {
              setState(() {
                selectedPeriod = newValue!;
              });
            },
            items: ['Day', 'Week', 'Month'].map((period) {
              return DropdownMenuItem<String>(
                value: period,
                child: Text(
                  period,
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: Center(
        child: StatisticsChart(filteredData),
      ),
    );
  }
}

class StatisticsChart extends StatelessWidget {
  final List<VideoStatistics> filteredData;

  const StatisticsChart(this.filteredData, {super.key});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      [
        charts.Series<VideoStatistics, String>(
          id: 'Added',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (VideoStatistics statistics, _) => statistics.period,
          measureFn: (VideoStatistics statistics, _) => statistics.addedCount,
          data: filteredData,
        ),
        charts.Series<VideoStatistics, String>(
          id: 'Deleted',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (VideoStatistics statistics, _) => statistics.period,
          measureFn: (VideoStatistics statistics, _) => statistics.deletedCount,
          data: filteredData,
        ),
      ],
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [
        charts.SeriesLegend(
          position: charts.BehaviorPosition.top, // Legend at the top
          desiredMaxRows: 2, // Limit to 2 rows for better alignment
        ),
      ],
    );
  }
}
