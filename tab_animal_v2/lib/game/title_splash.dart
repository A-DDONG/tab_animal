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
  late Animation<double> _riseAnimation;
  late Animation<double> _sideAnimation;
  late Animation<double> _fadeAnimation;
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // 총 애니메이션 시간
    );

    _controller.forward(); // 애니메이션 시작
    // _controller.repeat();

    // 4초 후 화면이동
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const GameTitle()));
    });
    // _controller.addListener(() {
    //   print("Controller Value: ${_controller.value}");
    //   print("Drop Animation Value: ${_dropAnimation.value}");
    //   print("Rise Animation Value: ${_riseAnimation.value}");
    //   print("Side Animation Value: ${_sideAnimation.value}");
    //   print("Fade Animation Value: ${_fadeAnimation.value}");
    // });
  }

  // initState 이후 미디어 쿼리 가져옴
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight = MediaQuery.of(context).size.height; // 화면 높이 저장
    screenWidth = MediaQuery.of(context).size.width; // 화면 넓이 저장
    // 떨어지는 애니메이션 정의
    _dropAnimation = Tween<double>(
            begin: -screenHeight / 2,
            end: screenHeight / 2 - 150) // 이미지 사이즈에 맞게 조절
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.2,
          curve: Curves.bounceOut, // 떨어지면서 튕기는 효과
        ),
      ),
    );
    _riseAnimation = Tween<double>(
            begin: screenHeight * 2 - 300, end: screenHeight / 2 - 150)
        .animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.2, 0.4, curve: Curves.elasticOut)),
    );

    _sideAnimation =
        Tween<double>(begin: -300, end: screenWidth / 2 - 150).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.4, 0.7, curve: Curves.elasticOut)),
    );

    // 페이딩 애니메이션 정의
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.7,
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
                  // 드롭 애니메이션이 끝나고 라이즈 애니메이션이 시작되면 투명도를 0으로 설정
                  opacity: (_controller.value <= 0.2) ? 1 : 0,
                  child: Image.asset(
                    "assets/images/penguin.png",
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
              Positioned(
                top: _riseAnimation.value,
                child: Opacity(
                  // 라이즈 애니메이션이 시작되면 투명도를 1로 설정
                  opacity: (_controller.value > 0.2 && _controller.value <= 0.4)
                      ? 1
                      : 0,
                  child: Image.asset(
                    "assets/images/dog.png",
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
              Positioned(
                left: _sideAnimation.value,
                child: Opacity(
                  opacity: (_controller.value > 0.4 && _controller.value <= 0.7)
                      ? 1
                      : 0,
                  child: Image.asset("assets/images/cat.png",
                      width: 300, height: 300),
                ),
              ),
              Positioned(
                left: _sideAnimation.value,
                child: Opacity(
                  opacity: (_controller.value > 0.4 && _controller.value <= 0.7)
                      ? 1
                      : (_controller.value > 0.7 && _controller.value <= 1)
                          ? _fadeAnimation.value
                          : 0,
                  child: Image.asset(
                    "assets/images/cat.png",
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
