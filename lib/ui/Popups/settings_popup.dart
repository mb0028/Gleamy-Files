import 'dart:io';
import 'package:flutter/material.dart';

void showSettingsPopup(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationName: Platform.packageConfig,
    applicationLegalese: "Developer: @mb_0028",
    children: [
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