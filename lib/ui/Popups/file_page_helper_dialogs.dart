import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gleamy_files/ui/Popups/toast.dart';
import 'package:path/path.dart' as Path;

Future renameFileDialog(BuildContext context, String path) async {
  var file = File(path);
  var ctrlr = TextEditingController();
  ctrlr.text = Path.basename(file.path);
  await showDialog(context: context, builder: (context) => Dialog (
    child: Container(
      height: 160,
      width: 500,
      margin: .all(15),
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .spaceBetween,
        children: [
          TextField(
            controller: ctrlr,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "New file name...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              )
            ),
          ),
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              FilledButton.icon(
                icon: Icon(Icons.save),
                onPressed: () async {
                  try {
                    Navigator.of(context).pop();
                    await file.rename("${Path.dirname(path)}${Platform.pathSeparator}${ctrlr.text}");
                    showStyledToast("Renamed ${Path.basename(path)} to ${ctrlr.text}", context);
                  } on Exception catch (e) {
                    showStyledToast("Failed to rename file. Error:\n$e", context);
                  }
                },
                label: Text("Rename")
              ),
              OutlinedButton.icon(
                icon: Icon(Icons.cancel_outlined),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: Text("Cancel")
              ),
            ],
          ),
        ],
      ),
    ),
  ));
}

Future deleteFileDialoge(BuildContext context, String path, { bool isFolder = false }) async {
  var file = isFolder ? Directory(path) : File(path);
  await showDialog(context: context, builder: (context) => Dialog(
    child: Container(
      height: 140,
      width: 500,
      margin: .all(15),
      child: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text("Delete?"),
          Text(
            "Delete ${Path.basename(file.path)} ?",
            textAlign: .center,
            maxLines: 3,
          ),
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              FilledButton.icon(
                icon: Icon(Icons.delete_outlined),
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    await file.delete(recursive: true);
                    showStyledToast("Deleted ${Path.basename(path)}", context);
                  } on Exception catch (e) {
                    showStyledToast("Failed to delete file. Error:\n$e", context);
                  }
                },
                label: Text("Delete")
              ),
              OutlinedButton.icon(
                icon: Icon(Icons.cancel_outlined),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: Text("Cancel")
              ),
            ],
          ),
        ],
      ),
    ),
  ));
}

Future copyOrMoveDialoge(BuildContext context, String path, bool move) async {
  var file = File(path);
  var ctrlr = TextEditingController();
  ctrlr.text = file.path;
  await showDialog(context: context, builder: (context) => Dialog(
    child: Container(
      height: 180,
      width: 500,
      margin: .all(15),
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(move ? "Move To" : "Copy To", textAlign: .center,),
          TextField(
            controller: ctrlr,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: move ? "Move To" : "Copy To",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              )
            ),
          ),
          FilledButton.icon(
            icon: Icon(move ? Icons.drive_file_move_outlined : Icons.copy),
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                if (move) {
                  await file.rename(ctrlr.text);
                  showStyledToast("Moved to ${ctrlr.text}", context);
                } else {
                  await file.copy(ctrlr.text);
                  showStyledToast("Copied to ${ctrlr.text}", context);
                }
              } on Exception catch (e) {
                String copyOrMove = move ? "Move" : "Copy";
                showStyledToast("Failed to $copyOrMove file. Error:\n$e", context);
              }
            },
            label: Text(move ? "move" : "copy")
          ),
        ],
      ),
    ),
  ));
}