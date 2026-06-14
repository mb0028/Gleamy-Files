import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:path/path.dart' as Path;

IconData getIconByExtention(String exten){
  switch (exten) {
    case ".png" || ".jpg" || ".jpeg" || ".webp": return Icons.photo_outlined;
    case ".mp4" || ".mkv": return Icons.video_file_outlined;
    case ".mp3" || ".m4a" || ".flac" || ".wav" || ".ogg" || ".aac": return Icons.music_note_outlined;
    case ".txt": return Icons.text_snippet_outlined;
    case ".lrc" || ".srt": return Icons.subtitles_outlined;
    case ".py" || ".cs" || ".dart" || ".c" || ".h" || ".cpp" || ".java" || ".kt": return Icons.code;
    case ".md": return Icons.arrow_circle_down_rounded;
    case ".js": return Icons.javascript_rounded;
    case ".json": return Icons.data_object_rounded;
    case ".zip" || ".rar" || ".7z" || ".tar" || ".tar.gz": return Icons.folder_zip_outlined;
    case ".html" || ".html" || ".mhtml": return Icons.html_rounded;
    case ".css": return Icons.palette_outlined;
    case ".lnk": return Icons.link;
    case ".exe": return Icons.window_rounded;
    case ".dll": return Icons.dynamic_form;
    case ".pdf": return Icons.menu_book_rounded;
    case ".docx" || ".pptx" || ".xls" || ".sdocx": return Icons.my_library_books_outlined;
    case ".xml" || ".xaml" || ".csproj" || ".slnx": return Icons.extension_rounded;
    case ".gif": return Icons.gif_outlined;
  }
  return Icons.insert_drive_file_outlined;
}

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
                    showToast("Renamed ${Path.basename(path)} to ${ctrlr.text}", context: context);
                  } on Exception catch (e) {
                    showToast("Failed to rename file. Error:\n$e", context: context);
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

Future deleteFileDialoge(BuildContext context, String path) async {
  var file = File(path);
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
                    await file.delete();
                    showToast("Deleted ${Path.basename(path)}", context: context);
                  } on Exception catch (e) {
                    showToast("Failed to delete file. Error:\n$e", context: context);
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
                  showToast("Moved to ${ctrlr.text}", context: context);
                } else {
                  await file.copy(ctrlr.text);
                  showToast("Copied to ${ctrlr.text}", context: context);
                }
              } on Exception catch (e) {
                String copyOrMove = move ? "Move" : "Copy";
                showToast("Failed to $copyOrMove file. Error:\n$e", context: context);
              }
            },
            label: Text(move ? "move" : "copy")
          ),
        ],
      ),
    ),
  ));
}