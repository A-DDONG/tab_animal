import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_animal/game/main_game_menu.dart';
import 'package:tab_animal/game/walking_game.dart';
import 'package:tab_animal/game/game_inventory.dart';
import 'package:tab_animal/provider/animal_provider.dart';
import 'package:tab_animal/provider/bgm_provider.dart';

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
  Sprite? topMenuSprite;
  Sprite? inventorySprite;

  WalkingGame? walkingGame;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    walkingGame ??= WalkingGame(context, (newMap) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<BgmProvider>(context, listen: false)
          .playBgm('main_background.mp3');
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
      topMenuSprite = Sprite(image,
          srcPosition: Vector2(40, 80), srcSize: Vector2(280, 40));
      inventorySprite =
          Sprite(image, srcPosition: Vector2(0, 128), srcSize: Vector2(16, 16));
    });
  }

  double scaleValue = 1.0; // 이미지 크기 조절 변수

  bool _isMenuOpen = false; // 메뉴가 열려있는지 확인하는 변수
  bool _isInventoryOpen = false; // 인벤토리가 열려있는지 확인하는 변수

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _toggleInventory() {
    setState(() {
      // 인벤토리 표시 로직
      _isInventoryOpen = !_isInventoryOpen; // 상태를 토글합니다.
    });
  }

  List<Widget> buildEventMenuButtons(Sprite? sprite, GameMap currentMap) {
    if (sprite == null) return [];
    List<String> buttonTexts;
    List<double> buttonOffsets;

    if (currentMap == GameMap.home) {
      buttonTexts = ['산책', '상점', '가방', '정보'];
      buttonOffsets = [20.0, 120.0, 220.0, 320.0];
    } else {
      buttonTexts = ['귀환', '상점', '가방', '정보'];
      buttonOffsets = [20.0, 120.0, 220.0, 320.0];
    }

    return List.generate(buttonTexts.length, (index) {
      return Positioned(
          left: buttonOffsets[index],
          top: 750,
          child: GestureDetector(
            onTap: () {
              setState(() {
                // 상태 업데이트
                if (buttonTexts[index] == '산책') {
                  print("산책 버튼 클릭됨");
                  walkingGame?.switchMap(GameMap.walking);
                  // 산책 맵 BGM 재생
                  Provider.of<BgmProvider>(context, listen: false)
                      .playBgm('walking_background.mp3');
                } else if (buttonTexts[index] == '귀환') {
                  print("집 버튼 클릭됨");
                  walkingGame?.switchMap(GameMap.home);
                  // 메인 화면 BGM 재생
                  Provider.of<BgmProvider>(context, listen: false)
                      .playBgm('main_background.mp3');
                } else if (buttonTexts[index] == '가방') {
                  _toggleInventory();
                } else if (buttonTexts[index] == '상점' ||
                    buttonTexts[index] == '정보') {
                  // 상점 또는 정보 버튼을 눌렀을 때 Dialog를 표시
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(buttonTexts[index]), // 상점 또는 정보
                        content: const Text(
                          "업데이트 예정",
                          style: TextStyle(fontSize: 40),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Dialog 닫기
                            },
                            child: const Text("확인"),
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            },
            child: CustomPaint(
              size: const Size(75, 75),
              painter: SpritePainter(sprite,
                  text: buttonTexts[index], textOffset: const Offset(19, 25)),
            ),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final animalProvider =
        Provider.of<AnimalProvider>(context); // animalProvider 정의
    Sprite? equippedItemSprite =
        Provider.of<AnimalProvider>(context).equippedItemSprite;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          WalkingGameWidget(walkingGame: walkingGame!),
          if (topMenuSprite != null)
            Stack(
              children: [
                Positioned(
                  left: 10,
                  top: 20,
                  child: CustomPaint(
                    size: const Size(390, 100),
                    painter: SpritePainter(
                      topMenuSprite!,
                      textOffsets: {
                        '메뉴': const Offset(13, 20),
                        '이름: ${animalProvider.name ?? '알 수 없음'}':
                            const Offset(100, 20),
                        '종류: ${animalProvider.getSelectedAnimalInKorean()}':
                            const Offset(280, 20),
                        '레벨: ${animalProvider.level}': const Offset(13, 60),
                        '경험치: ${animalProvider.exp} / ${animalProvider.expRequiredForNextLevel}':
                            const Offset(100, 60),
                        '공격력: ${animalProvider.attackPower}':
                            const Offset(280, 60),
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 180,
                  top: 130,
                  child: CustomPaint(
                    size: const Size(64.0, 64.0), // 렌더링할 크기
                    painter: EquippedItemPainter(
                        equippedItemSprite), // CustomPainter 인스턴스
                  ),
                ),
                Positioned(
                  left: 10 + 13, // '메뉴' 텍스트의 x 좌표
                  top: 20 + 20, // '메뉴' 텍스트의 y 좌표
                  child: GestureDetector(
                    onTap: () {
                      _toggleMenu(); // 메뉴를 열거나 닫습니다.
                    },
                    child: Container(
                      width: 50, // '메뉴' 텍스트의 너비
                      height: 20, // '메뉴' 텍스트의 높이
                      color: Colors.transparent, // 투명한 색
                    ),
                  ),
                ),
              ],
            ),
          ...buildEventMenuButtons(eventMenuSprite, walkingGame!.currentMap),

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
                    painter: SpritePainter(eventMenuSprite!,
                        text: '먹이', textOffset: const Offset(30, 40)),
                  ),
                ),
              ),
            ),
          // 메뉴 화면 추가
          if (_isMenuOpen)
            Positioned.fill(
              child: MainMenu(
                onClose: () {
                  _toggleMenu(); // 메뉴를 닫습니다.
                },
              ),
            ),
          if (_isInventoryOpen && inventorySprite != null)
            InventoryWidget(
              inventorySprite: inventorySprite,
              inventory: animalProvider.inventory,
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
    );
  }
}

class SpritePainter extends CustomPainter {
  final Sprite sprite;
  final String? text; // 기존의 단일 텍스트
  final Offset? textOffset; // 기존의 단일 오프셋
  final Map<String, Offset>? textOffsets; // 새로운 여러 텍스트와 오프셋

  SpritePainter(this.sprite, {this.text, this.textOffset, this.textOffsets});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromRGBO(255, 255, 255, 1.0); // 메뉴 투명도조절
    sprite.render(
      canvas,
      position: Vector2(0, 0),
      size: Vector2(size.width, size.height),
      overridePaint: paint,
    );

    // 기존의 단일 텍스트 그리기
    if (text != null && textOffset != null) {
      _drawText(canvas, size, text!, textOffset!);
    }

    // 새로운 여러 텍스트 그리기
    textOffsets?.forEach((text, offset) {
      _drawText(canvas, size, text, offset);
    });
  }

  void _drawText(Canvas canvas, Size size, String text, Offset offset) {
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
          color: Colors.white, fontSize: 20, fontFamily: 'Mabinogi'),
    );
    final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class EquippedItemPainter extends CustomPainter {
  final Sprite? equippedItemSprite;

  EquippedItemPainter(this.equippedItemSprite);

  @override
  void paint(Canvas canvas, Size size) {
    // 사각형 테두리 그리기
    final Paint borderPaint = Paint()
      ..color = const Color.fromRGBO(60, 58, 82, 0.5)
      ..style = PaintingStyle.fill
      ..strokeWidth = 3.0;

    final Rect borderRect = Rect.fromPoints(
      const Offset(0, 0),
      Offset(size.width, size.height),
    );

    canvas.drawRect(borderRect, borderPaint);

    // 아이템 스프라이트 그리기
    equippedItemSprite?.render(
      canvas,
      position: Vector2(0, 0),
      size: Vector2(size.width, size.height),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
