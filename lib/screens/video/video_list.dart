import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:videoplayer_miniproject/functions/utility_functions/video_function/video.dart';
import 'package:videoplayer_miniproject/screens/mini_Screens/search.dart';
import 'package:videoplayer_miniproject/screens/video/video_play.dart';
import 'package:videoplayer_miniproject/functions/db_functions/video_db_function/db_functions.dart';
import '../../Model/video_model/video_model.dart';
import 'package:lottie/lottie.dart';
import '../../model/favorite_model/favorite_model.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key});
  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  final TextEditingController _reNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Set<int> selectedVideos = Set<int>();
  bool _isSelecting = false;

  // filepicker function along with thumbnail
  Future<void> _pickVideo(BuildContext context) async {
    await pickVideo(context);
  }

  // Function to handle deleting selected videos with multiply.
  void _deleteSelectedVideos() {
    //function called here from Video utility function page
    deleteSelectedVideos(selectedVideos, () {
      setState(() {
        _isSelecting = false;
        selectedVideos.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoBox = Hive.box<VideoModel>('videos');
    final favoriteVideoBox = Hive.box<FavoriteVideoModel>('Favorite');
    final multipledelete = videoBox.values.toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isSelecting
          ? AppBar(
              backgroundColor: Colors.black,
              title: Text('${selectedVideos.length} selected'),
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      if (_isSelecting) {
                        setState(() {
                          _isSelecting = false;
                          selectedVideos.clear();
                        });
                      }
                    },
                    icon: const Icon(Icons.clear_rounded)),
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () {
                    setState(() {
                      if (selectedVideos.length == multipledelete.length) {
                        selectedVideos.clear();
                      } else {
                        selectedVideos = Set<int>.from(List<int>.generate(
                            multipledelete.length, (i) => i));
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                  ),
                  onPressed: selectedVideos.isNotEmpty
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.black,
                                title: const Text(
                                  'Delete Selected Videos',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: const Text(
                                  'Are you sure you want to delete the selected videos?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Colors.orange.shade700),
                                    ),
                                    onPressed: () {
                                      if (_isSelecting) {
                                        setState(() {
                                          _isSelecting = false;
                                          selectedVideos.clear();
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.orange.shade700),
                                    ),
                                    onPressed: () {
                                      _deleteSelectedVideos();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      : null,
                ),
              ],
            )
          : AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VideoSearchScreen(),
                          ));
                    },
                    icon: Icon(
                      Icons.search_outlined,
                      color: Colors.orange.shade700,
                      size: 30,
                    )),
                const SizedBox(
                  width: 10,
                ),
              ],
              title: const Text('Video'),
            ),

      body: Padding(
        padding: const EdgeInsets.only(top: 9),
        child: ValueListenableBuilder(
          valueListenable: videoBox.listenable(),
          builder: (context, Box<VideoModel> box, _) {
            final videos = box.values.toList();
            //lottie based on condition
            if (videos.isEmpty) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/images/data.json',
                      fit: BoxFit.cover, height: 300),
                  const Text(
                    'Video is Empty',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  )
                ],
              ));
            } else {
              return GestureDetector(
                child: ListView.separated(
                  itemCount: videos.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 1,
                    );
                  },
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    final isSelected = selectedVideos.contains(index);
                    return GestureDetector(
                      onTap: () {
                        if (_isSelecting) {
                          setState(() {
                            if (isSelected) {
                              selectedVideos.remove(index);
                            } else {
                              selectedVideos.add(index);
                            }
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerWidget(video),
                            ),
                          );
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          _isSelecting = true;
                          if (isSelected) {
                            selectedVideos.remove(index);
                          } else {
                            selectedVideos.add(index);
                          }
                        });
                      },
                      child: Slidable(
                        endActionPane:
                            ActionPane(motion: const DrawerMotion(), children: [
                          SlidableAction(
                            spacing: 5,
                            onPressed: (context) {
                              _reNameController.text =
                                  video.name; //to show current name when update
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: Text(
                                      'Enter new name for ${video.name}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    content: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: _reNameController,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.orange,
                                                        width: 3)),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.orange,
                                                        width: 3)),
                                            hintText: 'New Video Name',
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  _reNameController.clear();
                                                },
                                                icon: const Icon(
                                                  Icons.clear,
                                                  color: Colors.orange,
                                                ))),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a valid video name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // update function
                                            final updatedName =
                                                _reNameController.text;
                                            final oldName = video.name;
                                            video.name = updatedName;
                                            await videoBox.putAt(index, video);
                                            Navigator.pop(context);

                                            // Show a snackbar for the successful update
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Center(
                                                  child: Text(
                                                      'Video name updated from "$oldName" to "$updatedName"'),
                                                ),
                                                duration:
                                                    const Duration(seconds: 2),
                                                backgroundColor: Colors.blue,
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          'Rename',
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icons.edit,
                            backgroundColor: Colors.blue,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            spacing: 5,
                            onPressed: (context) {
                              deleteFromDB(context, index); //delete from hive
                            },
                            icon: Icons.delete,
                            backgroundColor: Colors.red,
                            label: 'Delete',
                          ),
                        ]),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                          leading: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              SizedBox(
                                height: double.infinity,
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(video.thumbnailPath!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                final isFavorite = favoriteVideoBox.values.any(
                                  (favoriteVideo) =>
                                      favoriteVideo.favvideoPath ==
                                      video.videoPath,
                                );
                                if (isFavorite) {
                                  final favoriteVideo =
                                      favoriteVideoBox.values.firstWhere(
                                    (favoriteVideo) =>
                                        favoriteVideo.favvideoPath ==
                                        video.videoPath,
                                  );
                                  favoriteVideoBox.delete(favoriteVideo.key);
                                } else {
                                  final favoriteVideo = FavoriteVideoModel(
                                      favname: video.name,
                                      favvideoPath: video.videoPath,
                                      favThumbnailPath: video.thumbnailPath);
                                  favoriteVideoBox.add(favoriteVideo);
                                }

                                HapticFeedback
                                    .mediumImpact(); // Provide haptic feedback
                              });
                            },
                            icon: Icon(
                              favoriteVideoBox.values.any(
                                (favoriteVideo) =>
                                    favoriteVideo.favvideoPath ==
                                    video.videoPath,
                              )
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            video.name,
                            style: const TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
      //add button to add videos
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickVideo(context),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
