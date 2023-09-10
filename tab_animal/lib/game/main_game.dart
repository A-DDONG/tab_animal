import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_animal/provider/bgm_provider.dart';

class MainGame extends StatefulWidget {
  const MainGame({super.key});

  @override
  State<MainGame> createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> {
  Sprite? menuSprite;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<BgmProvider>(context, listen: false).stopBgm();
      _loadSprites();
    });
  }

  void _loadSprites() async {
    final image = await Flame.images.load('ui_sprite.png'); // 이미지 로드
    setState(() {
      menuSprite =
          Sprite(image, srcPosition: Vector2(0, 0), srcSize: Vector2(40, 40));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              "assets/images/main_ui_background.png",
              fit: BoxFit.fill,
            ),
          ),
          if (menuSprite != null)
            Positioned(
              left: 20, // 원하는 x 좌표
              top: 60, // 원하는 y 좌표
              child: CustomPaint(
                size: const Size(60, 60),
                painter: SpritePainter(menuSprite!),
              ),
            ),
        ],
      ),
    );
  }
}

class SpritePainter extends CustomPainter {
  final Sprite sprite;

  SpritePainter(this.sprite);

  @override
  void paint(Canvas canvas, Size size) {
    sprite.render(
      canvas,
      position: Vector2(0, 0),
      size: Vector2(size.width, size.height),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
