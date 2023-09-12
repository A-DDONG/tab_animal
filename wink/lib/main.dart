import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Winking Cat Animation'),
        ),
        body: const Center(
          child: WinkingCat(),
        ),
      ),
    );
  }
}

class WinkingCat extends StatefulWidget {
  const WinkingCat({super.key});

  @override
  _WinkingCatState createState() => _WinkingCatState();
}

class _WinkingCatState extends State<WinkingCat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Image> _images;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat();

    _images = [
      Image.asset('assets/images/wink1.png'),
      Image.asset('assets/images/wink2.png'),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        int index =
            (_controller.value * _images.length).toInt() % _images.length;
        return _images[index];
      },
    );
  }
}
