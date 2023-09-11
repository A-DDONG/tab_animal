import 'package:flutter/material.dart';
import 'package:tab_animal/game/walking_game.dart';

import 'button_overlay.dart';

class OverlayController extends StatelessWidget {
  final WalkingGame game;
  const OverlayController({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [ButtonOverlay(game: game)])
    ]);
  }
}
