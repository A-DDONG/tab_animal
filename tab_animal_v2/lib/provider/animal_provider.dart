import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class AnimalProvider extends ChangeNotifier {
  String? name;
  String? selectedAnimal;
  late String selectedAnimalImage;
  int exp = 0;
  int level = 1;
  int attackPower = 10;
  int expRequiredForNextLevel = 150;

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

  void gainExp() {
    exp += attackPower;

    // 경험치가 다음 레벨에 필요한 경험치 이상인 경우 레벨업 처리
    while (exp >= expRequiredForNextLevel) {
      exp -= expRequiredForNextLevel; // 레벨업에 사용된 경험치만큼 차감
      level += 1; // 레벨업
      attackPower += 5; // 레벨업할 때마다 공격력 5씩 증가

      // 다음 레벨에 필요한 경험치를 계산 (옵션)
      expRequiredForNextLevel = level * 150; // 예시
    }

    notifyListeners(); // 상태가 변경되었음을 알림
  }
}
