import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class AnimalProvider extends ChangeNotifier {
  String? name;
  String? selectedAnimal;
  late String selectedAnimalImage;

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
}
