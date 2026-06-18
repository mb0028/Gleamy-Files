import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gleamy_files/Structs/mb_file_sys_entity.dart';
import 'package:gleamy_files/main.dart';
import 'package:gleamy_files/ui/Popups/files_more_action.dart';
import 'package:gleamy_files/ui/Widgets/file_or_folder_card.dart';
import 'package:gleamy_files/ui/Widgets/navigation_bars.dart';
import 'package:gleamy_files/ui/Widgets/scaffold_padding.dart';
import 'package:gleamy_files/ui/files_page.dart';
import 'package:open_filex/open_filex.dart';
import 'package:storage_space/storage_space.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          HomePageNavigationRail(
            onchange: (value) {
              setState(() {
                pageIndex = value;
              });
            },
          ),
          Expanded(
            child: ScaffoldPadding(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(height: 100),
                  Text(
                    pageIndex == 0 ? "Gleamy Files" : "Favorites",
                    textAlign: .center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 30,
                      fontWeight: .bold
                    ),
                  ),
                  SizedBox(height: 50),
                  pageIndex == 0 ? _HomeMainDirs() : _HomeFavorites(),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////

class _HomeMainDirs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Platform.isAndroid ? _DirSpace(path:  "/sdcard") : _Dir(path: "C:/"),
            _Dir(path: Platform.isAndroid ? "/sdcard/Download" : "D:/"),
            _Dir(path: Platform.isAndroid ? " " : "E:/"),
          ],
        ),
        Divider(height: 10),
        Column(
          children: [
            _Dir(path: Platform.isAndroid ? "/sdcard/DCIM" : " "),
            _Dir(path: Platform.isAndroid ? "/sdcard/Pictures" : " "),
            _Dir(path: Platform.isAndroid ? "/sdcard/Movies" : " "),
            _Dir(path: Platform.isAndroid ? "/sdcard/Music" : " "),
          ],
        ),
      ],
    );
  }
}


class _HomeFavorites extends StatefulWidget {

  @override
  State<_HomeFavorites> createState() => _HomeFavoritesState();
}

class _HomeFavoritesState extends State<_HomeFavorites> {
  @override
  Widget build(BuildContext context) {
    appSettings.favoritePaths.sort((a, b) {
      return FileSystemEntity.isDirectorySync(a) ? 0 : 1;
    }); //TODO: More sorting methods
    return SizedBox(
      height: 500,
      child: ListView.builder(
        itemCount: appSettings.favoritePaths.length,
        itemBuilder: (context, index) => _Dir(
          path: appSettings.favoritePaths[index],
          onDialogPop: () => setState(() {}),
        ),
      ),
    );
  }
}

///////////////////////////////////

class _Dir extends StatelessWidget {
  final String path;
  final Function? onDialogPop;
  const _Dir({ required this.path, this.onDialogPop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: FileOrFolderCardWidget(
        filePath: path,
        onClick: (path) => FileSystemEntity.isDirectorySync(path)
          ? _openDir(path, context)
          : OpenFilex.open(path),
          onLongPress: (path) => showFileOrFolderMoreActionDialog(path, context, () {
            if (onDialogPop != null) { onDialogPop!(); }
          },
        ),
        onFocusChange: (isFocused, path) {},
      ),
    );
  }
}

class _DirSpace extends StatefulWidget {
  final String path;
  const _DirSpace({required this.path});

  @override
  State<_DirSpace> createState() => _DirSpaceState();
}

class _DirSpaceState extends State<_DirSpace> {
  StorageSpace? _space;

  void initStorageSpace() async {
    StorageSpace storageSpace = await getStorageSpace(
      lowOnSpaceThreshold: 2 * 1024 * 1024 * 1024, // 2GB
      fractionDigits: 1,
    );
    setState(() {
      _space = storageSpace;
    });
  }

  @override
  void initState() {
    super.initState();
    initStorageSpace();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(
        children: [
          FileOrFolderCardWidget(
            filePath: widget.path,
            onClick: (path) => MBFileSysEntity(path).isFile
              ? OpenFilex.open(path)
              : _openDir(path, context),
              onLongPress: (path) => showFileOrFolderMoreActionDialog(path, context, () { },
            ),
            onFocusChange: (isFocused, path) {},
          ),
          LinearProgressIndicator(
            value:  _space?.usageValue,
          ),
        ], 
      ),
    );
  }
}

void _openDir(String path, BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => 
    FilesPage(
      title: 'Gleamy Files',
      startPath: path
    ),
  ));
}