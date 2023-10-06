import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerControllss extends ChangeNotifier {
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

// function for controlls visble and unvisble on tap
  void toggleControls() {
    _updateControlsVisible(!_controlsVisible);
    if (_controlsVisible) {
      resetControlsTimer();
    }
  }

// controlls time rester function
  void resetControlsTimer() {
    _controlsTimer.cancel();
    _controlsTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _updateControlsVisible(false);
    });
  }

// Video controls visibilty
  void _updateControlsVisible(bool visible) {
    _controlsVisible = visible;
    notifyListeners();
  }

// seek forward and backward when double tapping on the screen
  void handleDoubleTap(bool forward) {
    final currentPosition = _controller?.value.position;
    if (currentPosition != null) {
      final seekTime = forward ? 10 : -10;
      final newPosition = currentPosition + Duration(seconds: seekTime);

      final videoDuration = _controller!.value.duration;

      final clampedPosition = newPosition > Duration.zero
          ? (newPosition < videoDuration ? newPosition : videoDuration)
          : Duration.zero;

      _controller!.seekTo(clampedPosition);
      resetControlsTimer();
    }
  }

  void update() {
    notifyListeners();
  }
}
