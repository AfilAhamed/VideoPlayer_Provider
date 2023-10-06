import 'package:flutter/material.dart';
import 'package:videoplayer_miniproject/helpers/appcolors.dart';

void showDeleteConfirmationDialog(
    BuildContext context, clear, Function onDelete) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Appcolors.primaryTheme,
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
                color: Appcolors.secondaryTheme,
              ),
            ),
            onPressed: () {
              clear.clearSelections();

              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Delete',
              style: TextStyle(
                color: Appcolors.secondaryTheme,
              ),
            ),
            onPressed: () {
              onDelete();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
