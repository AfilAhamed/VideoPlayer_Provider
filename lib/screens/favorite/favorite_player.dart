import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer_miniproject/model/favorite_model/favorite_model.dart';
import 'package:videoplayer_miniproject/screens/favorite/favorite_controlls.dart';

class FavoritePlayer extends StatefulWidget {
  final FavoriteVideoModel favModel;

  const FavoritePlayer(this.favModel, {Key? key}) : super(key: key);

  @override
  FavoritePlayerState createState() => FavoritePlayerState();
}

class FavoritePlayerState extends State<FavoritePlayer> {
  late VideoPlayerController _controller;
  bool _controlsVisible = true;
  late Timer _controlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.favModel.favvideoPath))
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });

    _controlsTimer = Timer.periodic(const Duration(seconds: 4), (_) {
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
        _controlsTimer = Timer.periodic(const Duration(seconds: 4), (_) {
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
    _controlsTimer = Timer.periodic(const Duration(seconds: 4), (_) {
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
                          widget.favModel.favname,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(child: Container()), // Space

                      FavoriteControlls(
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
