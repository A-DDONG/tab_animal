import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:tab_animal/game/walking_game.dart';
import 'package:tab_animal/sprite/constants/all_constants.dart';

enum AnimalState { walking, idle }

class AnimalComponent extends SpriteAnimationComponent with HasGameRef {
  final WalkingGame walkingGame;
  final String animalSprite;

  AnimalComponent({required this.walkingGame, required this.animalSprite}) {
    final hitbox = RectangleHitbox();
    hitbox.position = Vector2(-48, -48); // 중심을 기준으로 하므로 -48, -48
    hitbox.size = Vector2(96, 96); // 크기는 96, 96
    add(hitbox);
    // debugMode = true; // 디버그 모드 활성화
  }

  late SpriteAnimation _downAnimation;
  late SpriteAnimation _leftAnimation;
  late SpriteAnimation _rightAnimation;
  late SpriteAnimation _upAnimation;
  late SpriteAnimation _idleDownAnimation;
  late SpriteAnimation _idleLeftAnimation;
  late SpriteAnimation _idleRightAnimation;
  late SpriteAnimation _idleUpAnimation;

  final double _animationSpeed = .1;

  AnimalState currentState = AnimalState.idle;
  WalkingDirection currentDirection = WalkingDirection.down;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load(animalSprite),
      srcSize: Vector2(384 / 4, 768 / 8),
    );

    _downAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 4);
    _leftAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 4);
    _upAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 4);
    _rightAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 4);
    _idleDownAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1);
    _idleLeftAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 1);
    _idleUpAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 1);
    _idleRightAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 1);

    animation = _idleDownAnimation; // 초기값
  }

  @override
  void update(double dt) {
    super.update(dt);

    final velocity = walkingGame.joystick.relativeDelta;
    final newPosition = position + (velocity * walkingGame.characterSpeed * dt);

    double halfWidth = width / 2;
    double halfHeight = height / 2;

    double newX =
        newPosition.x.clamp(halfWidth, walkingGame.mapWidth - halfWidth);
    double newY =
        newPosition.y.clamp(halfHeight, walkingGame.mapHeight - halfHeight);

    position.setValues(newX, newY);

    if (velocity.x.abs() > velocity.y.abs()) {
      animation = velocity.x > 0 ? _rightAnimation : _leftAnimation;
      currentDirection =
          velocity.x > 0 ? WalkingDirection.right : WalkingDirection.left;
    } else if (velocity.y.abs() > 0) {
      animation = velocity.y > 0 ? _downAnimation : _upAnimation;
      currentDirection =
          velocity.y > 0 ? WalkingDirection.down : WalkingDirection.up;
    } else {
      switch (currentDirection) {
        case WalkingDirection.down:
          animation = _idleDownAnimation;
          break;
        case WalkingDirection.left:
          animation = _idleLeftAnimation;
          break;
        case WalkingDirection.up:
          animation = _idleUpAnimation;
          break;
        case WalkingDirection.right:
          animation = _idleRightAnimation;
          break;
        default:
          animation = _idleDownAnimation;
      }
      currentState = AnimalState.idle;
    }
    // print("posi: $position"); // 3. 현재 위치 확인
    // print(
    //     "State: $currentState, Direction: $currentDirection"); // 4. 애니메이션 상태 확인
  }
}
