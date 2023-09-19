import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';
import 'package:tab_animal/provider/bgm_provider.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  bool isBgmOn = true;
  bool isSfxOn = true;
  String appVersion = "1.0.0"; // 예시 버전 정보

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(bottom: 0.0), // AppBar와 첫 번째 ListTile 간의 간격
          child: Text(
            "설정",
            style: TextStyle(fontSize: 25),
          ),
        ),
        backgroundColor: const Color.fromRGBO(60, 58, 82, 1.0),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0), // 첫 번째 ListTile 위쪽 간격
            child: ListTile(
              title: const Text(
                "배경음악",
                style: TextStyle(fontSize: 30),
              ),
              subtitle: Slider(
                value: isBgmOn ? Provider.of<BgmProvider>(context).volume : 0.0,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  setState(() {
                    Provider.of<BgmProvider>(context, listen: false)
                        .setVolume(value);
                    isBgmOn = value > 0.0;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 30.0), // 두 번째 ListTile 위, 아래 간격
            child: ListTile(
              title: const Text(
                "효과음",
                style: TextStyle(fontSize: 30),
              ),
              trailing: Switch(
                value: isSfxOn,
                onChanged: (value) {
                  setState(() {
                    isSfxOn = value;
                    // 효과음 On/Off 로직
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0), // 마지막 ListTile 아래쪽 간격
            child: ListTile(
              title: const Text(
                "버전 정보",
                style: TextStyle(fontSize: 30),
              ),
              subtitle: Text(
                "앱 버전: $appVersion",
                style: const TextStyle(fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
