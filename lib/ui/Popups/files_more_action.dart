// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gleamy_files/ui/Widgets/outl_btn_with_padding.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:gleamy_files/Scripts/file_helper.dart';
import 'package:gleamy_files/main.dart';

void showFileOrFolderMoreActionDialog(String path, BuildContext context, Function onDialogPop) {
  showDialog(context: context, builder:(context) {
    if (FileSystemEntity.isDirectorySync(path)) {
      return _ShowFolderDialog(path, context, onDialogPop);
    } else {
      return _ShowFileDialog(path, context, onDialogPop);
    }
  });
}

Dialog _ShowFileDialog(String path, BuildContext context, Function onDialogPop) {
  return Dialog( 
    child: Container(
      width: 500,
      padding: .all(15),
      height: 260,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          OutlineBtnWithPadding(
            text: "Open",
            onClick: () async {
              Navigator.of(context).pop();
              await OpenFilex.open(path);
            },
          ),
          OutlineBtnWithPadding(
            text: "Rename",
            onClick: () async {
              Navigator.of(context).pop();
              await renameFileDialog(context, path);
              onDialogPop();
            }
          ),
          OutlineBtnWithPadding(
            text: "Delete",
            onClick: () async {
              Navigator.of(context).pop();
              await deleteFileDialoge(context, path);
              onDialogPop();
            },
          ),
          OutlineBtnWithPadding(
            text: _addToFavoritsText(path),
            onClick: () => _addToFavorits(path, context, onDialogPop),
          ),
          Row(
            spacing: 6,
            children: [
              Expanded(
                child: OutlineBtnWithPadding(
                  text: "Copy",
                  onClick: () async {
                    Navigator.of(context).pop();
                    await copyOrMoveDialoge(context, path, false);
                    onDialogPop();
                  },
                ),
              ),
              Expanded(
                child: OutlineBtnWithPadding(
                  text: "Move",
                  onClick: () async {
                    Navigator.of(context).pop();
                    await copyOrMoveDialoge(context, path, true);
                    onDialogPop();
                  },
                ),
              ),
            ],
          ),
          
        ],
      ),
    ),
  );
}

Dialog _ShowFolderDialog(String path, BuildContext context, Function onDialogPop) {
  return Dialog( 
    child: Container(
      width: 500,
      padding: .all(15),
      height: 260,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          // OutlineBtnWithPadding(
          //   text: "Rename",
          //   onClick: () async {
          //     Navigator.of(context).pop();
          //     await renameFileDialog(context, path);
          //     onDialogPop();
          //   }
          // ), TODO
          // OutlineBtnWithPadding(
          //   text: "Delete",
          //   onClick: () async {
          //     Navigator.of(context).pop();
          //     await deleteFileDialoge(context, path);
          //     onDialogPop();
          //   },
          // ), TODO
          OutlineBtnWithPadding(
            text: _addToFavoritsText(path),
            onClick: () => _addToFavorits(path, context, onDialogPop),
          ),
          // Row(
          //   spacing: 6,
          //   children: [
          //     Expanded(
          //       child: OutlineBtnWithPadding(
          //         text: "Copy",
          //         onClick: () async {
          //           Navigator.of(context).pop();
          //           await copyOrMoveDialoge(context, path, false);
          //           onDialogPop();
          //         },
          //       ),
          //     ),
          //     Expanded(
          //       child: OutlineBtnWithPadding(
          //         text: "Move",
          //         onClick: () async {
          //           Navigator.of(context).pop();
          //           await copyOrMoveDialoge(context, path, true);
          //           onDialogPop();
          //         },
          //       ),
          //     ),
          //   ],
          // ), TODO
          
        ],
      ),
    ),
  );
}


String _addToFavoritsText(String path) => appSettings.favoritePaths.contains(path) ? "Remove from favorites" : "Add to favorites";

void _addToFavorits(String path, BuildContext context, Function onDialogPop) {
  Navigator.of(context).pop();
  if (appSettings.favoritePaths.contains(path)) {
    appSettings.favoritePaths.remove(path);
    showToast("Removed from favorites:\n$path", context: context);
  } else {
    appSettings.favoritePaths.add(path);
    showToast("Added to favorites:\n$path", context: context);
  }
  appSettings.saveSettings();
  onDialogPop();
}