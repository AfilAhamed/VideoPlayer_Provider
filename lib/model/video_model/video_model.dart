import 'dart:io';
import 'package:hive/hive.dart';
part 'video_model.g.dart';

@HiveType(typeId: 0)
class VideoModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  final String videoPath;
  @HiveField(2)
  String? thumbnailPath;

  bool isFavorite = false;

  File? file;

  VideoModel(
      {required this.videoPath,
      required this.name,
      required this.thumbnailPath});
}
