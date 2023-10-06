import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:videoplayer_miniproject/controller/videolistcontrolls.dart';
import 'package:videoplayer_miniproject/helpers/appcolors.dart';
import 'package:videoplayer_miniproject/view/sub_screens/search.dart';
import 'package:videoplayer_miniproject/view/video/video_play.dart';
import 'package:videoplayer_miniproject/functions/db_functions/video_db_function/db_functions.dart';
import 'package:videoplayer_miniproject/view/video/widget/showdailogg.dart';
import '../../Model/video_model/video_model.dart';
import 'package:lottie/lottie.dart';
import '../../model/favorite_model/favorite_model.dart';
import '../../widget/showdailog.dart';

class VideoList extends StatelessWidget {
  const VideoList({super.key});
  @override
  Widget build(BuildContext context) {
    //provider instance
    final videoprovider = Provider.of<VideoListControlls>(context);

    final videoBox = Hive.box<VideoModel>('videos');
    final favoriteVideoBox = Hive.box<FavoriteVideoModel>('Favorite');
    final multipledelete = videoBox.values.toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: videoprovider.isSelectingg
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Appcolors.primaryTheme,
              title: Text('${videoprovider.selectedVideos.length} selected'),
              actions: <Widget>[
                IconButton(
                    onPressed: videoprovider.clearSelections,
                    icon: const Icon(Icons.clear_rounded)),
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () {
                    videoprovider.selectAllVideos(
                      List<int>.generate(multipledelete.length, (i) => i),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                  ),
                  onPressed: videoprovider.selectedVideos.isNotEmpty
                      ? () {
                          showDeleteConfirmationDialog(context, videoprovider,
                              () {
                            videoprovider.forDeleteSelectedVideos();
                          });
                        }
                      : null,
                ),
              ],
            )
          : AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Appcolors.primaryTheme,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const VideoSearchScreenState(),
                          ));
                    },
                    icon: Icon(
                      Icons.search_outlined,
                      color: Appcolors.secondaryTheme,
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
                  Lottie.asset('lib/assets/data.json',
                      fit: BoxFit.cover, height: 300),
                  const Text(
                    'Video is Empty',
                    style: TextStyle(
                        color: Appcolors.primaryTheme,
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
                    final isSelected =
                        videoprovider.selectedVideos.contains(index);
                    return GestureDetector(
                      onTap: () {
                        if (videoprovider.isSelectingg) {
                          videoprovider.toggleSelectedVideo(index);
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
                        videoprovider.isSelectingg = true;
                        videoprovider.toggleSelectedVideo(index);
                      },
                      child: Slidable(
                        endActionPane:
                            ActionPane(motion: const DrawerMotion(), children: [
                          SlidableAction(
                            spacing: 5,
                            onPressed: (context) {
                              //when click on edit icon a dailog appear to edit video name
                              showRenameDialog(context, videoprovider, video,
                                  videoBox, index);
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
                              // function to make a video favorite or not
                              videoprovider.toggleFavoriteStatus(
                                  video, favoriteVideoBox);
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
        onPressed: () => videoprovider.forPickVideo(context),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
