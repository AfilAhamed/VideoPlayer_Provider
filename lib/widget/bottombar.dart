import 'package:flutter/material.dart';
import 'package:videoplayer_miniproject/helpers/appcolors.dart';
import 'package:videoplayer_miniproject/view/favorite/favorite_list.dart';
import 'package:videoplayer_miniproject/view/video/video_list.dart';
import 'package:videoplayer_miniproject/view/chart/chart_screen.dart';
import 'package:videoplayer_miniproject/view/settings/settings_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int indexnum = 0;

  final screens = [
    const VideoList(),
    const FavoriteVideoList(),
    const StatisticsPage(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 26,
            unselectedFontSize: 15,
            selectedFontSize: 15,
            enableFeedback: true,
            fixedColor: Appcolors.secondaryTheme,
            backgroundColor: Appcolors.primaryTheme,
            unselectedItemColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.video_collection_sharp),
                label: 'Video',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favorite'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined), label: 'Chart'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings')
            ],
            currentIndex: indexnum,
            onTap: (int index) {
              setState(() {
                indexnum = index;
              });
            },
          ),
          body: screens.elementAt(indexnum)),
    );
  }
}
