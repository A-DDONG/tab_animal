import 'package:flutter/material.dart';

class MainGame extends StatefulWidget {
  const MainGame({super.key});

  @override
  State<MainGame> createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("메인게임"),
    );
  }
}
