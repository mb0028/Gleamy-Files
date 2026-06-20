import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

class MBFileSysEntity {
  final String path;

  FileSystemEntity get _inner => isFile ? File(path) : Directory(path);
  FileStat get _stat => _inner.statSync();
 
  bool get isFile => FileSystemEntity.isFileSync(path);
  String get name => isFile ? Path.basename(path) : Path.dirname(path);
  /// extns: Extension
  String get nameCutExtns => isFile ? Path.basenameWithoutExtension(path) : Path.dirname(path);
  /// extns: Extension
  String get extns => isFile ? Path.extension(path) : "";
  DateTime get dateModified => _stat.modified;
  DateTime get dateAccessed => _stat.accessed;
  int get sizeBytes => _stat.size;

  IconData get icon {
    switch (extns) {
      case ".png" || ".jpg" || ".jpeg" || ".webp": return Icons.photo_outlined;
      case ".mp4" || ".mkv": return Icons.video_file_outlined;
      case ".mp3" || ".m4a" || ".flac" || ".wav" || ".ogg" || ".aac" || ".m3u": return Icons.music_note_outlined;
      case ".gif": return Icons.gif_outlined;
      case ".txt": return Icons.text_snippet_outlined;
      case ".lrc" || ".srt": return Icons.subtitles_outlined;
      case ".md": return Icons.style_rounded;
      case ".py" || ".cs" || ".dart" || ".c" || ".h" || ".cpp" || ".java" || ".kt": return Icons.code;
      case ".js": return Icons.javascript_rounded;
      case ".json": return Icons.data_object_rounded;
      case ".zip" || ".rar" || ".7z" || ".tar" || ".tar.gz": return Icons.folder_zip_outlined;
      case ".html" || ".htm" || ".mhtml" || ".url": return Icons.language_rounded;
      case ".css": return Icons.palette_outlined;
      case ".lnk": return Icons.link;
      case ".apk" || ".aab" || ".xapk" || ".apks" || ".apk+": return Icons.apps_rounded;
      case ".exe": return Icons.window_rounded;
      case ".dll" || ".jar" || ".obb" || ".so": return Icons.dynamic_form;
      case ".reg": return Icons.app_registration_outlined;
      case ".bat": return Icons.terminal_rounded;
      case ".pdf": return Icons.menu_book_rounded;
      case ".docx" || ".pptx" || ".xls" || ".sdocx": return Icons.sticky_note_2_outlined;
      case ".xml" || ".xaml" || ".csproj" || ".slnx": return Icons.extension_rounded;
      case ".ust" || ".ustx" || ".vsqx" || ".svp" || ".midi" || ".mid" || ".flp" || ".flm": return Icons.piano_rounded;
      case ".ttf" || ".otf": return Icons.font_download_outlined;
      case "": return Icons.folder_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }

  MBFileSysEntity(this.path);
}
