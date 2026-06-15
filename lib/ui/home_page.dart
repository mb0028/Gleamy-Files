import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gleamy_files/main.dart';
import 'package:gleamy_files/ui/Popups/files_more_action.dart';
import 'package:gleamy_files/ui/Widgets/file_or_folder_card.dart';
import 'package:gleamy_files/ui/Widgets/navigation_bars.dart';
import 'package:gleamy_files/ui/Widgets/scaffold_padding.dart';
import 'package:gleamy_files/ui/files_page.dart';
import 'package:open_filex/open_filex.dart';

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
                  Row(
                    children: [
                      Text(
                        pageIndex == 0 ? "Gleamy Files" : "Favorites",
                        textAlign: .center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 30,
                          fontWeight: .bold
                        ),
                      ),
                    ],
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
            _Dir(path: Platform.isAndroid ? "/sdcard" : "C:/"),
            _Dir(path: Platform.isAndroid ? " " : "D:/"),
            _Dir(path: Platform.isAndroid ? "/sdcard/Download" : "E:/"),
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
          onLongPress: (path) => showFileOrFolderMoreActionDialog(path, context, () => onDialogPop!(),),
        onFocusChange: (isFocused, path) {},
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