import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoControllss extends ChangeNotifier {
  bool _isFullscreen = false;

// functio for landscape and portrait
  void toggleFullscreen() {
    _isFullscreen = !_isFullscreen;
    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    notifyListeners();
  }

// video duration function
  String videoDurationss(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

// mute and unmute function
  void toggleVolume(VideoPlayerController controller) {
    if (controller.value.volume == 0) {
      controller.setVolume(1);
    } else {
      controller.setVolume(0);
    }
    notifyListeners();
  }

// play and pause functon
  void togglePlayPause(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    notifyListeners();
  }
}
