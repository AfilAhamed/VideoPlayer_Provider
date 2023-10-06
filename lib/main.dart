import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:videoplayer_miniproject/controller/chartcontrolls.dart';
import 'package:videoplayer_miniproject/controller/favlistcontrolls.dart';
import 'package:videoplayer_miniproject/controller/favoritecontrolls.dart';
import 'package:videoplayer_miniproject/controller/favvideoplayercontroller.dart';
import 'package:videoplayer_miniproject/controller/videocontrolls.dart';
import 'package:videoplayer_miniproject/controller/searchcontrolls.dart';
import 'package:videoplayer_miniproject/controller/videolistcontrolls.dart';
import 'package:videoplayer_miniproject/controller/videoplayercontrolls.dart';
import 'package:videoplayer_miniproject/model/chart_model/chart_model.dart';
import 'package:videoplayer_miniproject/model/favorite_model/favorite_model.dart';
import 'package:videoplayer_miniproject/view/sub_screens/splash_screen.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChartControlls(),
        ),
        ChangeNotifierProvider(
          create: (context) => VideoListControlls(),
        ),
        ChangeNotifierProvider(
          create: (context) => VideoControllss(),
        ),
        ChangeNotifierProvider(
          create: (context) => VideoPlayerControllss(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavVideoControlls(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavListControlls(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoritePlayerControllerss(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Video player',
        home: SplashScreen(),
      ),
    );
  }
}
