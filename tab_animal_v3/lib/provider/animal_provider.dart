import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimalProvider extends ChangeNotifier with WidgetsBindingObserver {
  String? name;
  String? selectedAnimal;
  late String selectedAnimalImage;
  int exp = 0;
  int level = 1;
  int attackPower = 10;
  int expRequiredForNextLevel = 150;

  AnimalProvider() {
    print('AnimalProvider 생성됨');
    WidgetsBinding.instance.addObserver(this); // Observer 등록
  }

  Future<void> initializeProvider(BuildContext context, String uid) async {
    print('initializeProvider 호출됨: $uid');
    // Firebase에서 UID에 해당하는 데이터 불러오기
    // 예: Firestore에서 불러오는 경우
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      print('사용자 데이터 불러오기 성공: ${doc.data()}');
      name = doc['name'];
      selectedAnimal = doc['selectedAnimal'];
      exp = doc['exp'];
      level = doc['level'];
      attackPower = doc['attackPower'];
      expRequiredForNextLevel = doc['expRequiredForNextLevel'];
    } else {
      print('사용자 데이터 없음, 초기값 설정');
      // 새로운 사용자의 경우 초기값으로 설정
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

    notifyListeners(); // 상태가 변경되었음을 알림
  }
}
