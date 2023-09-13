import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoControls extends StatefulWidget {
  final VideoPlayerController _controller;

  const VideoControls(this._controller, {super.key});

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  // screen orientation function
  bool _isFullscreen = false;
  void _toggleFullscreen() {
    setState(() {
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
    });
  }

  //function for video duration
  String _videoDuration(Duration duration) {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (widget._controller.value.isPlaying) {
                widget._controller.pause();
              } else {
                widget._controller.play();
              }
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.black87,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ValueListenableBuilder(
                          valueListenable: widget._controller,
                          builder: (context, VideoPlayerValue value, child) {
                            return Text(
                              _videoDuration(value.position),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            );
                          }),
                      Expanded(
                        child: SizedBox(
                          height: 10,
                          child: VideoProgressIndicator(
                            widget._controller,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                                bufferedColor: Colors.white,
                                backgroundColor: Colors.white,
                                playedColor: Colors.orange.shade700),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                        ),
                      ),
                      Text(
                        _videoDuration(widget._controller.value.duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (widget._controller.value.volume == 0) {
                            widget._controller.setVolume(1);
                          } else {
                            widget._controller.setVolume(0);
                          }
                        });
                      },
                      icon: Icon(
                        widget._controller.value.volume == 0
                            ? Icons.volume_off
                            : Icons.volume_up,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Duration newPosition =
                            widget._controller.value.position -
                                const Duration(seconds: 10);

                        if (newPosition < Duration.zero) {
                          newPosition =
                              Duration.zero; // Set to start of the video
                        }

                        widget._controller.seekTo(newPosition);
                      },
                      icon: const Icon(
                        Icons.replay_10,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (widget._controller.value.isPlaying) {
                            widget._controller.pause();
                          } else {
                            widget._controller.play();
                          }
                        });
                      },
                      icon: Icon(
                        widget._controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Duration newPosition =
                            widget._controller.value.position +
                                const Duration(seconds: 10);
                        Duration videoDuration =
                            widget._controller.value.duration;

                        if (newPosition > videoDuration) {
                          newPosition =
                              videoDuration; // Set to end of the video
                        }

                        widget._controller.seekTo(newPosition);
                      },
                      icon: const Icon(
                        Icons.forward_10,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _toggleFullscreen();
                      },
                      icon: const Icon(
                        Icons.screen_rotation_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
