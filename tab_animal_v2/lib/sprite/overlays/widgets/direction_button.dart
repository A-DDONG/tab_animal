import 'package:flutter/material.dart';

class DirectionButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  const DirectionButton(
      {super.key, required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: IconButton(
        icon: Icon(iconData),
        iconSize: 20,
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}
