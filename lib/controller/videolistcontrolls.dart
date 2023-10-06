import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Model/video_model/video_model.dart';
import '../functions/utility_functions/video_function/video.dart';
import '../model/favorite_model/favorite_model.dart';

class VideoListControlls with ChangeNotifier {
  final TextEditingController reNameControllers = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Set<int> selectedVideos = Set<int>();
  bool isSelectingg = false;

  // filepicker function along with thumbnail
  Future<void> forPickVideo(BuildContext context) async {
    await pickVideo(context);
  }

// select multiple videos function
  void selectAllVideos(List<int> allIndices) {
    if (selectedVideos.length == allIndices.length) {
      selectedVideos.clear();
    } else {
      selectedVideos = Set<int>.from(allIndices);
    }
    notifyListeners();
  }

  // Function to handle deleting selected videos with multiply.
  void forDeleteSelectedVideos() {
    //function called here from Video utility function page
    deleteSelectedVideos(selectedVideos, () {
      isSelectingg = false;
      selectedVideos.clear();

      notifyListeners();
    });
  }

// clear selected videos
  void clearSelections() {
    isSelectingg = false;
    selectedVideos.clear();
    notifyListeners();
  }

  void toggleSelectedVideo(int index) {
    if (selectedVideos.contains(index)) {
      selectedVideos.remove(index);
    } else {
      selectedVideos.add(index);
    }
    notifyListeners();
  }

  // function to favorite video and un favorite

  void toggleFavoriteStatus(
      VideoModel video, Box<FavoriteVideoModel> favoriteVideoBox) {
    final isFavorite = favoriteVideoBox.values.any(
      (favoriteVideo) => favoriteVideo.favvideoPath == video.videoPath,
    );

    if (isFavorite) {
      final favoriteVideo = favoriteVideoBox.values.firstWhere(
        (favoriteVideo) => favoriteVideo.favvideoPath == video.videoPath,
      );
      favoriteVideoBox.delete(favoriteVideo.key);
    } else {
      final favoriteVideo = FavoriteVideoModel(
        favname: video.name,
        favvideoPath: video.videoPath,
        favThumbnailPath: video.thumbnailPath,
      );
      favoriteVideoBox.add(favoriteVideo);
    }

    notifyListeners(); // Notify listeners after updating data
  }
}
