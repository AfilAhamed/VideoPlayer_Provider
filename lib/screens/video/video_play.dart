import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer_miniproject/screens/video/video_controlls.dart';
import '../../Model/video_model/video_model.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoModel videoModel;

  const VideoPlayerWidget(this.videoModel, {Key? key}) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _controlsVisible = true;
  late Timer _controlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoModel.videoPath))
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
    _controlsTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _controlsVisible = false;
      });
    });
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
      if (_controlsVisible) {
        _controlsTimer.cancel();
        _controlsTimer = Timer.periodic(const Duration(seconds: 5), (_) {
          setState(() {
            _controlsVisible = false;
          });
        });
      }
    });
  }

  //reset the controls timer
  void _resetControlsTimer() {
    _controlsTimer.cancel();
    _controlsTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _controlsVisible = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controlsTimer.cancel();
    super.dispose();
  }

  //Double tap function----------------

  void _handleDoubleTap(bool forward) {
    final currentPosition = _controller.value.position;
    final seekTime = forward ? 10 : -10;
    final newPosition = currentPosition + Duration(seconds: seekTime);

    final videoDuration = _controller.value.duration;

    final clampedPosition = newPosition > Duration.zero
        ? (newPosition < videoDuration ? newPosition : videoDuration)
        : Duration.zero;

    _controller.seekTo(clampedPosition);

    _resetControlsTimer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (MediaQuery.of(context).orientation == Orientation.landscape) {
          // Set the orientation to portrait
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          return false; // Prevent default back button behavior
        }
        return true; // Allow default back button behavior
      },
      child: GestureDetector(
        onDoubleTapDown: (details) => _handleDoubleTap(
            details.localPosition.dx >= MediaQuery.of(context).size.width / 2),
        onTap: () {
          setState(() {
            _toggleControls();
            _resetControlsTimer(); // Restart the timer on every tap
          });
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(1),
                child: Center(
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child: VideoPlayer(_controller),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _controlsVisible ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !_controlsVisible,
                  child: Column(
                    children: [
                      AppBar(
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                            onPressed: () {
                              // Set the orientation to portrait and pop
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitUp,
                                DeviceOrientation.portraitDown,
                              ]);
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back)),
                        title: Text(
                          widget.videoModel.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(child: Container()), // Space

                      VideoControls(
                          _controller), //  video controls class called here
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
