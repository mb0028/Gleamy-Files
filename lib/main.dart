import 'package:flutter/material.dart';
import 'package:gleamy_files/Scripts/settings.dart';
import 'package:gleamy_files/ui/home_page.dart';
import 'package:system_theme/system_theme.dart';

const Color gleamyAppsDefaultSeedColor = Color.fromARGB(255, 255, 197, 82);
Settings appSettings = Settings();

void main() async {
  await appSettings.loadSettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gleamy Files',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: switch (appSettings.appTheme) {
            0 => gleamyAppsDefaultSeedColor,
            1 => SystemTheme.accentColor.darker,
            2 => SystemTheme.accentColor.accent,
            int() => throw UnimplementedError(),
          }, // SystemTheme.accentColor.accent,
          dynamicSchemeVariant: .rainbow,
          brightness: appSettings.appTheme == 2 ? .dark : MediaQuery.platformBrightnessOf(context)
        ),
      ),
      home: const HomePage(),
    );
  }
}
