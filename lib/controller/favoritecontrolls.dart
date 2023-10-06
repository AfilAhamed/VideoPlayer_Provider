import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FavVideoControlls extends ChangeNotifier {
  bool _isFullscreen = false;
  bool get isFullscreen => _isFullscreen;

// volume mute and unmute function
  void toggleVolumee(VideoPlayerController favcontroller) {
    if (favcontroller.value.volume == 0) {
      favcontroller.setVolume(1);
    } else {
      favcontroller.setVolume(0);
    }
    notifyListeners();
  }

//play and paus button function
  void togglePlayPause(VideoPlayerController favcontroller) {
    if (favcontroller.value.isPlaying) {
      favcontroller.pause();
    } else {
      favcontroller.play();
    }
    notifyListeners();
  }

// landscape and portrait  function
  void favtoggleFullscreen() {
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
  String favvideoDuration(Duration duration) {
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
}
