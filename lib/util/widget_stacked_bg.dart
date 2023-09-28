import 'package:flutter/material.dart';

class StackedBG extends StatelessWidget {
  final Widget? child;
  final String? image;
  StackedBG({this.child, this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        image!,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
      Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white.withOpacity(0.7),
      ),
      Align(alignment: Alignment.center, child: child)
    ]);
  }
}
