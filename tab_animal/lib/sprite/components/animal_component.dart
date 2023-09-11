import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:tab_animal/game/walking_game.dart';
import 'package:tab_animal/sprite/constants/all_constants.dart';

class AnimalComponent extends SpriteAnimationComponent with HasGameRef {
  final WalkingGame walkingGame; // walkingGame을 WalkingGame으로 변경
  AnimalComponent({required this.walkingGame}) {
    add(RectangleHitbox());
  }
  late SpriteAnimation _downAnimation;
  late SpriteAnimation _leftAnimation;
  late SpriteAnimation _rightAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation _idleAnimation;
  final double _animationSpeed = .1;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load(AssetConstants.avatarImage),
      srcSize: Vector2(128 / 4, 256 / 8),
    );

    _downAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 4);
    _leftAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 4);
    upAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 4);
    _rightAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 4);
    _idleAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1);
    animation = _idleAnimation;
  }

  @override
  void update(double dt) {
    switch (walkingGame.direction) {
      case WalkingDirection.idle:
        animation = _idleAnimation;
        break;
      case WalkingDirection.down:
        animation = _downAnimation;
        if (y < walkingGame.mapHeight - height) {
          y += dt * walkingGame.characterSpeed;
        }
        break;
      case WalkingDirection.left:
        animation = _leftAnimation;
        if (x > 0) {
          x -= dt * walkingGame.characterSpeed;
        }
        break;
      case WalkingDirection.up:
        animation = upAnimation;
        if (y > 0) {
          y -= dt * walkingGame.characterSpeed;
        }
        break;
      case WalkingDirection.right:
        animation = _rightAnimation;
        if (x < walkingGame.mapWidth - width) {
          x += dt * walkingGame.characterSpeed;
        }
        break;
    }
    super.update(dt);
  }
}
