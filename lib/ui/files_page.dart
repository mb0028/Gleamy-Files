
import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:gleamy_files/Scripts/file_helper.dart';
import 'package:gleamy_files/ui/Widgets/file_details_panel.dart';
import 'package:gleamy_files/ui/Widgets/outl_btn_with_padding.dart';
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
  List<FileSystemEntity> currentFiles = [];
  List<String> perviousPaths = [];
  String selectedPath = "";
  _FilesPageState({required this.startPath});

  void updatePaths(String path) {
    var dir = Directory.fromUri(Uri.file(path));
    Future.delayed(Duration.zero, () {
      setState(() => currentFiles = dir.listSync().toList());
    });
  }

  void openFileOrFolder(String path) {
    if (FileSystemEntity.isFileSync(path)) {
      showDialog(context: context, builder:(context) {
        return Dialog(
          child: fileClickedPopup(path) 
        );
      });
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
            FileDetailsPanel(path: selectedPath),
            filesView(),
          ],
        ),
        floatingActionButton: _FileFloatingBtn(),
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
        SettingsPopup()
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

  Widget fileClickedPopup(String path) {
    return Container(
      width: 500,
      padding: .all(15),
      height: 260,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          OutlineBtnWithPadding(
            text: "Open",
            onClick: () async {
              Navigator.of(context).pop();
              await OpenFilex.open(path);
            },
          ),
          OutlineBtnWithPadding(
            text: "Rename",
            onClick: () async {
              Navigator.of(context).pop();
              await renameFileDialog(context, path);
              updatePaths(perviousPaths.last);
            }
          ),
          OutlineBtnWithPadding(
            text: "Delete",
            onClick: () async {
              Navigator.of(context).pop();
              await deleteFileDialoge(context, path);
              updatePaths(perviousPaths.last);
            },
          ),
          Row(
            spacing: 6,
            children: [
              Expanded(
                child: OutlineBtnWithPadding(
                  text: "Copy",
                  onClick: () async {
                    Navigator.of(context).pop();
                    await copyOrMoveDialoge(context, path, false);
                    updatePaths(perviousPaths.last);
                  },
                ),
              ),
              Expanded(
                child: OutlineBtnWithPadding(
                  text: "Move",
                  onClick: () async {
                    Navigator.of(context).pop();
                    await copyOrMoveDialoge(context, path, true);
                    updatePaths(perviousPaths.last);
                  },
                ),
              ),
            ],
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
        padding: .all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer.withAlpha(80),
          // backgroundBlendMode: .screen,
          borderRadius: .circular(15),
          border: .all(
            width: 2,
            color: Colors.white,
          ),
        ),
        child: Text(
          perviousPaths.last,
          textAlign: .center,
          maxLines: 1,
          overflow: .ellipsis,
          style: TextStyle(
            fontSize: 12
          ),
        )
      ).frosted(
        blur: 2,
        borderRadius: .circular(15),
      ),
    );
  }
}

class _FileFloatingBtn extends StatelessWidget {
  const _FileFloatingBtn();
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      onPressed: () {},
      tooltip: 'New...',
      child: const Icon(Icons.add),
    );
  }
}