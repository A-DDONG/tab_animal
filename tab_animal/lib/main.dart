import 'package:flutter/material.dart';
import 'package:tab_animal/game/title_splash.dart';

void main() {
  runApp(const TabAnimalApp());
}

class TabAnimalApp extends StatelessWidget {
  const TabAnimalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "터치해서 동물 키우기",
      home: TitleSplash(),
    );
  }
}
