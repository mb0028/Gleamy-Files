import 'dart:io';
import 'package:flutter/material.dart';

class SettingsPopup extends StatefulWidget {
  const SettingsPopup({super.key});

  @override
  State<SettingsPopup> createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showAboutDialog(
        context: context,
        applicationName: Platform.packageConfig,
        applicationLegalese: "Developer: @mb_0028",
        children: [
        ],
      ),
      icon: Icon(Icons.settings)
    );
  }
}