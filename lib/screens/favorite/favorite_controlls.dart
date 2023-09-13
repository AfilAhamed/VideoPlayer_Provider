import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FavoriteControlls extends StatefulWidget {
  final VideoPlayerController _favcontroller;

  const FavoriteControlls(this._favcontroller, {super.key});

  @override
  State<FavoriteControlls> createState() => _FavoriteControllsState();
}

class _FavoriteControllsState extends State<FavoriteControlls> {
  // screen orientation function
  bool _isFullscreen = false;
  void _favtoggleFullscreen() {
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
  String _favvideoDuration(Duration duration) {
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
              if (widget._favcontroller.value.isPlaying) {
                widget._favcontroller.pause();
              } else {
                widget._favcontroller.play();
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
                          valueListenable: widget._favcontroller,
                          builder: (context, VideoPlayerValue value, child) {
                            return Text(
                              _favvideoDuration(value.position),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            );
                          }),
                      Expanded(
                        child: SizedBox(
                          height: 10,
                          child: VideoProgressIndicator(
                            widget._favcontroller,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                                backgroundColor: Colors.white,
                                playedColor: Colors.orange.shade700),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                        ),
                      ),
                      Text(
                        _favvideoDuration(widget._favcontroller.value.duration),
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
                          if (widget._favcontroller.value.volume == 0) {
                            widget._favcontroller.setVolume(1);
                          } else {
                            widget._favcontroller.setVolume(0);
                          }
                        });
                      },
                      icon: Icon(
                        widget._favcontroller.value.volume == 0
                            ? Icons.volume_off
                            : Icons.volume_up,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (widget._favcontroller.value.position -
                                const Duration(seconds: 10) >
                            Duration.zero) {
                          widget._favcontroller.seekTo(
                              widget._favcontroller.value.position -
                                  const Duration(seconds: 10));
                        }
                      },
                      icon: const Icon(
                        Icons.replay_10,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (widget._favcontroller.value.isPlaying) {
                            widget._favcontroller.pause();
                          } else {
                            widget._favcontroller.play();
                          }
                        });
                      },
                      icon: Icon(
                        widget._favcontroller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (widget._favcontroller.value.position +
                                const Duration(seconds: 10) <
                            widget._favcontroller.value.duration) {
                          widget._favcontroller.seekTo(
                              widget._favcontroller.value.position +
                                  const Duration(seconds: 10));
                        }
                      },
                      icon: const Icon(
                        Icons.forward_10,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _favtoggleFullscreen();
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
