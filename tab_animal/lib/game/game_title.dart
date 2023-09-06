import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ))
        ],
      ),
    );
  }
}
