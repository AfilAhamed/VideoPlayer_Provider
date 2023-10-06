import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

class FavoritePlayerControllerss extends ChangeNotifier {
  VideoPlayerController? _controller;
  bool _controlsVisible = true;
  late Timer _controlsTimer;

  VideoPlayerController? get controller => _controller;
  bool get controlsVisible => _controlsVisible;

  videoPlayerState(String videoPath) {
    _controller = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        _controller!.play();
        notifyListeners();
      });

    _controlsTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _updateControlsVisible(false);
    });
  }

// function for to visble controlls on taping
  void toggleControls() {
    _updateControlsVisible(!_controlsVisible);
    if (_controlsVisible) {
      resetControlsTimer();
    }
  }

// reset the duration of controll
  void resetControlsTimer() {
    _controlsTimer.cancel();
    _controlsTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _updateControlsVisible(false);
    });
  }

// update the visiblity of controlls
  void _updateControlsVisible(bool visible) {
    _controlsVisible = visible;
    notifyListeners();
  }

  void favUpdate() {
    notifyListeners();
  }
}
