import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:videoplayer_miniproject/Model/video_model/video_model.dart';

class SearchProvider extends ChangeNotifier {
  List<VideoModel> _searchResults = [];
  final _searchController = TextEditingController();

  List<VideoModel> get searchResults => _searchResults;

  TextEditingController get searchController => _searchController;

// search query function
  void performSearch(String query) {
    final videoBox = Hive.box<VideoModel>('videos');
    final List<VideoModel> allVideos = videoBox.values.toList();

    final List<VideoModel> searchResults = allVideos.where((video) {
      return video.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    _searchResults = searchResults;
    notifyListeners();
  }

//  clear search
  void clearSearch() {
    _searchController.clear();
    _searchResults.clear();
    notifyListeners();
  }
}
