import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:tab_animal/game/walking_game.dart';
import 'package:tab_animal/sprite/constants/all_constants.dart';

enum WalkingDirection { up, down, left, right, idle }

class AnimalComponent extends PositionComponent with HasGameRef {
  final WalkingGame walkingGame;
  late SpriteAnimationComponent spriteAnimationComponent;
  late Map<WalkingDirection, SpriteAnimation> animations;
  final double _animationSpeed = .1;
  Vector2? targetPosition;
  @override
  bool isLoaded = false;

  AnimalComponent({required this.walkingGame}) {
    // SpriteAnimationComponent 초기화는 onLoad에서 수행
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load(AssetConstants.avatarImage),
      srcSize: Vector2(128 / 4, 256 / 8),
    );

    animations = {
      WalkingDirection.down:
          spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 4),
      WalkingDirection.right:
          spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 4),
      WalkingDirection.up:
          spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 4),
      WalkingDirection.left:
          spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 4),
      WalkingDirection.idle:
          spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1),
    };

    spriteAnimationComponent = SpriteAnimationComponent(
      animation: animations[WalkingDirection.idle]!,
      size: Vector2(100, 100),
    );
    isLoaded = true; // onLoad가 완료되면 플래그를 true로 설정
  }

  void setTargetPosition(Vector2 position) {
    targetPosition = position;
  }

  void stopMoving() {
    targetPosition = null;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (targetPosition != null) {
      final moveVector = targetPosition! - position;
      const speed = 300.0; // 예를 들어, 300 픽셀/초

      // 새로운 위치 계산
      Vector2 newPosition = position + moveVector.normalized() * speed * dt;

      // 맵 경계 체크
      if (newPosition.x >= 0 &&
          newPosition.x <= walkingGame.mapWidth - width &&
          newPosition.y >= 0 &&
          newPosition.y <= walkingGame.mapHeight - height) {
        position = newPosition; // PositionComponent의 position 프로퍼티를 사용
      }

      // ... (방향 및 애니메이션 설정 코드)
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    spriteAnimationComponent.render(canvas);
  }
}
