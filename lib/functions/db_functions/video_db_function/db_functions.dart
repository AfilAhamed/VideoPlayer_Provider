import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:videoplayer_miniproject/model/chart_model/chart_model.dart';
import '../../../Model/video_model/video_model.dart';

//delete from db with a confirmation show dailog..

Future<void> deleteFromDB(BuildContext context, int id) async {
  final videoDB = await Hive.openBox<VideoModel>('videos');

  // ignore: use_build_context_synchronously
  bool confirmDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          "Confirm Deletion",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to delete this video?",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.orange.shade700),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.orange.shade700),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );

  if (confirmDelete == true) {
    await videoDB.deleteAt(id);
  }

  final statisticsBox = Hive.box<VideoStatistics>('statistics');
  final now = DateTime.now();
  final period =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final existingStatistics = statisticsBox.get(period);
  if (existingStatistics != null) {
    existingStatistics.deletedCount += 1;
    statisticsBox.put(period, existingStatistics);
  } else {
    final statistics = VideoStatistics(
      period: period,
      addedCount: 0,
      deletedCount: 1,
    );
    statisticsBox.put(period, statistics);
  }
}
