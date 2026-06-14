import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gleamy_files/ui/Widgets/file_or_folder.dart';
import 'package:gleamy_files/ui/Widgets/navigation_bars.dart';
import 'package:gleamy_files/ui/Widgets/scaffold_padding.dart';
import 'package:gleamy_files/ui/files_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          HomePageNavigationRail(),
          Expanded(
            child: ScaffoldPadding(
              child: HomePageNavigationRail.selected == 0 ? ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(height: 100,),
                  Text(
                    "Gleamy Files",
                    textAlign: .center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 32,
                      fontWeight: .bold
                    ),
                  ),
                  _HomeMainDirs(),
                  SizedBox(height: 100,),
                ],
              ) : ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(height: 100,),
                  Text(
                    "Favorites",
                    textAlign: .center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 32,
                      fontWeight: .bold
                    ),
                  ),
                  _HomeFavorites(),
                  SizedBox(height: 100,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeMainDirs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      elevation: 0,
      child: Column(
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
      ),
    );
  }
}

class _HomeFavorites extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _Dir extends StatelessWidget {
  final String path;
  const _Dir({ required this.path });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: FileOrFolderWidget(
        onClickPath: path,
        onClick: (path) => _openDir(path, context),
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