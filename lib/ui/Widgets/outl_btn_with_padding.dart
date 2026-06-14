
import 'package:flutter/material.dart';

class OutlineBtnWithPadding extends StatelessWidget {
  final String text;
  final Function onClick; 

  const OutlineBtnWithPadding({
    super.key, required this.text, required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:.only(bottom: 6),
      child: OutlinedButton(
        onPressed: () => onClick(),
        child: Text(text),
      ),
    );
  }
}