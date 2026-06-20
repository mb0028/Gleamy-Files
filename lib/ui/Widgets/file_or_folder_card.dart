import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gleamy_files/Structs/mb_file_sys_entity.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as Path;

class FileOrFolderCardWidget extends StatelessWidget {
  final String filePath;
  final Function(String path) onClick;
  final Function(String path) onLongPress;
  final Function(bool isFocused, String path) onFocusChange;
  const FileOrFolderCardWidget({
    super.key, required this.filePath, required this.onClick,
    required this.onFocusChange, required this.onLongPress
   });

  @override
  Widget build(BuildContext context) {
    try {
      String isHiddenFile = Path.basename(filePath)[0] == '.' ? "  •  Hidden" : "";
      if (Directory(filePath).existsSync()) {
        var stat = Directory(filePath).statSync();
        var m = stat.modified;
        return _FileFolderCard(
          onClick: onClick,
          onLongPress: onLongPress,
          onFucusChange: onFocusChange,
          filePath: filePath,
          color: Theme.of(context).colorScheme.primaryContainer,
          icon: Icons.folder_outlined,
          displayName: Path.basename(filePath),
          subtitle: "${Directory(filePath).listSync().length} Items  •  ${m.day}/${m.month}/${m.year}$isHiddenFile",
        );
      }
      else if (File(filePath).existsSync()) {
        var stat = File(filePath).statSync();
        var m = stat.modified;
        return _FileFolderCard(
          onClick: (path) => OpenFilex.open(path),
          onLongPress: onLongPress,
          onFucusChange: onFocusChange,
          filePath: filePath,
          color: Theme.of(context).colorScheme.secondaryContainer,
          icon: MBFileSysEntity(filePath).icon,
          displayName: Path.basenameWithoutExtension(filePath),
          subtitle: "${_fileSize(stat.size)} MB  •  ${m.day}/${m.month}/${m.year}  •  ${Path.extension(filePath).substring(1)}$isHiddenFile",
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
  final Function(String path) onLongPress;
  final Function(bool isFocused, String path) onFucusChange;
  final String filePath;
  final Color color;
  final IconData icon;
  final String subtitle;
  final String displayName;

  const _FileFolderCard({
    required this.onClick, required this.filePath, required this.color, required this.icon,
    required this.subtitle, required this.displayName, required this.onFucusChange, required this.onLongPress
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(vertical: 1),
      child: Row(
        spacing: 2,
        children: [
          Expanded(
            flex: 7,
            child: ListTile(
              tileColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(15)
              ),
              onTap: () => onClick(filePath),
              onLongPress: () => onLongPress(filePath),
              leading: Icon(
                icon,
                size: 36,
              ),
              title: Text(
                displayName,
                maxLines: 1,
                style: TextStyle(
                ),
              ),
              subtitle: Text(
                subtitle,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: .circular(15)
              ),
              child: IconButton(
                icon: Icon(Icons.more_horiz_rounded),
                onPressed: () => onLongPress(filePath),
              ),
            )
          )
        ],
      ),
    );
  }
}