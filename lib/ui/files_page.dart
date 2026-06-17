import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:gleamy_files/Structs/mb_file_sys_entity.dart';
import 'package:gleamy_files/ui/Popups/file_page_new_popup.dart';
import 'package:gleamy_files/ui/Popups/files_more_action.dart';
import 'package:gleamy_files/ui/Widgets/file_details_panel.dart';
import 'package:gleamy_files/ui/Widgets/file_or_folder_card.dart';
import 'package:gleamy_files/ui/Widgets/scaffold_padding.dart';
import 'package:gleamy_files/ui/Popups/settings_popup.dart';
import 'package:open_filex/open_filex.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key, required this.title, required this.startPath});
  final String title;
  final String startPath;

  @override
  State<FilesPage> createState() => _FilesPageState(startPath: startPath);
}

class _FilesPageState extends State<FilesPage> {  
  final String startPath;
  List<MBFileSysEntity> currentFiles = [];
  List<String> perviousPaths = [];
  String selectedPath = "";
  _FilesPageState({required this.startPath});

  void updatePaths(String path) {
    var dir = Directory.fromUri(Uri.file(path));
    Future.delayed(Duration.zero, () {
      List<String> dirs = [];
      List<String> files = [];
      List<MBFileSysEntity> result = [];

      // Sort pass 0 : init lists
      for (var element in dir.listSync()) {
        if (FileSystemEntity.isDirectorySync(element.path))
          dirs.add(element.path);
        else
          files.add(element.path);
      }

      // Sort pass 1 : by name      TODO: More sorting methods
      dirs.sort();
      files.sort();

      // Sort pass 2 : folders first
      for (var item in dirs)
        result.add(MBFileSysEntity(item));
      for (var item in files)
        result.add(MBFileSysEntity(item));

      setState(() => currentFiles = result);
    });
  }

  void openFileOrFolder(String path) {
    if (FileSystemEntity.isFileSync(path)) {
      OpenFilex.open(path);
    } else {
      updatePaths(path);
      perviousPaths.add(path);
    }
  }

  @override
  void initState() {
    super.initState();
    updatePaths(startPath);
    perviousPaths.add(startPath);
  }

  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: perviousPaths.length <= 1,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop == false) {
          backAction();
        }
      },
      child: Scaffold(
        appBar: filesPageAppBar(context),
        body: Row(
          mainAxisSize: .min,
          children: [
            FileDetailsPanel(mbFSE: MBFileSysEntity(selectedPath)),
            filesView(),
          ],
        ),
        floatingActionButton: _fileFloatingBtn(context, perviousPaths.last),
      ),
    );
  }

  Widget filesView() {
    return Expanded(
      child: ScaffoldPadding(
        child: Stack(
          alignment: AlignmentGeometry.topCenter,
          children: [
            ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: .only(bottom: 350, top: 50),
              itemCount: currentFiles.length,
              itemBuilder: (context, i) => FileOrFolderCardWidget(
                filePath: currentFiles[i].path,
                onClick: (s) => openFileOrFolder(s),
                onLongPress: (s) => showFileOrFolderMoreActionDialog(s, context, () {
                  updatePaths(perviousPaths.last);
                }),
                onFocusChange: _onFileFocusChanges,
              ),
            ),
            _CurrentPathHeader(perviousPaths: perviousPaths),
          ],
        ),
      ),
    );
  }

  AppBar filesPageAppBar(BuildContext context) {
    return AppBar(
      surfaceTintColor: Theme.of(context).colorScheme.tertiaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        widget.title,
        style: TextStyle(
          fontWeight: .bold,
        ),
      ),
      centerTitle: true,
      leading: backButton(),
      actionsPadding: EdgeInsets.only(right: 8),
      actions: [
        SettingsPopupButton()
      ],
    );
  }

  IconButton? backButton() {
    return IconButton(
      tooltip: "Back",
      onPressed: () => backAction(),
      icon: Icon(Icons.arrow_back),
    );
  }

  void backAction() {
    perviousPaths.removeLast();
    if (perviousPaths.lastOrNull == null) {
      Navigator.of(context).pop();
      return;
    }
    updatePaths(perviousPaths.last);
  }

  void _onFileFocusChanges(bool value, String path) {
    if (value) {
      setState(() {
        selectedPath = path;
      });
    }
  }

  Widget _fileFloatingBtn(BuildContext context, String lastPath) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      onPressed: () { 
        showFilesPageNewDialog(lastPath, context, () {
          setState(() {
            updatePaths(perviousPaths.last);
          });
        },);
      },
      tooltip: 'New...',
      child: const Icon(Icons.add),
    );
  }

}

class _CurrentPathHeader extends StatelessWidget {
  const _CurrentPathHeader({
    required this.perviousPaths,
  });

  final List<String> perviousPaths;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(top: 5.5),
      child: Container(
        height: 90,
        padding: .all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer.withAlpha(90),
          // backgroundBlendMode: .screen,
          borderRadius: .circular(20),
          border: .all(
            width: 2,
            color: Colors.white,
          ),
        ),
        child: Column(
          mainAxisAlignment: .spaceEvenly,
          children: [
            Text(
              perviousPaths.last,
              textAlign: .center,
              maxLines: 1,
              overflow: .ellipsis,
              style: TextStyle(
                fontSize: 12
              ),
            ),
            Chip(
              label: Text("heheheh"),
              onDeleted: () => showAboutDialog(context: context),
            ),
          ],
        )
      ).frosted(
        blur: 2,
        borderRadius: .circular(20),
      ),
    );
  }
}
