import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer_miniproject/controller/videoplayercontrolls.dart';
import 'package:videoplayer_miniproject/widget/bottombar.dart';
import 'package:videoplayer_miniproject/helpers/appcolors.dart';
import 'package:videoplayer_miniproject/view/video/video_controlls.dart';
import '../../Model/video_model/video_model.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoModel videoModel;

  const VideoPlayerWidget(this.videoModel, {Key? key}) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Timer _controlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoModel.videoPath))
      ..initialize().then((_) {
        _controller.play();
        final videoPlayerprovider =
            Provider.of<VideoPlayerControllss>(context, listen: false);
        videoPlayerprovider.update();
        // setState(() {});
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
    // provider instance
    final videoPlayerprovider = Provider.of<VideoPlayerControllss>(context);

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
        onDoubleTapDown: (details) => videoPlayerprovider.handleDoubleTap(
            details.localPosition.dx >= MediaQuery.of(context).size.width / 2),
        onTap: () {
          videoPlayerprovider.toggleControls();
          videoPlayerprovider
              .resetControlsTimer(); // Restart the timer on every tap
        },
        child: Scaffold(
          backgroundColor: Appcolors.primaryTheme,
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
                opacity: videoPlayerprovider.controlsVisible ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !videoPlayerprovider.controlsVisible,
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BottomBar(),
                                  ));
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
