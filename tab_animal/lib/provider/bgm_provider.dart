import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

class BgmProvider extends ChangeNotifier with WidgetsBindingObserver {
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  void playBgm() {
    if (!_isPlaying) {
      FlameAudio.bgm.play('background_music.mp3');
      _isPlaying = true;
      notifyListeners();
    }
  }

  void stopBgm() {
    if (_isPlaying) {
      FlameAudio.bgm.stop();
      _isPlaying = false;
      notifyListeners();
    }
  }

  BgmProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      stopBgm();
    } else if (state == AppLifecycleState.resumed) {
      playBgm();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
