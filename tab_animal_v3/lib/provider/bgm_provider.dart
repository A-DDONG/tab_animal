import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

class BgmProvider extends ChangeNotifier with WidgetsBindingObserver {
  String? _currentBgm;
  bool _isPlaying = false;
  double _volume = 1.0; // 초기 볼륨을 100%로 설정

  bool get isPlaying => _isPlaying;
  double get volume => _volume;

  void setVolume(double newVolume) {
    _volume = newVolume;
    notifyListeners();
  }

  void playBgm(String bgmName, {bool isLooping = false}) {
    if (_currentBgm != bgmName || !_isPlaying) {
      FlameAudio.bgm.stop(); // 현재 재생 중인 BGM을 멈춤
      if (isLooping) {
        FlameAudio.loop(bgmName, volume: _volume); // 루프 재생
      } else {
        FlameAudio.bgm.play(bgmName, volume: _volume); // 일반 재생
      }
      _currentBgm = bgmName;
      _isPlaying = true;
      notifyListeners();
    }
  }

  void stopBgm() {
    if (_isPlaying) {
      FlameAudio.bgm.stop();
      _isPlaying = false;
      _currentBgm = null;
      notifyListeners();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      stopBgm();
    } else if (state == AppLifecycleState.resumed) {
      if (_currentBgm != null) {
        playBgm(_currentBgm!);
      }
    }
  }

  BgmProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
