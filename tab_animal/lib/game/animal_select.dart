import 'package:flutter/material.dart';

class AnimalSelect extends StatefulWidget {
  const AnimalSelect({super.key});

  @override
  State<AnimalSelect> createState() => _AnimalSelectState();
}

class _AnimalSelectState extends State<AnimalSelect> {
  final animalImages = [
    'assets/images/dog.png',
    'assets/images/penguin.png',
    'assets/images/cat.png',
  ];
  final pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.toInt();
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              "assets/images/select_background.png",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final boxHeight = constraints.maxHeight;
                final boxWidth = constraints.maxWidth;
                return Stack(
                  children: [
                    Image.asset(
                      "assets/images/select_box.png",
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: boxHeight * 0.2,
                      left: 0,
                      right: 0,
                      child: const Center(
                        child: Text(
                          "동물 캐릭터 선택",
                          style: TextStyle(
                            fontSize: 40,
                            color: Color.fromRGBO(72, 106, 174, 1.0),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: boxHeight * 0.27,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: 300,
                        child: PageView.builder(
                          controller: pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: animalImages.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Image.asset(
                                animalImages[index],
                                width: 200,
                                height: 200,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: boxHeight * 0.17,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (currentPage > 0)
                              ElevatedButton(
                                onPressed: () {
                                  pageController.jumpToPage(currentPage - 1);
                                },
                                child: const Text("이전"),
                              ),
                            ElevatedButton(
                              onPressed: () {
                                // 선택 버튼을 눌렀을 때의 로직
                              },
                              child: const Text('선택'),
                            ),
                            if (currentPage < animalImages.length - 1)
                              ElevatedButton(
                                onPressed: () {
                                  pageController.jumpToPage(currentPage + 1);
                                },
                                child: const Text("다음"),
                              ),
                          ],
                        ))
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
