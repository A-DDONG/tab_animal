import 'package:flutter/material.dart';
import 'package:tab_animal/game/game_title.dart';

class TitleSplash extends StatefulWidget {
  const TitleSplash({super.key});

  @override
  State<TitleSplash> createState() => _TitleSplashState();
}

class _TitleSplashState extends State<TitleSplash>
    with SingleTickerProviderStateMixin {
  // 애니메이션 컨트롤러 Mixin 필드정의
  late AnimationController _controller;
  late Animation<double> _dropAnimation;
  late Animation<double> _fadeAnimation;
  late double screenHeight;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 총 애니메이션 시간
    );

    _controller.forward(); // 애니메이션 시작

    // 4초 후 화면이동
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const GameTitle()));
    });
  }

  // initState 이후 미디어 쿼리 가져옴
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight = MediaQuery.of(context).size.height; // 화면 높이 저장

    // 떨어지는 애니메이션 정의
    _dropAnimation = Tween<double>(
            begin: -screenHeight / 2,
            end: screenHeight / 2 - 150) // 이미지 사이즈에 맞게 조절
        .animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(
            0.0,
            0.5,
            curve: Curves.bounceOut, // 떨어지면서 튕기는 효과
          )),
    );

    // 페이딩 애니메이션 정의
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.6,
          1.0,
          curve: Curves.easeOut, // 서서히 사라짐
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: _dropAnimation.value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Image.asset(
                    "assets/images/title_splash.png",
                    width: 300,
                    height: 300,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
