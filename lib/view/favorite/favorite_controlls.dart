import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer_miniproject/controller/favoritecontrolls.dart';
import 'package:videoplayer_miniproject/helpers/appcolors.dart';

class FavoriteControlls extends StatelessWidget {
  final VideoPlayerController _favcontroller;

  const FavoriteControlls(this._favcontroller, {super.key});

  @override
  Widget build(BuildContext context) {
    //provider instance
    final controlprovider =
        Provider.of<FavVideoControlls>(context, listen: false);
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (_favcontroller.value.isPlaying) {
                _favcontroller.pause();
              } else {
                _favcontroller.play();
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
                          valueListenable: _favcontroller,
                          builder: (context, VideoPlayerValue value, child) {
                            return Text(
                              controlprovider.favvideoDuration(value.position),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            );
                          }),
                      Expanded(
                        child: SizedBox(
                          height: 10,
                          child: VideoProgressIndicator(
                            _favcontroller,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                                backgroundColor: Colors.white,
                                playedColor: Appcolors.secondaryTheme),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                        ),
                      ),
                      Text(
                        controlprovider
                            .favvideoDuration(_favcontroller.value.duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<FavVideoControlls>(
                  builder: (context, favvideo, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            favvideo.toggleVolumee(_favcontroller);
                          },
                          icon: Icon(
                            _favcontroller.value.volume == 0
                                ? Icons.volume_off
                                : Icons.volume_up,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_favcontroller.value.position -
                                    const Duration(seconds: 10) >
                                Duration.zero) {
                              _favcontroller.seekTo(
                                  _favcontroller.value.position -
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
                            favvideo.togglePlayPause(_favcontroller);
                          },
                          icon: Icon(
                            _favcontroller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_favcontroller.value.position +
                                    const Duration(seconds: 10) <
                                _favcontroller.value.duration) {
                              _favcontroller.seekTo(
                                  _favcontroller.value.position +
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
                            favvideo.favtoggleFullscreen();
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
