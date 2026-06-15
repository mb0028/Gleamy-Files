// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as Path;

class Settings {
  List<String> favoritePaths = [];

  File settingsFile = File(savePath);
  Settings();

  static const String nextLine = "\n";
  static const String favoritePathsID = "[|--FAVORITE--|]";
  static String savePath = Platform.isAndroid ? "/sdcard/Android/Data/mb28.GleamyFiles/files/Settings.gfd"
  : "E:/_ST/Settings.gfd"; // gfd = gleamy files data      TODO: this is temporary and needs to change

  void loadSettings() {
    Directory(Path.dirname(savePath)).create(recursive: true);
    // ------------------------------------ Load
    if (settingsFile.existsSync()) {
      LineSplitter splitter = LineSplitter();
      var settin = settingsFile.readAsStringSync();
      var lines = splitter.convert(settin);

      for (var i = 0; i < lines.length; i++) {
        if (lines[i].startsWith(favoritePathsID))
          favoritePaths.add(lines[i].split(favoritePathsID)[1]);
      }
    }
    // ------------------------------------ Save new
    else {
      settingsFile.createSync(recursive: true);
      saveSettings();
    }
  }

  void saveSettings() {
    String result = "";
    for (var i = 0; i < favoritePaths.length; i++) {
      result += favoritePathsID + favoritePaths[i] + nextLine;
    }

    settingsFile.writeAsStringSync(result);
  }
}