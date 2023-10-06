import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer_miniproject/helpers/appcolors.dart';
import 'package:videoplayer_miniproject/model/favorite_model/favorite_model.dart';
import 'package:videoplayer_miniproject/view/favorite/favorite_controlls.dart';
import '../../controller/favvideoplayercontroller.dart';

class FavoritePlayer extends StatefulWidget {
  final FavoriteVideoModel favModel;

  const FavoritePlayer(this.favModel, {Key? key}) : super(key: key);

  @override
  FavoritePlayerState createState() => FavoritePlayerState();
}

class FavoritePlayerState extends State<FavoritePlayer> {
  late VideoPlayerController _controller;
  late Timer _controlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.favModel.favvideoPath))
      ..initialize().then((_) {
        _controller.play();
        final favprovider =
            Provider.of<FavoritePlayerControllerss>(context, listen: false);
        favprovider.favUpdate();
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
    //provider instance
    final favproviderr = Provider.of<FavoritePlayerControllerss>(context);

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
          favproviderr.toggleControls();
          favproviderr.resetControlsTimer();
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
                opacity: favproviderr.controlsVisible ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !favproviderr.controlsVisible,
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
