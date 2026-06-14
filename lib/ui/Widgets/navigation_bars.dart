import 'package:flutter/material.dart';

class HomePageNavigationRail extends StatefulWidget {
  const HomePageNavigationRail({super.key});

  static int selected = 0;

  @override
  State<HomePageNavigationRail> createState() => _HomePageNavigationRailState();
}

class _HomePageNavigationRailState extends State<HomePageNavigationRail> {
  
  @override
  Widget build(BuildContext context) {
    bool expanded = MediaQuery.sizeOf(context).width > 700; 
    return NavigationRail(
      selectedIndex: HomePageNavigationRail.selected,
      extended: expanded,
      labelType: expanded ? .none : .all,
      selectedLabelTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: .bold,
      ),
      onDestinationSelected: (value) {
        setState(() {
          HomePageNavigationRail.selected = value;
        });
      },
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.snippet_folder_outlined),
          selectedIcon: Icon(Icons.snippet_folder_rounded),
          label: Text("Drives"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.favorite_border_rounded),
          selectedIcon: Icon(Icons.favorite_rounded),
          label: Text("Favorites"),
        ),
      ],
    );
  }
}