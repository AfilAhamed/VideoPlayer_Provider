import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer_miniproject/controller/videocontrolls.dart';
import 'package:videoplayer_miniproject/helpers/appcolors.dart';

class VideoControls extends StatelessWidget {
  final VideoPlayerController _controller;

  const VideoControls(this._controller, {super.key});

  @override
  Widget build(BuildContext context) {
    //provider instance
    final controlProvider =
        Provider.of<VideoControllss>(context, listen: false);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
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
                          valueListenable: _controller,
                          builder: (context, VideoPlayerValue value, child) {
                            return Text(
                              controlProvider.videoDurationss(value.position),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            );
                          }),
                      Expanded(
                        child: SizedBox(
                          height: 10,
                          child: VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                                bufferedColor: Colors.white,
                                backgroundColor: Colors.white,
                                playedColor: Appcolors.secondaryTheme),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                        ),
                      ),
                      Text(
                        controlProvider
                            .videoDurationss(_controller.value.duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<VideoControllss>(
                  builder: (context, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            value.toggleVolume(_controller);
                          },
                          icon: Icon(
                            _controller.value.volume == 0
                                ? Icons.volume_off
                                : Icons.volume_up,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Duration newPosition = _controller.value.position -
                                const Duration(seconds: 10);

                            if (newPosition < Duration.zero) {
                              newPosition =
                                  Duration.zero; // Set to start of the video
                            }

                            _controller.seekTo(newPosition);
                          },
                          icon: const Icon(
                            Icons.replay_10,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            value.togglePlayPause(_controller);
                          },
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Duration newPosition = _controller.value.position +
                                const Duration(seconds: 10);
                            Duration videoDuration = _controller.value.duration;

                            if (newPosition > videoDuration) {
                              newPosition =
                                  videoDuration; // Set to end of the video
                            }
                            _controller.seekTo(newPosition);
                          },
                          icon: const Icon(
                            Icons.forward_10,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            value.toggleFullscreen();
                          },
                          icon: const Icon(
                            Icons.screen_rotation_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
