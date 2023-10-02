import 'package:flutter/material.dart';

class ConstrainedView extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  const ConstrainedView(
      {super.key,
      required this.child,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < width || constraints.maxHeight < height) {
          return const SizedBox();
        }
        return child;
      },
    );
  }
}
