import 'package:flutter/material.dart';

class RectangleArea extends StatelessWidget {
  const RectangleArea({
    super.key,
    required this.label,
    required this.size,
    required this.color,
  });

  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color),
      child: Center(child: Text(label, textAlign: TextAlign.center)),
    );
  }
}
