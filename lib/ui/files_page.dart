import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:gleamy_files/Structs/mb_file_sys_entity.dart';
import 'package:gleamy_files/ui/Popups/file_page_new_popup.dart';
import 'package:gleamy_files/ui/Popups/files_more_action.dart';
import 'package:gleamy_files/ui/Widgets/file_or_folder_card.dart';
import 'package:gleamy_files/ui/Widgets/scaffold_padding.dart';
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
        body: filesView(),
      ),
    );
  }

  Widget filesView() {
    return ScaffoldPadding(
      child: Stack(
        alignment: AlignmentGeometry.topCenter,
        children: [
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 4,
              mainAxisSpacing: 2,
              crossAxisSpacing: 5
            ),
            physics: BouncingScrollPhysics(),
            padding: .only(bottom: 350, top: 65),
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
          _CurrentPathHeader(
            perviousPaths: perviousPaths,
            backButton: backButton(),
            createButton: _fileFloatingBtn(context, perviousPaths.last),
          ),
        ],
      ),
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

  IconButton backButton() {
    return IconButton.filledTonal(
      tooltip: "Back",
      onPressed: () => backAction(),
      autofocus: true,
      icon: Icon(Icons.arrow_back),
    );
  }

  IconButton _fileFloatingBtn(BuildContext context, String lastPath) {
    return IconButton.filledTonal(
      icon: Icon(Icons.create_new_folder_outlined),
      tooltip: 'New...',
      onPressed: () { 
        showFilesPageNewDialog(lastPath, context, () {
          setState(() {
            updatePaths(perviousPaths.last);
          });
        },);
      },
    );
  }

}

class _CurrentPathHeader extends StatelessWidget {
  final IconButton backButton;
  final IconButton createButton; 
  const _CurrentPathHeader({
    required this.perviousPaths, required this.backButton, required this.createButton,
  });

  final List<String> perviousPaths;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(top: 5.5),
      child: Row(
        mainAxisAlignment: .center,
        spacing: 15,
        children: [
          backButton,
          Container(
            padding: .all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer.withAlpha(90),
              // backgroundBlendMode: .screen,
              borderRadius: .circular(20),
              border: .all(
                width: 2,
                color: Colors.white,
              ),
            ),
            child: Text(
              perviousPaths.last,
              textAlign: .center,
              maxLines: 2,
              overflow: .ellipsis,
              style: TextStyle(
                fontSize: 12
              ),
            )
          ).frosted(
            blur: 2,
            borderRadius: .circular(20),
          ),
          createButton,
        ],
      ),
    );
  }
}
