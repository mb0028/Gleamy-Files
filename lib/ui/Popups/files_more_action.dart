// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gleamy_files/ui/Popups/toast.dart';
import 'package:open_filex/open_filex.dart';
import 'package:gleamy_files/ui/Popups/file_page_helper_dialogs.dart';
import 'package:gleamy_files/main.dart';
import 'package:path/path.dart' as Path;

void showFileOrFolderMoreActionDialog(String path, BuildContext context, Function onDialogPop) {
  showDialog(context: context, builder: (context) {
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
          Column(
            spacing: 8,
            crossAxisAlignment: .stretch,
            children: [
              Text(Path.basename(path), textAlign: .center,),
              OutlinedButton(
                child: Text("Open"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await OpenFilex.open(path);
                },
              ),
              OutlinedButton(
                child: Text("Rename"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await renameFileDialog(context, path);
                  onDialogPop();
                }
              ),
              OutlinedButton(
                child: Text("Delete"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await deleteFileDialoge(context, path);
                  onDialogPop();
                },
              ),
              OutlinedButton(
                child: Text(_addToFavoritsText(path)),
                onPressed: () => _addToFavorits(path, context, onDialogPop),
              ),
              Row(
                spacing: 6,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      child: Text("Copy"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await copyOrMoveDialoge(context, path, false);
                        onDialogPop();
                      },
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton(
                      child: Text("Move"),
                      onPressed: () async {
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
          Column(
            spacing: 8,
            crossAxisAlignment: .stretch,
            children: [
              Text(Path.basename(path), textAlign: .center,),
              OutlinedButton(
                child: Text("Rename"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await renameFileDialog(context, path, isFolder: true);
                  onDialogPop();
                }
              ),
              OutlinedButton(
                child: Text("Delete"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await deleteFileDialoge(context, path, isFolder: true);
                  onDialogPop();
                },
              ),
              OutlinedButton(
                child: Text(_addToFavoritsText(path)),
                onPressed: () => _addToFavorits(path, context, onDialogPop),
              ),
            ],
          ),
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
    showStyledToast("Removed from favorites:\n$path", context);
  } else {
    appSettings.favoritePaths.add(path);
    showStyledToast("Added to favorites:\n$path", context);
  }
  appSettings.saveSettings();
  onDialogPop();
}