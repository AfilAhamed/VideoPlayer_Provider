import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:videoplayer_miniproject/model/chart_model/chart_model.dart';
import '../../Model/video_model/video_model.dart';
import '../../model/favorite_model/favorite_model.dart';
import '../mini_Screens/splash_screen.dart';

//clear from db - reset

Future<void> resetDB(
  BuildContext context,
) async {
  // ignore: use_build_context_synchronously
  bool confirmReset = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          "Confirm Reset",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to reset all settings",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.orange.shade700),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text(
              "Reset",
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

  if (confirmReset == true) {
    final videoDb = await Hive.openBox<VideoModel>('videos');
    videoDb.clear();
    final favoriteDb = await Hive.openBox<FavoriteVideoModel>('Favorite');
    favoriteDb.clear();
    final chartDB = await Hive.openBox<VideoStatistics>('statistics');
    chartDB.clear();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ));
  }
}
