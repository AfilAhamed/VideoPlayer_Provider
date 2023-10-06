import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/favorite_model/favorite_model.dart';

class FavListControlls extends ChangeNotifier {
//select and  delete multiple videos function
  Set<int> favSelectedVideos = <int>{};
  bool isSelectings = false;

// function for select all videos
  void selectAllVideos(List<int> allIndices) {
    if (favSelectedVideos.length == allIndices.length) {
      favSelectedVideos.clear();
    } else {
      favSelectedVideos = Set<int>.from(allIndices);
    }
    notifyListeners();
  }

  // clear selected videos
  void clearSelections() {
    isSelectings = false;
    favSelectedVideos.clear();
    notifyListeners();
  }

  // Function to handle deleting selected videos and multiple videos
  void favDeleteSelectedVideos() {
    final favVideoBox = Hive.box<FavoriteVideoModel>('favorite');
    final List<int> selectedIndices = favSelectedVideos.toList();
    selectedIndices.sort((a, b) => b.compareTo(a));

    for (int index in selectedIndices) {
      final video = favVideoBox.getAt(index);
      if (video != null) {
        favVideoBox.deleteAt(index);
      }
    }

    isSelectings = false;
    favSelectedVideos.clear();
    notifyListeners();
  }

  void favtoggleSelectedVideos(int index) {
    if (favSelectedVideos.contains(index)) {
      favSelectedVideos.remove(index);
    } else {
      favSelectedVideos.add(index);
    }
    notifyListeners();
  }
}
