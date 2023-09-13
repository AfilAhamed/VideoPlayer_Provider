import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:videoplayer_miniproject/model/favorite_model/favorite_model.dart';

//delete from db

Future<void> deleteFavfromDB(BuildContext context, int id) async {
  final favoriteDB = await Hive.openBox<FavoriteVideoModel>('Favorite');

  // ignore: use_build_context_synchronously
  bool confirmDeletes = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          "Confirm Deletion",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to delete this video?",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.orange.shade700),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.orange.shade700),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );

  if (confirmDeletes == true) {
    await favoriteDB.deleteAt(id);
  }
}
