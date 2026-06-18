import 'package:flutter/material.dart';
import 'package:gleamy_files/Structs/mb_file_sys_entity.dart';
import 'package:gleamy_files/ui/Popups/files_more_action.dart';

class FileDetailsPanel extends StatelessWidget {
  const FileDetailsPanel({super.key, required this.mbFSE});
  final MBFileSysEntity mbFSE;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth > 700) {
      // bool isFile = fileFolder.isFile;
      String size = ""; String modified = ""; String accessed = "";

      var m = mbFSE.dateModified;
      var a = mbFSE.dateAccessed;
      size = "Size: ${mbFSE.sizeBytes} Bytes";
      modified = "Modified: ${m.day}/${m.month}/${m.year}";
      accessed = "Accessed: ${a.day}/${a.month}/${a.year}";

      return SelectionArea(
        child: Container(
          width: 240 + (screenWidth / 10),
          padding: .all(15),
          decoration: BoxDecoration(
            borderRadius: .only(topRight: .circular(25), bottomRight: .circular(25)),
            color: Theme.of(context).colorScheme.surfaceContainerLowest
          ),
          child: mbFSE.path.isNotEmpty ? Column(
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
                  mbFSE.icon,
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
              Text(mbFSE.path),
              ElevatedButton(
                child: Text("More Actions"),
                onPressed: () => showFileOrFolderMoreActionDialog(
                  mbFSE.path, context, () {},
                ),
              ),
            ],
          ) : null,
        ),
      );
    }
    return SizedBox();
  }
}