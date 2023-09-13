import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:videoplayer_miniproject/Screens/mini_Screens/splash_screen.dart';
import 'package:videoplayer_miniproject/model/chart_model/chart_model.dart';
import 'package:videoplayer_miniproject/model/favorite_model/favorite_model.dart';
import 'Model/video_model/video_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(VideoModelAdapter().typeId)) {
    Hive.registerAdapter(VideoModelAdapter());
  }
  if (!Hive.isAdapterRegistered(FavoriteVideoModelAdapter().typeId)) {
    Hive.registerAdapter(FavoriteVideoModelAdapter());
  }

  if (!Hive.isAdapterRegistered(VideoStatisticsAdapter().typeId)) {
    Hive.registerAdapter(VideoStatisticsAdapter());
  }

  await Hive.openBox<VideoModel>('videos');
  await Hive.openBox<FavoriteVideoModel>('Favorite');
  await Hive.openBox<VideoStatistics>('statistics');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video player',
      home: SplashScreen(),
    );
  }
}
