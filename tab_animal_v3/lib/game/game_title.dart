import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_animal/game/login/login_ui.dart';
import 'package:tab_animal/game/main_game.dart';
import 'package:tab_animal/provider/animal_provider.dart';
import 'package:tab_animal/provider/bgm_provider.dart';

class GameTitle extends StatefulWidget {
  const GameTitle({super.key});

  @override
  State<GameTitle> createState() => _GameTitleState();
}

class _GameTitleState extends State<GameTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<BgmProvider>(context, listen: false)
          .playBgm("title_background.mp3");
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // 애니메이션 상태에 따라 호출
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse(); // 애니메이션이 완료되면 역방향진행
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward(); // 애니메이션이 돌아오면 다시 시작
      }
    });
    _controller.forward(); // 애니메이션 시작
  }

// 삭제 버튼을 눌렀을 때 호출되는 함수
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('게임 정보 삭제'),
          content: const Text('게임 정보를 삭제하고 새로 시작하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 대화상자 닫기
              },
              child: const Text('아니오'),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<AnimalProvider>(context, listen: false)
                    .deleteGameData();
                Navigator.pop(context); // 대화상자 닫기
                // 로그인 화면으로 이동 또는 앱 재시작 로직
              },
              child: const Text('예'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        debugPrint('화면 탭됨');
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          String uid = currentUser.uid;
          debugPrint('사용자 있음: $uid');
          await Provider.of<AnimalProvider>(context, listen: false)
              .initializeProvider(context, uid);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainGame()));
        } else {
          debugPrint('사용자 없음, 로그인 팝업 표시');
          await showLoginPopup(context);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
                child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Image.asset(
                      "assets/images/game_title.png",
                      fit: BoxFit.cover,
                    ));
              },
            )),
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _showDeleteConfirmationDialog,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(60, 58, 82, 1.0))),
                child: const Text(
                  '초기화',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
