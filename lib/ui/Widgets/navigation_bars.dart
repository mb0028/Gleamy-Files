import 'package:flutter/material.dart';
import 'package:gleamy_files/ui/Popups/settings_popup.dart';

class HomePageNavigationRail extends StatefulWidget {
  const HomePageNavigationRail({super.key, required this.onchange});
  final Function(dynamic pageIndex) onchange;

  @override
  State<HomePageNavigationRail> createState() => _HomePageNavigationRailState(onchange: onchange);
}

class _HomePageNavigationRailState extends State<HomePageNavigationRail> {
  int selectedPage = 0;
  final Function(dynamic pageIndex) onchange;

  _HomePageNavigationRailState({required this.onchange});

  @override
  Widget build(BuildContext context) {
    bool expanded = MediaQuery.sizeOf(context).width > 700; 
    return NavigationRail(
      selectedIndex: selectedPage,
      extended: expanded,
      labelType: expanded ? .none : .all,
      selectedLabelTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: .bold,
      ),
      onDestinationSelected: (value) {
        setState(() {
          selectedPage = value;
          onchange(value);
        });
      },
      leading: SettingsPopupButton(),
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