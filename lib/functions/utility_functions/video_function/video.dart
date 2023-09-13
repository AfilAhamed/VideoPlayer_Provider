import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '../../../Model/video_model/video_model.dart';
import '../../../model/chart_model/chart_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as video_thumbnail;
import 'package:hive_flutter/hive_flutter.dart';

//function for picking video from file with thumbnail and chart calculation
Future<void> pickVideo(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.video,
    allowMultiple: true,
  );
  if (result != null && result.files.isNotEmpty) {
    final videoBox = Hive.box<VideoModel>('videos');
    final videosToAdd = await Future.wait(result.files.map((file) async {
      final String videoPath = file.path!;
      final String videoName = videoPath.split('/').last;
      final Directory documentsDir = await getApplicationDocumentsDirectory();
      final String thumbnailPath =
          "${documentsDir.path}/thumbnails/$videoName.jpg";

      await Directory(dirname(thumbnailPath)).create(recursive: true);
      await video_thumbnail.VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: thumbnailPath,
        imageFormat: video_thumbnail.ImageFormat.JPEG,
        quality: 50,
      );
      return VideoModel(
        name: videoName,
        videoPath: videoPath,
        thumbnailPath: thumbnailPath,
      );
    }));
    await videoBox.addAll(videosToAdd);

    // Show a success snackbar if video geted
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding:
            const EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
        content: Center(
            child: Text(
          'Video added successfully',
          style: TextStyle(
              color: Colors.orange.shade700, fontWeight: FontWeight.bold),
        )),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 1),
      ),
    );
    //-------------
    // chart calculation of video added
    final now = DateTime.now();
    final statisticsBox = Hive.box<VideoStatistics>('statistics');
    final periods =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final existingStatistics = statisticsBox.get(periods);
    if (existingStatistics != null) {
      existingStatistics.addedCount += videosToAdd.length;
      statisticsBox.put(periods, existingStatistics);
    } else {
      final statistics = VideoStatistics(
        period: periods,
        addedCount: videosToAdd.length,
        deletedCount: 0,
      );
      statisticsBox.put(periods, statistics);
    }
  } else {
    // Show an error snackbar if video didnt get
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        padding: EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
        content:
            Center(child: Text('Video didn\'t get added. Please try again.')),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

//function for multiple selection and deletion

void deleteSelectedVideos(
  Set<int> selectedVideos,
  Function() setStateCallback,
) {
  final videoBox = Hive.box<VideoModel>('videos');
  final List<int> selectedIndices = selectedVideos.toList();
  selectedIndices.sort((a, b) => b.compareTo(a));

  int totalDeletedCount = 0;

  for (int index in selectedIndices) {
    final video = videoBox.getAt(index);
    if (video != null) {
      videoBox.deleteAt(index);
      totalDeletedCount++;
    }
  }

  final statisticsBox = Hive.box<VideoStatistics>('statistics');
  final now = DateTime.now();
  final period =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final existingStatistics = statisticsBox.get(period);
  if (existingStatistics != null) {
    existingStatistics.deletedCount += totalDeletedCount;
    statisticsBox.put(period, existingStatistics);
  } else {
    final statistics = VideoStatistics(
      period: period,
      addedCount: 0,
      deletedCount: totalDeletedCount,
    );
    statisticsBox.put(period, statistics);
  }

  // Call the setStateCallback to trigger setState in your widget
  setStateCallback();
}
