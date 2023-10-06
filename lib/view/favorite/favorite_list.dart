import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:videoplayer_miniproject/controller/favlistcontrolls.dart';
import 'package:videoplayer_miniproject/functions/db_functions/favorite_db_function/favorite_functions.dart';
import 'package:videoplayer_miniproject/helpers/appcolors.dart';
import 'package:videoplayer_miniproject/view/favorite/favorite_player.dart';
import 'package:videoplayer_miniproject/widget/showdailog.dart';
import '../../model/favorite_model/favorite_model.dart';

class FavoriteVideoList extends StatelessWidget {
  const FavoriteVideoList({super.key});

  @override
  Widget build(BuildContext context) {
    //provider instance
    final favlistProvider = Provider.of<FavListControlls>(context);

    final favoriteVideoBox = Hive.box<FavoriteVideoModel>('Favorite');
    final multipledelete = favoriteVideoBox.values.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: favlistProvider.isSelectings
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Appcolors.primaryTheme,
              title:
                  Text('${favlistProvider.favSelectedVideos.length} selected'),
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      favlistProvider.clearSelections();
                    },
                    icon: const Icon(Icons.clear_rounded)),
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () {
                    favlistProvider.selectAllVideos(
                      List<int>.generate(multipledelete.length, (i) => i),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                  ),
                  onPressed: favlistProvider.favSelectedVideos.isNotEmpty
                      ? () {
                          showDeleteConfirmationDialog(context, favlistProvider,
                              () {
                            favlistProvider.favDeleteSelectedVideos();
                          });
                        }
                      : null,
                ),
              ],
            )
          : AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Appcolors.primaryTheme,
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
                    Lottie.asset('lib/assets/favorite.json',
                        fit: BoxFit.cover, height: 300),
                    const Text(
                      'No favorite videos',
                      style: TextStyle(
                          color: Appcolors.primaryTheme,
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
                  final favIsSelected =
                      favlistProvider.favSelectedVideos.contains(index);

                  return GestureDetector(
                    onTap: () {
                      if (favlistProvider.isSelectings) {
                        favlistProvider.favtoggleSelectedVideos(index);
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
                      favlistProvider.isSelectings = true;
                      favlistProvider.favtoggleSelectedVideos(index);
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
