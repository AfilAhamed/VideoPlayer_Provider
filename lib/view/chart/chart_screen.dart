import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:videoplayer_miniproject/controller/chartcontrolls.dart';
import 'package:videoplayer_miniproject/helpers/appcolors.dart';
import 'package:videoplayer_miniproject/model/chart_model/chart_model.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //provider instance
    final chartprovider = Provider.of<ChartControlls>(context);

    final statisticsBox = Hive.box<VideoStatistics>('statistics');
    final data = statisticsBox.values.toList();
    final filteredData = chartprovider.filterDataByPeriod(data);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Appcolors.primaryTheme,
        title: const Text('Video Statistics'),
        actions: [
          Consumer<ChartControlls>(
            builder: (context, value, child) {
              return DropdownButton<String>(
                iconEnabledColor: Appcolors.secondaryTheme,
                dropdownColor: Appcolors.primaryTheme,
                iconSize: 27,
                style: TextStyle(
                    color: Appcolors.secondaryTheme,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
                value: chartprovider.selectedPeriod,
                onChanged: (newValue) {
                  chartprovider.setSelectedPeriod(newValue!);
                },
                items: ['Day', 'Week', 'Month'].map((period) {
                  return DropdownMenuItem<String>(
                    value: period,
                    child: Text(
                      period,
                    ),
                  );
                }).toList(),
              );
            },
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
