import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gleamy_files/Scripts/file_helper.dart';
import 'package:path/path.dart' as Path;

class FileDetailsPanel extends StatelessWidget {
  const FileDetailsPanel({super.key, required this.path});
  final String path;
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width > 700) {
      bool isFile = FileSystemEntity.isFileSync(path);
      String fileInfo = "";
      String folderInfo = "";
      if (isFile && path.isNotEmpty) {
        var stat = File(path).statSync();
        fileInfo = "Size: ${stat.size} Bytes\nModified: ${stat.modified}\nAccessed: ${stat.accessed}";
      } else if (FileSystemEntity.isDirectorySync(path) && path.isNotEmpty) {
        var stat = Directory(path).statSync();
        folderInfo = "Size: ${stat.size} Bytes\nModified: ${stat.modified}\nAccessed: ${stat.accessed}";
      }

      return SelectionArea(
        child: Container(
          width: 300,
          padding: .all(15),
          decoration: BoxDecoration(
            borderRadius: .only(topRight: .circular(25), bottomRight: .circular(25)),
            color: Theme.of(context).colorScheme.surfaceContainerLowest
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Container(
                width: 270,
                height: 270,
                margin: .only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: .circular(15)
                ),
                child: Icon(
                  getIconByExtention(Path.extension(path)),
                  size: 160,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              
              Text(path),
              Text(isFile ? fileInfo : folderInfo),
            ],
          ),
        ),
      );
    }
    return SizedBox();
  }
}