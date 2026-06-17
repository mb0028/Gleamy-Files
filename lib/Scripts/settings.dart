// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as Path;

class Settings {
  List<String> favoritePaths = [];
  int favoriteSorting = 0; // 0: By name | 

  File settingsFile = File(savePath);
  Settings();

  static const String _nl = "\n";
  static const String _favoritePathsID = "[FAVORITE]";
  static const String _favoriteSortingID = "[FAVORITE_SORTING]";
  static String savePath = Platform.isAndroid ? "/sdcard/Android/Data/mb28.GleamyFiles/files/Settings.txt"
  : "E:/_ST/Settings.txt"; // TODO: this is temporary and needs to change

  void loadSettings() {
    Directory(Path.dirname(savePath)).create(recursive: true);
    // ------------------------------------ Load
    if (settingsFile.existsSync()) {
      LineSplitter splitter = LineSplitter();
      var settin = settingsFile.readAsStringSync();
      var lines = splitter.convert(settin);

      for (var i = 0; i < lines.length; i++) {
        if (lines[i].startsWith(_favoritePathsID))
          favoritePaths.add(lines[i].split(_favoritePathsID)[1]);
        if (lines[i].startsWith(_favoriteSortingID))
          favoriteSorting = int.parse(lines[i].split(_favoriteSortingID)[1]);
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
    for (var i = 0; i < favoritePaths.length; i++)
      result += _favoritePathsID + favoritePaths[i] + _nl;
    result += _favoriteSortingID + favoriteSorting.toString() + _nl;

    settingsFile.writeAsStringSync(result);
  }
}