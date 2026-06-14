import 'package:flutter/material.dart';
import 'package:gleamy_files/ui/home_page.dart';

void main() {
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
          seedColor: gleamyAppsDefaultSeedColor, // SystemTheme.accentColor.accent,
          dynamicSchemeVariant: .rainbow,
          brightness: MediaQuery.platformBrightnessOf(context)
        ),
      ),
      home: const HomePage(),
    );
  }
}


const Color gleamyAppsDefaultSeedColor = Color.fromARGB(255, 255, 197, 82);