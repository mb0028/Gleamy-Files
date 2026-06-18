import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gleamy_files/main.dart';

void showSettingsPopup(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationName: Platform.packageConfig,
    applicationLegalese: "Developer: @mb_0028",
    children: [
      SizedBox(height: 10,),
      Column(
        spacing: 5,
        children: [
          Text(
            "App Theme:",
            style: TextStyle(
              fontSize: 18
            ),
          ),
          _ThemeSegmentBtn(),
          Text(
            "Color | Brightness\nRestart app to apply settings",
            textAlign: .center,
            style: TextStyle(
              fontSize: 10
            ),
          ),
        ],
      ),
    ],
  );
}

class SettingsPopupButton extends StatefulWidget {
  const SettingsPopupButton({super.key});

  @override
  State<SettingsPopupButton> createState() => _SettingsPopupButtonState();
}

class _SettingsPopupButtonState extends State<SettingsPopupButton> {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showSettingsPopup(context),
      icon: Icon(Icons.settings)
    );
  }
}

enum _Theme { system, systemDark, gleamy }
class _ThemeSegmentBtn extends StatefulWidget {
  @override
  State<_ThemeSegmentBtn> createState() => _ThemeSegmentBtnState();
}

class _ThemeSegmentBtnState extends State<_ThemeSegmentBtn> {
  static _Theme theme = .gleamy;

  @override
  void initState() {
     theme = switch (appSettings.appTheme) {
      0 =>  .gleamy,
      1 => .system,
      2 => .systemDark,
      int() => throw UnimplementedError(),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<_Theme>(
      selectedIcon: Icon(Icons.palette_rounded),
      segments: const <ButtonSegment<_Theme>>[
        ButtonSegment<_Theme>(
          value: _Theme.gleamy,
          label: Text('Gleamy Adaptive'),
          icon: Icon(Icons.sunny_snowing),
        ),
        ButtonSegment<_Theme>(
          value: _Theme.system,
          label: Text('System Adaptive'),
          icon: Icon(Icons.light_mode_rounded),
        ),
        ButtonSegment<_Theme>(
          value: _Theme.systemDark,
          label: Text('System Dark'),
          icon: Icon(Icons.dark_mode_rounded),
        ),
      ],
      selected: <_Theme>{theme},
      onSelectionChanged: (Set<_Theme> newSelection) {
        setState(() {
          theme = newSelection.first;
          appSettings.appTheme = switch (theme) {
            .gleamy => 0, .system => 1, .systemDark => 2,
          };
          appSettings.saveSettings();
        });
      },
    );
  }
}
