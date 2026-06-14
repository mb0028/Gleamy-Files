import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gleamy_files/Scripts/file_helper.dart';
import 'package:path/path.dart' as Path;

class FileOrFolderWidget extends StatelessWidget {
  final String onClickPath;
  final Function(String path) onClick;
  const FileOrFolderWidget({
    super.key,
    required this.onClickPath,
    required this.onClick
   });

  @override
  Widget build(BuildContext context) {
    try {
      String isHiddenFile = Path.basename(onClickPath)[0] == '.' ? "  •  Hidden" : "";
      if (Directory(onClickPath).existsSync()) {
        var stat = Directory(onClickPath).statSync();
        return _FileFolderCard(
          onClick: onClick,
          onClickPath: onClickPath,
          color: Theme.of(context).colorScheme.primaryContainer,
          icon: Icons.folder_open,
          displayName: Path.basename(onClickPath),
          subtitle: "${Directory(onClickPath).listSync().length} Items  •  ${stat.modified}$isHiddenFile",
        );
      }
      else if (File(onClickPath).existsSync()) {
        var stat = File(onClickPath).statSync();
        return _FileFolderCard(
          onClick: onClick,
          onClickPath: onClickPath,
          color: Theme.of(context).colorScheme.secondaryContainer,
          icon: getIconByExtention(Path.extension(onClickPath)),
          displayName: Path.basenameWithoutExtension(onClickPath),
          subtitle: "${_fileSize(stat.size)} MB  •  ${Path.extension(onClickPath).substring(1)}  •  ${stat.modified}$isHiddenFile",
        );
      }
      return Container();
    } on Exception {
      return Container();
    } on RangeError {
      return Container();
    }
  }
}

int _fileSize(int size) {
  return (size / 1024 / 1024).round();
  // int temp = size;
  // while (true) {
  //   if ((temp / 1024 / 1024) > 0) {
  //     temp = (temp / 1024).round();
  //   } else {
  //     return temp;
  //   }
  // }
}

class _FileFolderCard extends StatelessWidget {
  final Function(String path) onClick;
  final String onClickPath;
  final Color color;
  final IconData icon;
  final String subtitle;
  final String displayName;

  const _FileFolderCard({
    required this.onClick,
    required this.onClickPath,
    required this.color,
    required this.icon, required this.subtitle, required this.displayName
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .symmetric(vertical: 5),
      padding: .symmetric(vertical: 1),
      child: ListTile(
        tileColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15)
        ),
        onTap: () => onClick(onClickPath),
        leading: Icon(
          icon,
          size: 36,
        ),
        title: Text(
          displayName,
          style: TextStyle(
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }
}