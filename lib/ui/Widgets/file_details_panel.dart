import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gleamy_files/Scripts/file_helper.dart';
import 'package:path/path.dart' as Path;

class FileDetailsPanel extends StatelessWidget {
  const FileDetailsPanel({super.key, required this.path});
  final String path;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth> 700) {
      bool isFile = FileSystemEntity.isFileSync(path);
      String size = ""; String modified = ""; String accessed = "";

      if (isFile && path.isNotEmpty) {
        var stat = File(path).statSync();
        var m = stat.modified;
        var a = stat.accessed;
        size = "Size: ${stat.size} Bytes";
        modified = "Modified: ${m.day}/${m.month}/${m.year}";
        accessed = "Accessed: ${a.day}/${a.month}/${a.year}";
      }
      else if (FileSystemEntity.isDirectorySync(path) && path.isNotEmpty) {
        var stat = Directory(path).statSync();
        var m = stat.modified;
        var a = stat.accessed;
        size = "Size: ${stat.size} Bytes";
        modified = "Modified: ${m.day}/${m.month}/${m.year}";
        accessed = "Accessed: ${a.day}/${a.month}/${a.year}";
      }

      return SelectionArea(
        child: Container(
          width: 240 + (screenWidth / 10),
          padding: .all(15),
          decoration: BoxDecoration(
            borderRadius: .only(topRight: .circular(25), bottomRight: .circular(25)),
            color: Theme.of(context).colorScheme.surfaceContainerLowest
          ),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 8,
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
              Row(
                spacing: 10,
                children: [
                  Icon(Icons.scale_rounded, size: 38,),
                  Text(size),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  Icon(Icons.edit_calendar_outlined, size: 38,),
                  Text(modified),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  Icon(Icons.open_in_new_rounded, size: 38,),
                  Text(accessed),
                ],
              ),
              Text(path),
            ],
          ),
        ),
      );
    }
    return SizedBox();
  }
}