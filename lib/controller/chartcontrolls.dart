import 'package:flutter/material.dart';

import '../model/chart_model/chart_model.dart';

class ChartControlls extends ChangeNotifier {
  String _selectedPeriod = 'Day'; // Default selection
  List<VideoStatistics> _data = [];

  String get selectedPeriod => _selectedPeriod;
  List<VideoStatistics> get data => _data;

  void setSelectedPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners(); // Notify listeners when the selected period changes
  }

  void setData(List<VideoStatistics> newData) {
    _data = newData;
    notifyListeners(); // Notify listeners when the data changes
  }

//filter function
  List<VideoStatistics> filterDataByPeriod(List<VideoStatistics> data) {
    final today = DateTime.now();

    return data.where((statistics) {
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
  }
}
