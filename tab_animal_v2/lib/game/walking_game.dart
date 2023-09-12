import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:tab_animal/sprite/components/animal_component.dart';
import 'package:tab_animal/sprite/constants/all_constants.dart';

enum CharacterState { idle, walking }

class WalkingGame extends FlameGame
    with HasCollisionDetection, MultiTouchDragDetector, TapDetector {
  late double mapWidth = 1080;
  late double mapHeight = 1920;
  final _world = World();

  // avatar sprint
  late AnimalComponent _avatar;

  // Background image
  late SpriteComponent _background;
  final Vector2 _backgroundSize = Vector2(1080, 1920);

  // Camera Components
  late final CameraComponent _cameraComponent;

  Vector2? targetPosition;

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

    _avatar = AnimalComponent(walkingGame: this)
      ..position = Vector2(mapWidth / 2 - 50, mapHeight / 2 - 50)
      ..debugMode = true
      ..size = Vector2(100, 100);

    _avatar.anchor = Anchor.center;
    _world.add(_avatar);

    _cameraComponent = CameraComponent(world: _world)
      // ..setBounds(Rectangle.fromLTRB(200, 430, mapWidth - 200, mapHeight - 430))
      ..setBounds(Rectangle.fromLTRB(0, 0, mapWidth, mapHeight))
      ..viewfinder.anchor = Anchor.center
      ..follow(_avatar);
    print(
        "Target Position: $targetPosition, Current Position: ${_avatar.position}");

    addAll([_cameraComponent, _world]);
  }

  @override
  void onTapDown(TapDownInfo info) {
    _avatar.setTargetPosition(info.eventPosition.game);
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    _avatar.setTargetPosition(info.eventPosition.game);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    _avatar.setTargetPosition(info.eventPosition.game);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    _avatar.stopMoving();
  }
}
