import 'dart:io';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:gleamy_files/ui/Popups/toast.dart';

void showFilesPageNewDialog(String currentDir, BuildContext context, Function onPop) {
  var ctrlr = TextEditingController();
  showDialog(context: context, builder: (context) => Dialog(
    child: Container(
      width: 500,
      height: 350,
      padding: .all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: .circular(25),
      ),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          _Header(),
          SizedBox(height: 15,),
          _TypeToCreate(),
          SizedBox(height: 10,),
          TextField(
            controller: ctrlr,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Enter file name...\n(put / to create sub-directories)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              )
            ),
          ),
          SizedBox(height: 10,),
          FilledButton.icon(
            label: Text("Create"),
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pop();
              try {
                switch (_TypeToCreateState.calendarView) {
                  case .file: File("$currentDir/${ctrlr.text}").createSync(recursive: true);
                  case .folder: Directory("$currentDir/${ctrlr.text}").createSync(recursive: true);
                }
                showStyledToast("Created: ${ctrlr.text}", context);
              } on Exception catch (e) {
                showStyledToast("Failed! error:\n$e", context, duration: 5);
              }
              onPop();
            },
          ),
          SizedBox(height: 10,),
          Text("Create new in: $currentDir"),
        ],
      ),
    ),
  ).frosted(blur: 4));
}


class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        SizedBox(width: 35, height: 35,),
        Text(
          "Create New",
          textAlign: .center,
          style: TextStyle(
            fontWeight: .bold,
            fontSize: 18
          ),
        ),
        IconButton.filled(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close_rounded)
        ),
      ],
    );
  }
}

enum _CreateNew { file, folder }

class _TypeToCreate extends StatefulWidget {
  @override
  State<_TypeToCreate> createState() => _TypeToCreateState();
}

class _TypeToCreateState extends State<_TypeToCreate> {
  static _CreateNew calendarView = .file;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<_CreateNew>(
      selectedIcon: Icon(Icons.check_circle_outline),
      segments: const <ButtonSegment<_CreateNew>>[
        ButtonSegment<_CreateNew>(
          value: _CreateNew.file,
          label: Text('File'),
          icon: Icon(Icons.insert_drive_file_outlined),
        ),
        ButtonSegment<_CreateNew>(
          value: _CreateNew.folder,
          label: Text('Folder'),
          icon: Icon(Icons.folder_outlined),
        ),
      ],
      selected: <_CreateNew>{calendarView},
      onSelectionChanged: (Set<_CreateNew> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          calendarView = newSelection.first;
        });
      },
    );
  }
}
