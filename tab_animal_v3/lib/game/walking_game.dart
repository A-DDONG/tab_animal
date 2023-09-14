import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_animal/provider/animal_provider.dart';
import 'package:tab_animal/sprite/components/animal_component.dart';
import 'package:tab_animal/sprite/constants/all_constants.dart';

class WalkingGame extends FlameGame with HasCollisionDetection {
  late double mapWidth = 1080;
  late double mapHeight = 1920;
  WalkingDirection direction = WalkingDirection.idle;
  final double characterSpeed = 100;
  final _world = World();
  late String animalSprite;

  WalkingGame(BuildContext context) {
    final animalProvider = Provider.of<AnimalProvider>(context, listen: false);
    animalSprite = animalProvider.getSelectedAnimalSprite();
  }

  // avatar sprint
  late AnimalComponent _avatar;

  // Background image
  late SpriteComponent _background;
  final Vector2 _backgroundSize = Vector2(1080, 1920);

  // Camera Components
  late final CameraComponent _cameraComponent;

  late JoystickComponent joystick;
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _background = SpriteComponent(
      sprite: Sprite(
        await images.load(AssetConstants.backgroundImage),
        srcPosition: Vector2(0, 0),
        srcSize: _backgroundSize,
      ),
      position: Vector2(0, 0),
      size: Vector2(1080, 1920),
    );
    _world.add(_background);

    _avatar = AnimalComponent(
      walkingGame: this,
      animalSprite: animalSprite,
    )
      ..position = Vector2(mapWidth / 2, mapHeight / 2) // 50은 캐릭터 크기의 절반입니다.
      ..debugMode = true
      ..size = Vector2(96, 96);

    _avatar.anchor = Anchor.center;

    _world.add(_avatar);

    _cameraComponent = CameraComponent(world: _world)
      ..setBounds(Rectangle.fromLTRB(200, 430, mapWidth - 200, mapHeight - 430))
      ..viewfinder.anchor = Anchor.center
      ..follow(_avatar);

    addAll([_cameraComponent, _world]);

    joystick = JoystickComponent(
      knob:
          CircleComponent(radius: 20, paint: Paint()..color = Colors.blueGrey),
      background: CircleComponent(
          radius: 60, paint: Paint()..color = Colors.blueGrey.withOpacity(0.5)),
      margin: const EdgeInsets.only(left: 280, bottom: 120),
    );

    add(joystick); // 게임에 조이스틱 컴포넌트 추가
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!joystick.delta.isZero()) {
      final velocity = joystick.relativeDelta;
      // print("velo: $velocity"); // 1. 조이스틱의 움직임 확인
      final newPosition = _avatar.position + (velocity * characterSpeed * dt);
      // print("new: $newPosition"); // 2. 새로운 위치 확인

      double halfWidth = _avatar.width / 2;
      double halfHeight = _avatar.height / 2;

      double newX = newPosition.x.clamp(halfWidth, mapWidth - halfWidth);
      double newY = newPosition.y.clamp(halfHeight, mapHeight - halfHeight);

      _avatar.position.setValues(newX, newY);
    }
  }
}
