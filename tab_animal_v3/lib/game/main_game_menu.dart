import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:tab_animal/game/game_title.dart';

class MainMenu extends StatelessWidget {
  final VoidCallback onClose; // 닫기 버튼을 위한 콜백

  const MainMenu({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlameAudio.play('menu_open.mp3');
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7), // 투명도를 적용한 배경색
      body: Stack(
        children: [
          // 배경 이미지 (menu_ui)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 400, // menu_ui의 너비
              height: 600, // menu_ui의 높이
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/menu_ui.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Stack(
                children: [
                  // 메뉴1 (menu1_ui)
                  Positioned(
                    left: 55, // x 좌표
                    top: 150, // y 좌표
                    child: GestureDetector(
                      onTap: () {
                        FlameAudio.play('menu_select.mp3'); // 메뉴 선택 효과음
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GameTitle(),
                          ),
                        );
                      },
                      child: Container(
                        width: 300,
                        height: 60,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/menu1_ui.png"),
                            fit: BoxFit
                                .cover, // 여기서는 BoxFit.cover를 사용했지만, 필요에 따라 다른 값으로 설정 가능합니다.
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 메뉴2 (menu2_ui)
                  Positioned(
                    left: 55, // x 좌표
                    top: 250, // y 좌표
                    child: Container(
                      width: 300,
                      height: 60,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/menu2_ui.png"),
                          fit: BoxFit
                              .cover, // 여기서는 BoxFit.cover를 사용했지만, 필요에 따라 다른 값으로 설정 가능합니다.
                        ),
                      ),
                    ),
                  ),
                  // 메뉴3 (menu2_ui)
                  Positioned(
                    left: 55, // x 좌표
                    top: 350, // y 좌표
                    child: Container(
                      width: 300,
                      height: 60,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/menu3_ui.png"),
                          fit: BoxFit
                              .cover, // 여기서는 BoxFit.cover를 사용했지만, 필요에 따라 다른 값으로 설정 가능합니다.
                        ),
                      ),
                    ),
                  ),
                  // 닫기 버튼
                  Positioned(
                    right: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: () {
                        onClose(); // 닫기 버튼을 누르면 onClose 콜백을 호출합니다.
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
