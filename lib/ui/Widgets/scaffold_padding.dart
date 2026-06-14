
import 'package:flutter/material.dart';

const double _scaffoldPadding = 10;

class ScaffoldPadding extends StatelessWidget {
  final Widget child;
  const ScaffoldPadding({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Padding(
    padding: .symmetric( horizontal: _scaffoldPadding), 
    child: child,
  );
}