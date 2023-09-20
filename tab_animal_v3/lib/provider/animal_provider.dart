import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class AnimalProvider extends ChangeNotifier with WidgetsBindingObserver {
  String? name;
  String? selectedAnimal;
  late String selectedAnimalImage;
  int exp = 0;
  int level = 1;
  int attackPower = 10;
  int expRequiredForNextLevel = 150;
  List<Map<String, dynamic>> inventory = []; // 인벤토리 리스트
  final Random rng = Random(); // 랜덤 객체 생성
  Map<String, dynamic>? equippedItem; // 장착된 아이템 정보
  int? getEquippedItemId() {
    return equippedItem?['id'] as int?;
  }

  Sprite? equippedItemSprite;

  AnimalProvider() {
    print('AnimalProvider 생성됨');
    WidgetsBinding.instance.addObserver(this); // Observer 등록
  }

  Future<void> initializeProvider(BuildContext context, String uid) async {
    print('initializeProvider 호출됨: $uid');
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        print('사용자 데이터 불러오기 성공: ${doc.data()}');
        name = doc['name'] ?? 'default_name';
        selectedAnimal = doc['selectedAnimal'] ?? 'default_animal';
        exp = doc['exp'] ?? 0;
        level = doc['level'] ?? 1;
        attackPower = doc['attackPower'] ?? 10;
        expRequiredForNextLevel = doc['expRequiredForNextLevel'] ?? 150;
        inventory = List<Map<String, dynamic>>.from(doc['inventory'] ?? []);
        equippedItem = doc['equippedItem']; // 착용 중인 아이템 정보 불러오기
        // 착용 중인 아이템이 있다면
        if (equippedItem != null) {
          int? itemIndex = equippedItem!['index'];
          int spriteRow = itemIndex! ~/ 5;
          int spriteCol = itemIndex % 5;

          equippedItemSprite = Sprite(
            await Flame.images.load('ui_sprite.png'),
            srcPosition: Vector2(32.0 * spriteCol.toDouble(),
                160.0 + 32.0 * spriteRow.toDouble()),
            srcSize: Vector2(32.0, 32.0),
          );
          // 초기 공격력을 설정 (착용 아이템의 공격력을 뺀 값)
          attackPower -= (equippedItem!['attackPower'] as num).toInt();

          // 다시 착용 아이템의 공격력을 더함
          attackPower += (equippedItem!['attackPower'] as num).toInt();
        }
      } else {
        print('사용자 데이터 없음, 초기값 설정');
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': name,
          'exp': 0,
          'level': 1,
          'attackPower': 10,
          'selectedAnimal': selectedAnimal,
          'expRequiredForNextLevel': 150,
        });
      }
      notifyListeners();
    } catch (e) {
      print('Error initializing provider: $e');
    }
  }

  final animalImageMap = {
    'dog': 'assets/images/dog.png',
    'cat': 'assets/images/cat.png',
    'penguin': 'assets/images/penguin.png',
  };

  final animalNameMap = {
    'dog': '개',
    'cat': '고양이',
    'penguin': '펭귄',
  };

  final animalSpriteMap = {
    'dog': 'dog_sprite.png',
    'cat': 'cat_sprite.png',
    'penguin': 'penguin_sprite.png',
  };

  String getSelectedAnimalSprite() {
    return animalSpriteMap[selectedAnimal] ?? '';
  }

  String getSelectedAnimalInKorean() {
    return animalNameMap[selectedAnimal] ?? '알 수 없음';
  }

  void setName(String newName) {
    name = newName;
    notifyListeners();
  }

  void setSelectedAnimal(String newAnimal) {
    selectedAnimal = newAnimal;
    selectedAnimalImage = animalImageMap[newAnimal] ?? '';
    notifyListeners();
  }

  void playAnimalSound(String selectedAnimal) {
    String soundFile = '$selectedAnimal.mp3';
    FlameAudio.play(soundFile);
  }

  void addItemWithRandomAttackPower(int itemIndex) {
    int attackPower = 0;
    String itemType = '';
    String itemName = ''; // 추가
    Color itemColor = Colors.transparent; // 초기값을 설정해주세요.
    // 고유한 id 생성 (예: 현재 시간을 밀리초로)
    int itemId = DateTime.now().millisecondsSinceEpoch;

    switch (itemIndex) {
      case 0: // 매직
        attackPower = rng.nextInt(21); // 0 ~ 20
        itemType = 'magic';
        itemName = '매직 사료';
        itemColor = Colors.green;
        break;
      case 1: // 레어
        attackPower = 10 + rng.nextInt(31); // 10 ~ 40
        itemType = 'rare';
        itemName = '레어 사료';
        itemColor = Colors.blue;
        break;
      case 2: // 에픽
        attackPower = 20 + rng.nextInt(41); // 20 ~ 60
        itemType = 'epic';
        itemName = '에픽 사료';
        itemColor = Colors.purple;
        break;
      case 3: // 레전더리
        attackPower = 30 + rng.nextInt(51); // 30 ~ 80
        itemType = 'legendary';
        itemName = '레전더리 사료';
        itemColor = Colors.orange;
        break;
      case 4: // 유니크
        attackPower = 40 + rng.nextInt(61); // 40 ~ 100
        itemType = 'unique';
        itemName = '유니크 사료';
        itemColor = Colors.yellow;
        break;
      default:
        break;
    }

    // 인벤토리에 아이템 추가
    Map<String, dynamic> newItem = {
      'id': itemId, // 고유한 id 추가
      'type': itemType,
      'attackPower': attackPower,
      'name': itemName, // 추가
      'color': itemColor.value, // 색상의 정수 값 저장
      'index': itemIndex,
    };
    inventory.add(newItem);

    // Firebase에 아이템 정보 저장
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'inventory': inventory,
      });
    } catch (e) {
      print('Error updating inventory: $e');
    }

    notifyListeners();
  }

  void equipItem(Map<String, dynamic> item) async {
    if (equippedItem != null) {
      unequipItem(); // 이미 장착된 아이템이 있다면 해제
    }
    equippedItem = item;
    attackPower += (item['attackPower'] as num).toInt(); // 공격력 증가

    // 스프라이트 생성
    int? itemIndex = item['index'];
    int spriteRow = itemIndex! ~/ 5;
    int spriteCol = itemIndex % 5;

    equippedItemSprite = Sprite(
      await Flame.images.load('ui_sprite.png'),
      srcPosition: Vector2(
          32.0 * spriteCol.toDouble(), 160.0 + 32.0 * spriteRow.toDouble()),
      srcSize: Vector2(32.0, 32.0),
    );

    // Firebase 업데이트 로직
    updateFirebase();

    notifyListeners();
  }

  void unequipItem() {
    if (equippedItem != null) {
      attackPower -= (equippedItem!['attackPower'] as num).toInt(); // 공격력 감소
      equippedItem = null;
      equippedItemSprite = null; // 이 부분을 추가합니다.

      // Firebase 업데이트 로직
      updateFirebase();
    }

    notifyListeners();
  }

  void updateFirebase() {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'attackPower': attackPower,
        'equippedItem': equippedItem,
        // 기타 필요한 필드
      });
    } catch (e) {
      print('Error updating Firebase: $e');
    }
  }

  void removeItem(Map<String, dynamic> item) async {
    // async 키워드 추가
    // 인벤토리에서 아이템을 삭제
    inventory.remove(item);

    // 아이템이 장착 중이라면 해제
    if (equippedItem == item) {
      unequipItem();
    }

    // Firebase Firestore에서 인벤토리 업데이트
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      await userDocRef.update({
        'inventory': inventory, // 인벤토리 전체를 업데이트
      });
    } catch (e) {
      print('Error updating inventory in Firestore: $e');
    }

    notifyListeners(); // UI 업데이트
  }

  void gainExp() async {
    exp += attackPower;

    // 경험치가 다음 레벨에 필요한 경험치 이상인 경우 레벨업 처리
    while (exp >= expRequiredForNextLevel) {
      exp -= expRequiredForNextLevel; // 레벨업에 사용된 경험치만큼 차감
      level += 1; // 레벨업
      attackPower += 5; // 레벨업할 때마다 공격력 5씩 증가

      // 다음 레벨에 필요한 경험치를 계산 (옵션)
      expRequiredForNextLevel = level * 150; // 예시
    }
    // Firebase에도 저장

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      DocumentSnapshot docSnapshot = await userDocRef.get();
      if (docSnapshot.exists) {
        await userDocRef.update({
          'exp': exp,
          'level': level,
          'attackPower': attackPower,
          'name': name,
          'selectedAnimal': selectedAnimal,
          'expRequiredForNextLevel': expRequiredForNextLevel,
        });
      } else {
        await userDocRef.set({
          'exp': exp,
          'level': level,
          'attackPower': attackPower,
          'name': name,
          'selectedAnimal': selectedAnimal,
          'expRequiredForNextLevel': expRequiredForNextLevel,
        });
      }
    } catch (e) {
      print('Error updating exp and level: $e');
    }

    notifyListeners(); // 상태가 변경되었음을 알림
  }

  void resetGameData() async {
    try {
      // 현재 로그인한 사용자의 UID를 가져옵니다.
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // 초기화할 데이터를 설정합니다.
      Map<String, dynamic> initialData = {
        'name': null,
        'exp': 0,
        'level': 1,
        'attackPower': 10,
        'selectedAnimal': null,
        'expRequiredForNextLevel': 150,
        'inventory': [],
        'equippedItem': null,
      };

      // 파이어스토어에서 해당 사용자의 데이터를 초기화합니다.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(initialData);

      // 로컬 상태도 초기화합니다. (AnimalProvider 클래스 내부에서)
      name = null;
      exp = 0;
      level = 1;
      attackPower = 10;
      selectedAnimal = null;
      expRequiredForNextLevel = 150;
      inventory.clear();
      equippedItem = null;

      notifyListeners(); // UI 업데이트를 위해 상태 변경을 알립니다.
    } catch (e) {
      print('Error resetting game data: $e');
    }
  }

  // 게임 정보를 삭제하는 함수
  Future<void> deleteGameData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error deleting game data: $e');
    }

    // 유저 로그아웃
    // await FirebaseAuth.instance.signOut();
    // 유저 삭제
    await FirebaseAuth.instance.currentUser?.delete();
  }
}
