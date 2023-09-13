import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:videoplayer_miniproject/functions/db_functions/favorite_db_function/favorite_functions.dart';
import 'package:videoplayer_miniproject/screens/favorite/favorite_player.dart';
import '../../model/favorite_model/favorite_model.dart';

class FavoriteVideoList extends StatefulWidget {
  const FavoriteVideoList({super.key});

  @override
  State<FavoriteVideoList> createState() => _FavoriteVideoListState();
}

class _FavoriteVideoListState extends State<FavoriteVideoList> {
  //select and  delete multiple videos function
  Set<int> favSelectedVideos = Set<int>();
  bool _isSelecting = false;

  // Function to handle deleting selected videos and multiple videos
  void _favDeleteSelectedVideos() {
    final favVideoBox = Hive.box<FavoriteVideoModel>('favorite');
    final List<int> selectedIndices = favSelectedVideos.toList();
    selectedIndices.sort((a, b) => b.compareTo(a));

    for (int index in selectedIndices) {
      final video = favVideoBox.getAt(index);
      if (video != null) {
        favVideoBox.deleteAt(index);
      }
    }
    setState(() {
      _isSelecting = false;
      favSelectedVideos.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteVideoBox = Hive.box<FavoriteVideoModel>('Favorite');
    final multipledelete = favoriteVideoBox.values.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isSelecting
          ? AppBar(
              backgroundColor: Colors.black,
              title: Text('${favSelectedVideos.length} selected'),
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      if (_isSelecting) {
                        setState(() {
                          _isSelecting = false;
                          favSelectedVideos.clear();
                        });
                      }
                    },
                    icon: const Icon(Icons.clear_rounded)),
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () {
                    setState(() {
                      if (favSelectedVideos.length == multipledelete.length) {
                        favSelectedVideos.clear();
                      } else {
                        favSelectedVideos = Set<int>.from(List<int>.generate(
                            multipledelete.length, (i) => i));
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                  ),
                  onPressed: favSelectedVideos.isNotEmpty
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
                                          favSelectedVideos.clear();
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
                                      _favDeleteSelectedVideos();
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
              title: const Text('Favorite'),
            ),
      body: Padding(
        padding: const EdgeInsets.only(top: 9),
        child: ValueListenableBuilder(
          valueListenable: favoriteVideoBox.listenable(),
          builder: (context, Box<FavoriteVideoModel> box, _) {
            final favoriteVideos = box.values.toList();

            if (favoriteVideos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/images/favorite.json',
                        fit: BoxFit.cover, height: 300),
                    const Text(
                      'No favorite videos',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.separated(
                itemCount: favoriteVideos.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1,
                  );
                },
                itemBuilder: (context, index) {
                  final favoriteVideo = favoriteVideos[index];
                  final favIsSelected = favSelectedVideos.contains(index);

                  return GestureDetector(
                    onTap: () {
                      if (_isSelecting) {
                        setState(() {
                          if (favIsSelected) {
                            favSelectedVideos.remove(index);
                          } else {
                            favSelectedVideos.add(index);
                          }
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoritePlayer(favoriteVideo),
                          ),
                        );
                      }
                    },
                    onLongPress: () {
                      setState(() {
                        _isSelecting = true;
                        if (favIsSelected) {
                          favSelectedVideos.remove(index);
                        } else {
                          favSelectedVideos.add(index);
                        }
                      });
                    },
                    child: Slidable(
                      endActionPane:
                          ActionPane(motion: const DrawerMotion(), children: [
                        SlidableAction(
                          onPressed: (context) {
                            deleteFavfromDB(context, index);
                          },
                          icon: Icons.delete,
                          label: 'Delete',
                          backgroundColor: Colors.red,
                        )
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
                                  File(favoriteVideo.favThumbnailPath!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (favIsSelected)
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
                        title: Text(
                          favoriteVideo.favname,
                          style: const TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
