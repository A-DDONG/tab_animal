import 'package:flutter/material.dart';
import 'package:tab_animal/game/name_input.dart';
import 'package:tab_animal/provider/animal_provider.dart';
import 'package:provider/provider.dart';
import 'package:tab_animal/provider/bgm_provider.dart';

class AnimalSelect extends StatefulWidget {
  const AnimalSelect({super.key});

  @override
  State<AnimalSelect> createState() => _AnimalSelectState();
}

class _AnimalSelectState extends State<AnimalSelect> {
  final animalNames = [
    'dog',
    'cat',
    'penguin',
  ];
  final pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<BgmProvider>(context, listen: false)
          .playBgm("title_background.mp3");
    });
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
    final animalProvider = Provider.of<AnimalProvider>(context, listen: false);
    final animalImages = animalNames
        .map((name) => animalProvider.animalImageMap[name]!)
        .toList();
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
                // final boxWidth = constraints.maxWidth;
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
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: currentPage > 0,
                              replacement: const SizedBox(
                                  width: 70), // 이 공간은 "이전" 버튼이 없을 때 차지합니다.
                              child: SizedBox(
                                width: 70,
                                child: ElevatedButton(
                                  onPressed: () {
                                    pageController.jumpToPage(currentPage - 1);
                                  },
                                  child: const Text("이전"),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10), // 여기서는 버튼과 버튼 사이의 간격을 조정
                            SizedBox(
                              width: 70,
                              child: ElevatedButton(
                                onPressed: () {
                                  animalProvider.setSelectedAnimal(
                                      animalNames[currentPage]);
                                  animalProvider.playAnimalSound(
                                      animalNames[currentPage]);
                                  // 선택 버튼을 눌렀을 때의 로직
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const NameInput())));
                                },
                                child: const Text('선택'),
                              ),
                            ),
                            const SizedBox(width: 10), // 여기서는 버튼과 버튼 사이의 간격을 조정
                            Visibility(
                              visible: currentPage < animalImages.length - 1,
                              replacement: const SizedBox(
                                  width: 70), // 이 공간은 "다음" 버튼이 없을 때 차지합니다.
                              child: SizedBox(
                                width: 70,
                                child: ElevatedButton(
                                  onPressed: () {
                                    pageController.jumpToPage(currentPage + 1);
                                  },
                                  child: const Text("다음"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
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
