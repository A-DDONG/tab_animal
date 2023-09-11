import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:tab_animal/sprite/components/animal_component.dart';
import 'package:tab_animal/sprite/constants/all_constants.dart';

class WalkingGame extends FlameGame with HasCollisionDetection {
  late double mapWidth = 1080;
  late double mapHeight = 1920;
  WalkingDirection direction = WalkingDirection.idle;
  final double characterSpeed = 380;
  final _world = World();

  // avatar sprint
  late AnimalComponent _avatar;

  // Background image
  late SpriteComponent _background;
  final Vector2 _backgroundSize = Vector2(1080, 1920);

  // Camera Components
  late final CameraComponent _cameraComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    overlays.add(KeyConstants.overlayKey);

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
      ..position =
          Vector2(mapWidth / 2 - 50, mapHeight / 2 - 50) // 50은 캐릭터 크기의 절반입니다.
      ..debugMode = true
      ..size = Vector2(100, 100);

    _world.add(_avatar);

    _cameraComponent = CameraComponent(world: _world)
      ..setBounds(Rectangle.fromLTRB(200, 430, mapWidth - 200, mapHeight - 430))
      ..viewfinder.anchor = Anchor.center
      ..follow(_avatar);

    addAll([_cameraComponent, _world]);
  }
}
