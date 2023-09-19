import 'dart:math';
import 'dart:async'; // Timer 클래스를 사용하기 위해 import
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_animal/provider/animal_provider.dart';
import 'package:tab_animal/sprite/components/animal_component.dart';
import 'package:tab_animal/sprite/constants/all_constants.dart';
import 'package:tab_animal/provider/bgm_provider.dart';

enum GameMap { home, walking }

class WalkingGame extends FlameGame with HasCollisionDetection {
  late double mapWidth = 1080;
  late double mapHeight = 1920;
  WalkingDirection direction = WalkingDirection.idle;
  final double characterSpeed = 100;
  final _world = World();
  late String animalSprite;
  late BuildContext context;
  TimerComponent? walkingTimerComponent; // 타이머변수
  int remainingTime = 6; // 남은 시간을 초 단위로 저장
  final Function(GameMap) onMapChanged;
  TextComponent? _remainingTimeText; // 남은시간표시

  // WalkingGame 클래스에 currentMap 상태 변수 추가
  GameMap currentMap = GameMap.home;

  // 산책맵 이벤트 변수
  TextComponent? _failText;
  final Random rng = Random();
  double eventTimer = 0.0; // 이벤트 타이머 변수 추가

  Future<void> switchMap(GameMap newMap) async {
    print("switchMap 함수가 호출되었습니다. 새로운 맵: $newMap"); // 로그 추가
    // print("스택 트레이스: ${StackTrace.current}"); // 스택 트레이스 출력
    currentMap = newMap;

    if (newMap == GameMap.walking) {
      // 산책 맵으로 설정
      _background.sprite = Sprite(await images.load('walking_background.png'));
      _avatar.position = Vector2(mapWidth / 2, mapHeight / 2);
      Provider.of<BgmProvider>(context, listen: false)
          .playBgm('walking_background.mp3');
    } else {
      // 홈 맵으로 설정
      _background.sprite = Sprite(await images.load('main_background.png'));
      _avatar.position = Vector2(mapWidth / 2, mapHeight / 2);
      Provider.of<BgmProvider>(context, listen: false)
          .playBgm('main_background.mp3');
    }
    if (newMap == GameMap.walking) {
      startWalkingTimer();
    } else if (newMap == GameMap.home) {
      if (walkingTimerComponent != null) {
        walkingTimerComponent!.timer.stop();
        remove(walkingTimerComponent!);
        walkingTimerComponent = null;
      }
      if (_remainingTimeText != null) {
        remove(_remainingTimeText!);
        _remainingTimeText = null;
      }
      remainingTime = 6;
    }
    onMapChanged(newMap); // 콜백 호출
  }

  void startWalkingTimer() {
    print("startWalkingTimer called");
    if (walkingTimerComponent != null) {
      print("Resetting and starting existing timer");
      remove(walkingTimerComponent!); // 기존 타이머 컴포넌트 제거
      walkingTimerComponent = null; // null로 설정
    } else {
      print("Creating new timer component");
      walkingTimerComponent = TimerComponent(
        period: 1.0, // 1초마다
        repeat: true, // 반복 실행
        onTick: () {
          print("onTick called");
          if (--remainingTime <= 0) {
            print("Timer ticked, remaining time: $remainingTime");
            walkingTimerComponent!.timer.stop(); // 타이머 중지
            switchMap(GameMap.home); // 메인 맵으로 이동
          }
          _updateRemainingTimeText();
        },
      );
      print("Adding new timer component to the game");
      add(walkingTimerComponent!); // 게임에 타이머 컴포넌트 추가
    }
    remainingTime = 30; // 남은 시간을 60초로 설정
  }

  void _updateRemainingTimeText() {
    // print("Updating remaining time text...");
    if (_remainingTimeText != null) {
      remove(_remainingTimeText!);
      _remainingTimeText = null;
    }
    _remainingTimeText = TextComponent(
      text: '남은 시간: $remainingTime',
      // 스타일 설정
      textRenderer: TextPaint(
        style: const TextStyle(
            fontSize: 48.0, color: Colors.red, fontFamily: 'Mabinogi'),
      ),
    )
      ..position = Vector2(mapWidth / 4 - 65, mapHeight / 4 + 60) // 위치 설정
      ..anchor = Anchor.center;

    add(_remainingTimeText!);
    // print("Added _remainingTimeText to the game.");
    // print("Remaining time: $remainingTime");
  }

  WalkingGame(this.context, this.onMapChanged) {
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
      // ..debugMode = true
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

    bool isMoving = !joystick.delta.isZero(); // 캐릭터가 이동 중인지 판단

    if (isMoving) {
      final velocity = joystick.relativeDelta;
      final newPosition = _avatar.position + (velocity * characterSpeed * dt);

      double halfWidth = _avatar.width / 2;
      double halfHeight = _avatar.height / 2;

      double newX = newPosition.x.clamp(halfWidth, mapWidth - halfWidth);
      double newY = newPosition.y.clamp(halfHeight, mapHeight - halfHeight);

      _avatar.position.setValues(newX, newY);
    }

    eventTimer += dt; // 타이머 증가

    if (eventTimer >= 2.0) {
      if (currentMap == GameMap.walking && isMoving) {
        // 이동 중일 때만 이벤트 발생
        if (rng.nextDouble() < 0.5) {
          triggerEvent();
        }
      }
      eventTimer = 0.0; // 타이머 초기화
    }
  }

  bool isEventInProgress = false; // 이벤트 진행 중인지 확인하는 플래그

  void triggerEvent() {
    if (isEventInProgress) {
      return; // 이벤트가 이미 진행 중이면 무시
    }
    isEventInProgress = true; // 이벤트 시작
    print("이벤트 발생!");

    // 기존에 _failText가 존재한다면 제거
    if (_failText != null) {
      remove(_failText!);
      _failText = null;
    }
    double chance = rng.nextDouble();
    if (chance < 0.5) {
      showFail();
    } else {
      double newItemChance = rng.nextDouble(); // 새로운 랜덤 값 생성
      gainItem(newItemChance);
      print(newItemChance);
    }
    Future.delayed(const Duration(seconds: 2), () {
      if (_failText != null) {
        remove(_failText!);
        _failText = null;
      }
      isEventInProgress = false; // 이벤트 종료
    });
  }

  void showFail() {
    // '꽝' 표시 로직 (기존 코드)
    // "꽝" 텍스트 표시 로직
    _failText = TextComponent(
      text: '꽝!',
      textRenderer: TextPaint(
        style: const TextStyle(
            fontSize: 48.0, color: Colors.red, fontFamily: 'Mabinogi'),
      ),
    )
      ..position = Vector2(mapWidth / 4 - 50, mapHeight / 4 - 200)
      ..anchor = Anchor.center;

    add(_failText!);
    Future.delayed(const Duration(seconds: 2), () {
      if (_failText != null) {
        remove(_failText!);
        _failText = null; // 제거 후 null로 설정
      }
    });
  }

  void gainItem(double chance) {
    int itemIndex = 0;
    String itemName = "매직 사료"; // 기본값
    Color itemColor = Colors.green; // 기본 색상

    if (chance < 0.2) {
      itemIndex = 4;
      itemName = "유니크 사료";
      itemColor = Colors.yellow;
      print(itemName);
    } else if (chance < 0.4) {
      itemIndex = 3;
      itemName = "레전더리 사료";
      itemColor = Colors.orange;
      print(itemName);
    } else if (chance < 0.6) {
      itemIndex = 2;
      itemName = "에픽 사료";
      itemColor = Colors.purple;
      print(itemName);
    } else if (chance < 0.8) {
      itemIndex = 1;
      itemName = "레어 사료";
      itemColor = Colors.blue;
      print(itemName);
    } else {
      itemIndex = 0;
      itemName = "매직 사료";
      itemColor = Colors.green;
      print(itemName);
    }

    final animalProvider = Provider.of<AnimalProvider>(context, listen: false);
    animalProvider.addItemWithRandomAttackPower(itemIndex); // 수정된 부분

    // 아이템 이름을 표시하는 텍스트 컴포넌트 추가
    _failText = TextComponent(
      text: "$itemName GET!",
      textRenderer: TextPaint(
        style: TextStyle(
            fontSize: 48.0,
            color: itemColor,
            fontFamily: 'Mabinogi',
            backgroundColor: const Color.fromRGBO(60, 58, 82, 0.5)),
      ),
    )
      ..position = Vector2(mapWidth / 4 - 50, mapHeight / 4 - 200)
      ..anchor = Anchor.center;

    add(_failText!);
    Future.delayed(const Duration(seconds: 2), () {
      if (_failText != null) {
        remove(_failText!);
        _failText = null; // 제거 후 null로 설정
      }
    });
  }
}
