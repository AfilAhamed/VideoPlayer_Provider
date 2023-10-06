import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../Model/video_model/video_model.dart';
import '../../../controller/videolistcontrolls.dart';
import '../../../helpers/appcolors.dart';

// function to show the rename dialog
Future<void> showRenameDialog(
  BuildContext context,
  VideoListControlls videoprovider,
  VideoModel video,
  Box<VideoModel> videoBox,
  int index,
) async {
  final updatedNameController = TextEditingController();
  updatedNameController.text = video.name;
//
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Appcolors.primaryTheme,
        title: Text(
          'Enter new name for ${video.name}',
          style: const TextStyle(color: Colors.white),
        ),
        content: Form(
          key: videoprovider.formKey,
          child: TextFormField(
            style: const TextStyle(color: Appcolors.primaryTheme),
            controller: updatedNameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Appcolors.secondaryTheme, width: 3),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Appcolors.secondaryTheme, width: 3),
              ),
              hintText: 'New Video Name',
              suffixIcon: IconButton(
                onPressed: () {
                  updatedNameController.clear();
                },
                icon: Icon(
                  Icons.clear,
                  color: Appcolors.secondaryTheme,
                ),
              ),
            ),
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
            child: Text(
              'Cancel',
              style: TextStyle(color: Appcolors.secondaryTheme),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (videoprovider.formKey.currentState!.validate()) {
                // Update function
                final updatedName = updatedNameController.text;
                final oldName = video.name;
                video.name = updatedName;
                await videoBox.putAt(index, video);
                Navigator.pop(context);

                // Show a snackbar for the successful update
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        'Video name updated from "$oldName" to "$updatedName"',
                      ),
                    ),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.blue,
                  ),
                );
              }
            },
            child: Text(
              'Rename',
              style: TextStyle(color: Appcolors.secondaryTheme),
            ),
          ),
        ],
      );
    },
  );
}
