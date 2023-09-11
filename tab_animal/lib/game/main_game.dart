import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_animal/game/walking_game.dart';
import 'package:tab_animal/provider/animal_provider.dart';
import 'package:tab_animal/provider/bgm_provider.dart';
import 'package:tab_animal/sprite/constants/key_constants.dart';
import 'package:tab_animal/sprite/overlays/overlay_controller.dart';

class MainGame extends StatefulWidget {
  const MainGame({super.key});

  @override
  State<MainGame> createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> {
  Sprite? menuSprite;
  Sprite? nameBarSprite;
  Sprite? eventMenuSprite;
  Sprite? expBarSprite;

  WalkingGame walkingGame = WalkingGame();

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
      nameBarSprite =
          Sprite(image, srcPosition: Vector2(40, 0), srcSize: Vector2(200, 40));
      eventMenuSprite =
          Sprite(image, srcPosition: Vector2(240, 0), srcSize: Vector2(55, 55));
      expBarSprite = Sprite(image,
          srcPosition: Vector2(40, 40), srcSize: Vector2(160, 40));
    });
  }

  double scaleValue = 1.0; // 이미지 크기 조절 변수

  @override
  Widget build(BuildContext context) {
    final animalProvider =
        Provider.of<AnimalProvider>(context); // animalProvider 정의

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Container(
          //   margin: EdgeInsets.only(
          //     left: MediaQuery.of(context).size.width / 2, // 화면 너비의 1/4
          //     top: MediaQuery.of(context).size.height / 2, // 화면 높이의 1/4
          //   ),
          // width: 100,
          // height: 100,
          WalkingGameWidget(walkingGame: walkingGame),
          // ),
          // Positioned.fill(
          //   child: Image.asset(
          //     "assets/images/main_ui_background.png",
          //     fit: BoxFit.fill,
          //   ),
          // ),
          if (menuSprite != null)
            Positioned(
              left: 20,
              top: 60,
              child: CustomPaint(
                size: const Size(60, 60),
                painter: SpritePainter(menuSprite!,
                    text: '메뉴',
                    textOffset: const Offset(13, 20)), // text 매개변수 추가
              ),
            ),
          if (nameBarSprite != null)
            Positioned(
              left: 90, // 원하는 x 좌표
              top: 60, // 원하는 y 좌표
              child: CustomPaint(
                size: const Size(240, 60),
                painter: SpritePainter(nameBarSprite!,
                    text:
                        "이름: ${animalProvider.name ?? '알 수 없음'} / Lv: ${animalProvider.level}",
                    textOffset: const Offset(10, 20)),
              ),
            ),
          if (menuSprite != null)
            Positioned(
              left: 340,
              top: 60,
              child: CustomPaint(
                size: const Size(60, 60),
                painter: SpritePainter(menuSprite!,
                    text: animalProvider.getSelectedAnimalInKorean(),
                    textOffset: const Offset(4, 20)), // text 매개변수 추가
              ),
            ),
          if (eventMenuSprite != null)
            Positioned(
              left: 20, // 원하는 x 좌표
              top: 750, // 원하는 y 좌표
              child: CustomPaint(
                size: const Size(75, 75),
                painter: SpritePainter(eventMenuSprite!,
                    text: '산책', textOffset: const Offset(10, 18)),
              ),
            ),
          if (eventMenuSprite != null)
            Positioned(
              left: 120, // 원하는 x 좌표
              top: 750, // 원하는 y 좌표
              child: CustomPaint(
                size: const Size(75, 75),
                painter: SpritePainter(eventMenuSprite!,
                    text: '상점', textOffset: const Offset(10, 18)),
              ),
            ),
          if (eventMenuSprite != null)
            Positioned(
              left: 220, // 원하는 x 좌표
              top: 750, // 원하는 y 좌표
              child: CustomPaint(
                size: const Size(75, 75),
                painter: SpritePainter(eventMenuSprite!,
                    text: '가방', textOffset: const Offset(10, 18)),
              ),
            ),
          if (eventMenuSprite != null)
            Positioned(
              left: 320, // 원하는 x 좌표
              top: 750, // 원하는 y 좌표
              child: CustomPaint(
                size: const Size(75, 75),
                painter: SpritePainter(eventMenuSprite!,
                    text: '모름', textOffset: const Offset(10, 18)),
              ),
            ),
          if (expBarSprite != null)
            Positioned(
              left: 20, // 원하는 x 좌표
              top: 130, // 원하는 y 좌표
              child: CustomPaint(
                size: const Size(250, 60),
                painter: SpritePainter(expBarSprite!,
                    text:
                        '경험치: ${animalProvider.exp} / ${animalProvider.expRequiredForNextLevel}',
                    textOffset: const Offset(10, 20)),
              ),
            ),
          if (eventMenuSprite != null)
            Positioned(
              left: 160, // 원하는 x 좌표
              top: 600, // 원하는 y 좌표
              child: Transform.scale(
                scale: scaleValue, // 여기에 scaleValue를 적용
                child: GestureDetector(
                  onTap: () {
                    animalProvider.gainExp();
                    setState(() {
                      scaleValue = 1.2; // 크기를 증가시킵니다.
                    });
                    Future.delayed(const Duration(milliseconds: 100), () {
                      setState(() {
                        scaleValue = 1.0; // 원래 크기로 돌아옵니다.
                      });
                    });
                  },
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: SpritePainter(expBarSprite!,
                        text: '먹이', textOffset: const Offset(10, 20)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class WalkingGameWidget extends StatelessWidget {
  final WalkingGame walkingGame;

  const WalkingGameWidget({
    super.key,
    required this.walkingGame,
  });

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: walkingGame,
      overlayBuilderMap: {
        KeyConstants.overlayKey: (BuildContext context, WalkingGame game) {
          return OverlayController(game: game);
        }
      },
    );
  }
}

class SpritePainter extends CustomPainter {
  final Sprite sprite;
  final String text;
  final Offset textOffset; // 텍스트 위치를 조정할 Offset 값

  SpritePainter(this.sprite, {required this.text, required this.textOffset});

  @override
  void paint(Canvas canvas, Size size) {
    sprite.render(
      canvas,
      position: Vector2(0, 0),
      size: Vector2(size.width, size.height),
    );
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
          color: Colors.black, fontSize: 20, fontFamily: 'Mabinogi'),
    );
    final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset(
      (size.width - textPainter.width) / 2, // 가운데 정렬을 위한 x 좌표
      (size.height - textPainter.height) / 2, // 가운데 정렬을 위한 y 좌표
    );

    textPainter.paint(canvas, offset); // 생성자에서 받은 Offset 값 사용
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
